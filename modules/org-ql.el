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


;; (start-process "emacs" "org-templates" "emacs" "--batch" "--no-splash"
;; "--load" "$HOME/.config/emacs/lisp/doom-lib.el"
;; "--load" "$HOME/.config/emacs/lisp/doom.el"
;; "--load" "$HOME/.config/emacs/early-init.el"
;; "--load" "/home/julian/.config/emacs/lisp/doom-start.el"
;; "--load" "$HOME/.doom.d/utils/org-templates.el")


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

(defvar id nil) 

(let (_)
  (defvar x)      ; Let-bindings of x will be dynamic within this let.
  (let ((x -99))  ; This is a dynamic binding of x.
    (defun get-dynamic-x ()
      x)))

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

(defun read-from-file (filename)
  (with-temp-buffer
    (insert-file-contents filename)
    (cl-assert (eq (point) (point-min)))
    (read (current-buffer))))

(setq keyboard-list "jkl;asdfghuiopqwertynm,.zxcvbJKL:ASDFGHUIOPQWERTYNM<>ZXCVB1234567890-=!@#$%^&*()_+[]'/{}?")
(if (setq org-templates
      (with-demoted-errors "Error loading org-templates: %S"
        (read-from-file "/home/julian/.cache/org-templates")))
    (progn

        (setq iterating-list (substring keyboard-list 0 (length org-templates)))

        (appendq! org-capture-templates (cl-mapcar #'(lambda (key template)
        (setq id  (cdr template))
        `(,(concat "t" (make-string 1 key)) ,(car template) plain
        (file "Inbox.org")
        (function ,(lytex/get-template-by-id id))
        :unnarrowed t))
        iterating-list org-templates))
        )
    )


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

