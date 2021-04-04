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

(defun oql/todo ()
"todo itemss"
(interactive)
(org-ql-search
  (org-agenda-files)
  '(and (todo) (not (tags "tareas" "habits" "mantenimiento")))))

(defun oql/ongoing ()
"ongoing items"
(interactive)
(org-ql-search
  (org-agenda-files)
  '(and (todo "ONGOING") (not (tags "work"))))) 

(defun oql/ongoing-projects ()
"ongoing projects that are items"
(interactive)
(org-ql-search
  (org-agenda-files)
  '(and (todo "ONGOING") (not (tags "work")) (ltags "project")))) 


(defun oql/ongoing-left ()
"ongoing items that are not projects"
(interactive)
(org-ql-search
  (org-agenda-files)
  '(and (todo "ONGOING") (not (ltags "project"))))) 

(defun oql/work ()
"work items"
(interactive)
(org-ql-search
  (org-agenda-files)
  ' (tags "work")))

(defun oql/research ()
"items not done and not archived with tag research"
(interactive)
(org-ql-search
  (org-agenda-files)
  '(and (not (todo)) (not (tags "ARCHIVE")) (ltags "research"))))

(defun oql/learn ()
"items not done and not archived with tag learn or tag indepth"
(interactive)
(org-ql-search
  (org-agenda-files)
  '(and (not (todo)) (not (tags "ARCHIVE")) (ltags "learn" "indepth"))))

(defun oql/try ()
"items not done and not archived with tag try"
(interactive)
(org-ql-search
  (org-agenda-files)
  '(and (not (todo)) (not (tags "ARCHIVE")) (ltags "try")))) 
 
(defun oql/indepth ()
"items not done and not archived with tag indepth"
(interactive)
(org-ql-search
  (org-agenda-files)
  '(and (not (todo)) (not (tags "ARCHIVE")) (ltags "indepth"))))
 
(defun oql/refile ()
"refile items"
(interactive)
(org-ql-search
  (org-agenda-files)
  '(and (todo "REFILE") (not (tags "work")))))


(defun oql/verify ()
"verify items"
(interactive)
(org-ql-search
  (org-agenda-files)
  '(and (todo "VERIFY") (not (tags "work")))))

(defun oql/templates ()
"Entries with local tag \"template\""
(interactive)
(org-ql-search (org-agenda-files) '(ltags "template")))

(defun oql/habits ()
"Entries with local tag \"habits\""
(interactive)
(org-ql-search (org-agenda-files) '(or (ltags "habit") (property "STYLE" "habit"))))