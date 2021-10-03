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

;; Modified from https://hungyi.net/posts/org-mode-subtree-contents/
(defun lytex/org-return-subtree-contents ()
  "Get the content text of the subtree at point"
  (interactive)
  (if (org-before-first-heading-p)
      (message "Not in or on an org heading")
    (save-excursion
      ;; If inside heading contents, move the point back to the heading
      ;; otherwise `org-agenda-get-some-entry-text' won't work.
      (unless (org-on-heading-p) (org-previous-visible-heading 1))
      ;; Copy it with no properties
      (setq beginning-of-subtree-copy (point))
      (if (org-get-next-sibling)
          (prog2 (previous-line) (end-of-line)))
      (setq end-of-subtree-copy (point))
      (substring-no-properties
            (buffer-substring beginning-of-subtree-copy end-of-subtree-copy)))))

(use-package! cl-seq)

(defun lytex/tempate-fill ()
(interactive)
  (setq candidates
        (org-ql-query :select
                      '(list
                        (lytex/org-return-subtree-contents))
                      :from
                      (org-agenda-files)
                      :where
                      '(ltags "template"))))
