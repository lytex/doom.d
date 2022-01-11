;;; trc-workgraph.el --- Visualize org mode files as graphs  -*- lexical-binding: t; -*- <jacek@zlydach.pl>

;; Copyright (C) 2021  Jacek "TeMPOraL" Złydach

;; Author: Jacek "TeMPOraL" Złydach <jacek@zlydach.pl>
;; Keywords: org-mode

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

(require 'org-element)
(require 's)



;;; Current schema:
;;; Graph: (connectome nodelist)
;;; Connectome: # s{id -> ((id, relation-type)...)}
;;; Relation-type: finish-to-finish | start-to-finish
;;; Nodelist: (node...)
;;; Node: (id title todo-state tags first-sentence [date-start date-complete date-deadline])
;;; NOTE it has no concept of "groups" yet

;;; Some further notes for the future:
;;; - We can use { rank = same } blocks to make layout nicer
;;;   - see: http://graphs.grevian.org/example
;;; - We can apparently use syntax: node -> { node node node } to make linking moe compact
;;;   - Of dubious utility for us
;;; - Weight parameter can be used to hit which edges should be shorter

;;; Data structures constructors.

(defun trc/wg--make-connection (dependency-id relation-type &rest props)
  "Encode a connection to DEPENDENCY-ID node.
RELATION-TYPE is one of the supported relation types.
PROPS are other properties, unspecified as of yet."
  (list* :dependency-id dependency-id :relation-type relation-type props))

(defun trc/wg--make-node (id title todo-state tags first-sentence)
  "Encode a node representation.
ID is an org-id, TITLE is unformatted headline content,
TODO-STATE is the TODO keyword, TAGS are org mode tags,
FIRST-SENTENCE is the first sentence of the entry."
  (list :id id :title title :todo-state todo-state :tags tags :first-sentence first-sentence))


;;; Building up the dependency graph.

(defun trc/wg--node-eligible-p (headline)
  "True if HEADLINE is eligible for graphing."
  (not (null (org-element-property :ID headline))))

(defun trc/wg--node-identifier-from-org-headline (headline)
  "Compute an identifier to use for the node from its HEADLINE.
That is either org-id or its title."
  (or (org-element-property :ID headline) (org-element-property :raw-value headline)))

(defun trc/wg--node-from-org-headline (headline)
  "Turn a parsed org mode HEADLINE into a NODE."
  (trc/wg--make-node (trc/wg--node-identifier-from-org-headline headline)
                     (org-element-property :raw-value headline)
                     (org-element-property :todo-keyword headline)
                     (org-element-property :tags headline)
                     nil                ;TODO first-sentence
                     ))

(defun trc/wg--parse-edna-blockers (blockers)
  "Turn BLOCKERS into a list of (ID TYPE).
BLOCKERS are a string the form: id(foo bar baz)."
  (when (and blockers
             (string-match "ids(\\(.*\\))" blockers))
    ;; FIXME may not trim up tray spaces!
    (split-string (match-string 1 blockers))))

(defun trc/wg--connections-from-org-headline (headline)
  "Compute all immediate connections for a HEADLINE.
Return value is a list of entries, each of the form:
 (ID (CONNECTION-DATA)), which indicates a node of
ID is connected to another."
  (let ((connections (list)))
    (let ((node-id (trc/wg--node-identifier-from-org-headline headline))
          (parent-id (trc/wg--node-identifier-from-org-headline (org-element-property :parent headline)))
          (edna-blockers (trc/wg--parse-edna-blockers (org-element-property :BLOCKER headline))))
      ;; Parent-child dependency
      (when (trc/wg--node-eligible-p (org-element-property :parent headline))
        (push (list parent-id (trc/wg--make-connection node-id :finish-to-finish))
              connections))
      ;; EDNA blockers
      (dolist (blocker edna-blockers)
        (push (list node-id (trc/wg--make-connection blocker :finish-to-start)) connections)))
    (reverse connections)))


;;; Visualizing with Graphviz
(defun trc/wg--compute-node-label (node)
  "Return the label to use for the NODE."
  (let ((title (plist-get node :title))
        (printable-tags (remove "milestone" (plist-get node :tags))))
    (if printable-tags
        (format "<%s<br/><font point-size=\"9\">%s</font>>" title (s-join ":" printable-tags))
     (format "<%s>" title))))

(defun trc/wg--compute-node-attributes (node)
  "Return a string with extra attributes to style the NODE."
  (let ((color "black")
        (fontcolor "black")
        (shape "box")
        (styles (list)))
    ;; Special-case various node types!
    (let ((todo-kw (plist-get node :todo-state))
          (tags (plist-get node :tags)))
      ;; Milestones are star-like
      (when (member "milestone" tags)
        (setf shape "septagon"))

      ;; State determines color
      (setf color (cond ((equalp todo-kw "TODO")
                         "red")
                        ((equalp todo-kw "DOING")
                         "orange")
                        ((equalp todo-kw "DONE")
                         "darkolivegreen3")
                        (t "black")))

      ;; Tasks are rounded
      (unless (null todo-kw)
        (push "rounded" styles))

      ;; Done tasks are dashed, and text is lightened, to diminish them
      (when (equalp todo-kw "DONE")
        (push "dashed" styles)
        (setf fontcolor "darkslategrey")))

    (format "color=\"%s\",fontcolor=\"%s\"shape=\"%s\",style=\"%s\"" color fontcolor shape (s-join "," styles))))

(defun trc/wg--compute-edge-label (connection)
  "Compute label to be put on edge of a CONNECTION, if any."
  ;; TODO any relevant edge labels go here.
  ""
  )

(defun trc/wg--compute-edge-attributes (connection)
  "Compute additional styling for CONNECTION edge."
  (if (eq (plist-get connection :relation-type) :finish-to-finish)
      ;; penwidth=\"0.5\",
      "arrowhead=\"onormal\""
    ""))

(defun trc/wg--graphviz-encode-node (node)
  "Write out NODE definition for graphviz."
  (insert (format "\"%s\" [label=%s,%s]\n"
                  (plist-get node :id)
                  (trc/wg--compute-node-label node)
                  (trc/wg--compute-node-attributes node))))

(defun trc/wg--graphviz-encode-connection (from connection)
  "Write out graphviz edge.
FROM is the id of the source node, CONNECTION specifies
the target and properties of the edge."
  ;; TODO: perhaps a label if Finish-to-Finish? Or a different edge style?
  (insert (format "\"%s\" -> \"%s\" [label=\"%s\",%s]\n"
                  from
                  (plist-get connection :dependency-id)
                  (trc/wg--compute-edge-label connection)
                  (trc/wg--compute-edge-attributes connection))))


;;; Tying it all together

(defun trc/compute-org-task-graph ()
  "Return a graph for the org document, which is a (cons connectome nodelist)."
  (let ((connectome (make-hash-table :test 'equal))
        (nodelist (list)))
    (org-element-map (org-element-parse-buffer) 'headline
      (lambda (item)
        (when (trc/wg--node-eligible-p item)
          (dolist (connection (trc/wg--connections-from-org-headline item))
            (destructuring-bind (source-id link) connection
              (puthash source-id (cons link (gethash source-id connectome (list))) connectome)))
          (push (trc/wg--node-from-org-headline item) nodelist))
        (values)))
    (list connectome (reverse nodelist))))

(defun trc/org-task-graph-to-graphviz (connectome node-list)
  "Generate a dot graph from CONNECTOME and NODE-LIST."
  (with-temp-buffer
    ;; Preamble
    (insert "digraph G {\n")
    (insert "ranksep=0.5\n")
    (insert "nodesep=0.5\n")
    (insert "overlap=\"false\"\n")
    (insert "node [color=\"black\", fontsize=10, margin=\"0.055\" style=\"rounded\"]\n")
    (insert "edge [fontsize=10]\n")

    ;; List of tasks
    (mapc #'trc/wg--graphviz-encode-node node-list)

    ;; Connections
    (maphash (lambda (k v)
               (dolist (conn v)
                 (trc/wg--graphviz-encode-connection k conn)))
             connectome)

    ;; Postamble
    (insert "}\n")
    (buffer-string)))

(provide 'trc-workgraph)
;;; trc-workgraph.el ends here

