(use-package! org-ql)
(use-package! org-ql-search)

(setq org-super-agenda-groups '((:auto-planning)))

(load concat org-directory "org-ql-queries.el")

(map!
 :after org-ql
 :n "RET" #'org-ql-view-switch)

(define-key org-super-agenda-header-map "j" nil)
(define-key org-super-agenda-header-map "k" nil)
(define-key org-super-agenda-header-map "h" nil)
(define-key org-super-agenda-header-map "l" nil)

(setq org-highlight-sparse-tree-matches nil)

(defun lytex/org-sparse-tree-full ()
  "TODOs+MAYBE+SOMEDAY+idea"
  ;; "All TODOs including MAYBE, SOMEDAY and :idea:"
  (interactive)
  (org-ql-sparse-tree '(or (todo) (ltags "idea"))))

(defun lytex/org-sparse-tree-almost-full ()
  "TODOs+MAYBE+SOMEDAY-idea"
  ;; "All TODOs including MAYBE, SOMEDAY, but not :idea:"
  (interactive)
  (org-ql-sparse-tree '(todo)))

(defun lytex/org-sparse-tree-trimmed ()
  "TODOs-MAYBE-SOMEDAY"
  ;; "All TODOs excluding MAYBE, SOMEDAY"
  (interactive)
  (org-ql-sparse-tree '(and (todo) (not (todo "MAYBE" "SOMEDAY")))))
