(use-package! org-ql)
(use-package! org-ql-search)

(defun oql/refile-not-inbox ()
"REFILE entries not in Inbox"
(interactive)
(org-ql-search
  (org-agenda-files)
  '(and
    (todo "REFILE")
    (not
     (tags "inbox")))))

(defun oql/today ()
"sched for today"
(interactive)
(org-ql-search
  (org-agenda-files)
  '(and (todo) (scheduled 1))
  :sort 'scheduled))

(defun oql/next-3-days ()
"sched for next 3 days"
(interactive)
(org-ql-search
  (org-agenda-files)
  '(and (todo) (not (tags "tareas" "habits" "mantenimiento")) (scheduled 3))
  :sort 'scheduled))

(defun oql/week ()
"sched for next 7 days"
(interactive)
(org-ql-search
  (org-agenda-files)
  '(and (todo) (not (tags "tareas" "habits" "mantenimiento")) (scheduled 7))
  :sort 'scheduled))

(defun oql/templates ()
"Entries with local tag \"template\""
(interactive)
(org-ql-search (org-agenda-files) '(ltags "template")))

(defun oql/habits ()
"Entries with local tag \"habits\""
(interactive)
(org-ql-search (org-agenda-files) '(or (ltags "habit") (property "STYLE" "habit"))))