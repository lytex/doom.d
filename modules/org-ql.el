(use-package! org-ql)
(use-package! org-ql-search)

;; The queries are kept in a org-ql-queries.org, change quite often and are unrelated to emacs
;; They contain info about specific projects, for example
;; Symlink to wherever you may find useful (I kept mine in org-directory)
(load! "~/.doom.d/modules/org-ql-queries.el")

(defun lytex/reload-org-ql ()
  (interactive)
  (unload-feature 'org-ql :force)
  (unload-feature 'org-ql-view :force)
  (unload-feature 'org-ql-search :force)

  (load! "~/.doom.d/modules/org-ql.el"))

;; Follow link using RET, not only mouse-1
(map!
 :after org-ql
 :n "RET" #'org-ql-view-switch)

;; Tweaks to make hjkl work over a date in org-ql agenda
(define-key org-super-agenda-header-map "j" nil)
(define-key org-super-agenda-header-map "k" nil)
(define-key org-super-agenda-header-map "h" nil)
(define-key org-super-agenda-header-map "l" nil)

(setq org-highlight-sparse-tree-matches nil)

;; From https://github.com/alphapapa/org-super-agenda/blob/f5e80e4d0da6b2eeda9ba21e021838fa6a495376/examples.org#automatically-fold-certain-groups-with-origami
(use-package origami
  :config
  (define-key org-super-agenda-header-map (kbd "<tab>") #'origami-toggle-node)
  (defvar ap/org-super-agenda-auto-show-groups
    '("Schedule" "Bills" "Priority A items" "Priority B items"))

  (defun ap/org-super-agenda-origami-fold-default ()
    "Fold certain groups by default in Org Super Agenda buffer."
    (forward-line 3)
    (cl-loop do (origami-forward-toggle-node (current-buffer) (point))
             while (origami-forward-fold-same-level (current-buffer) (point)))
    (--each ap/org-super-agenda-auto-show-groups
      (goto-char (point-min))
      (when (re-search-forward (rx-to-string `(seq bol " " ,it)) nil t)
        (origami-show-node (current-buffer) (point)))))

  :hook ((org-agenda-mode . origami-mode)
         (org-agenda-finalize . ap/org-super-agenda-origami-fold-default)))



(defun lytex/org-get-subtree-contents ()
"Get the content text of the subtree at point"
       (concat
        (make-string (org-reduced-level (org-outline-level)) ?*)
        " "
        (substring-no-properties
         (org-get-heading))
        "\n"
        (substring-no-properties
         (org-get-entry))))


(defun lytex/get-template-by-id (id)
(eval `(defun ,(make-symbol id) ()
,(save-window-excursion (org-id-goto id) (replace-regexp-in-string
  ;; Remove ID to avoid duplicates
  ":ID:.*\n"
  ""
    (replace-regexp-in-string
    ;; Template is in the middle of two tags :left:template:right:
    ":template:" ":"
      (replace-regexp-in-string
        ;; There is one tag or more before template: :tag:template:
        "template:$" ""
        (replace-regexp-in-string
          ;; There is one tag or more after template: :template:tag:
          " :template" " "
          (replace-regexp-in-string
            ;; There is only one tag :template:
            " :template:$" ""
            (lytex/org-get-subtree-contents))))))))))


(load! "~/.doom.d/modules/org-ql-templates.el")

;; (lytex/set-org-templates (read-from-file "/home/julian/data.el"))

;; (use-package! async)
;; (async-start
;;  (print-to-file "/home/julian/data.el"
;;                 (lytex/get-org-templates)) nil)


(defun lytex/insert-query-links (query)
(org-ql-query :select
          '(concat "[["
                    (if
                        (cdar (org-entry-properties nil "ID"))
                        (concat "id:" (cdar (org-entry-properties nil "ID")))
                      (concat "file:" (buffer-file-name) "::*"
                              (substring-no-properties
                              (org-get-heading :no-tags :no-todo :no-priority :no-comment))))
                    "]["
                    (substring-no-properties
                    (org-get-heading :no-tags :no-todo :no-priority :no-comment))
                    "]]\n")
          :from
          (org-agenda-files)
          :where
          query))

(defun lytex/insert-query-transclusion (query level)
(org-ql-query :select
          '(concat "\n#+transclude: [["
                    (if
                        (cdar (org-entry-properties nil "ID"))
                        (concat "id:" (cdar (org-entry-properties nil "ID")))
                      (concat "file:" (buffer-file-name) "::*"
                              (substring-no-properties
                              (org-get-heading :no-tags :no-todo :no-priority :no-comment)))
                      )
                    "]["
                    (substring-no-properties
                    (org-get-heading :no-tags :no-todo :no-priority :no-comment))
                    (concat "]] :level " (number-to-string level) "\n"))

          :from
          (org-agenda-files)
          :where
          query))
