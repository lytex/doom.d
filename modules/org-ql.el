(use-package! org-ql)
(use-package! org-ql-search)

(defun oql/refile-not-inbox ()
(interactive)
(org-ql-search
  (org-agenda-files)
  '(and
    (todo "REFILE")
    (not
     (tags "inbox")))))

(defun oql/today ()
(interactive)
(org-ql-search
  (org-agenda-files)
  '(todo)
  :sort 'scheduled))

(defun oql/next-3-days ()
(interactive)
(org-ql-search
  (org-agenda-files)
  '(and (todo) (not (tags "tareas" "habits" "mantenimiento")) (scheduled 3))
  :sort 'scheduled))

(defun oql/week ()
(interactive)
(org-ql-search
  (org-agenda-files)
  '(and (todo) (not (tags "tareas" "habits" "mantenimiento")) (scheduled 7))
  :sort 'scheduled))