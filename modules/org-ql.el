(use-package! org-ql)
(use-package! org-ql-search)

(setq org-super-agenda-groups '((:auto-planning)))


(setq org-ql-views
      '(

        ;; ("" :buffers-files
        ;;  org-agenda-files
        ;;  :query
        ;;  :sort (date) :narrow nil :super-groups org-super-agenda-groups :title "")


        ("Today" :buffers-files
         org-agenda-files
         :query (and (todo) (not (todo "MAYBE" "SOMEDAY")) )
         :sort (date) :narrow nil :super-groups org-super-agenda-groups nil :title "Today")

        ("Next 3 days" :buffers-files
         org-agenda-files
         :query (and (todo) (not (todo "MAYBE" "SOMEDAY")) (not (tags "tareas" "habits" "mantenimiento")) (scheduled 3))
         :sort (date) :narrow nil :super-groups org-super-agenda-groups :title "Next 3 days")

        ("Week" :buffers-files
         org-agenda-files
         :query (and (todo) (not (todo "MAYBE" "SOMEDAY")) (not (tags "tareas" "habits" "mantenimiento")) (scheduled 7))
         :sort (date) :narrow nil :super-groups org-super-agenda-groups :title "Week")

        ("To Do" :buffers-files
         org-agenda-files
         :query (and (todo) (not (todo "MAYBE" "SOMEDAY")) (not (tags "tareas" "habits" "mantenimiento")))
         :sort (date) :narrow nil :super-groups org-super-agenda-groups :title "To Do")

        ("OnGoing" :buffers-files
         org-agenda-files
         :query (and (todo "ONGOING") (not (tags "work")))
         :sort (date) :narrow nil :super-groups org-super-agenda-groups :title "OnGoing")

        ("OnGoing Projects" :buffers-files
         org-agenda-files
         :query (and (todo "ONGOING") (not (tags "work")) (ltags "project"))
         :sort (date) :narrow nil :super-groups org-super-agenda-groups :title "")

        ("Refile" :buffers-files
         org-agenda-files
         :query (and (todo "REFILE") (not (tags "work")))
         :sort (date) :narrow nil :super-groups org-super-agenda-groups :title "Refile")

        ("Refile not Inbox" :buffers-files
         org-agenda-files
         :query (and (todo "REFILE") (not (tags "inbox")))
         :sort (date) :narrow nil :super-groups ((:auto-category)) :title "Refile not Inbox")

        ("OnGoing Left" :buffers-files
         org-agenda-files
         :query (and (todo "ONGOING") (not (ltags "project")))
         :sort (date) :narrow nil :super-groups org-super-agenda-groups :title "OnGoing Left")

        ("Work" :buffers-files
         org-agenda-files
         :query (and (todo) (tags "work"))
         :sort (date) :narrow nil :super-groups org-super-agenda-groups :title "Work")

        ("Research" :buffers-files
         org-agenda-files
         :query (and (not (todo)) (not (tags "ARCHIVE")) (ltags "research"))
         :sort (date) :narrow nil :super-groups org-super-agenda-groups :title "Research")

        ("Learn" :buffers-files
         org-agenda-files
         :query (and (not (todo)) (not (tags "ARCHIVE")) (ltags "learn" "indepth"))
         :sort (date) :narrow nil :super-groups org-super-agenda-groups :title "Learn")

        ("Try" :buffers-files
         org-agenda-files
         :query
         :sort (date) :narrow nil :super-groups org-super-agenda-groups :title "Try")

        ("In Depth" :buffers-files
         org-agenda-files
         :query (and (not (todo)) (not (tags "ARCHIVE")) (ltags "indepth"))
         :sort (date) :narrow nil :super-groups org-super-agenda-groups :title "In Depth")

        ("Verify" :buffers-files
         org-agenda-files
         :query (and (todo "VERIFY") (not (tags "work")))
         :sort (date) :narrow nil :super-groups org-super-agenda-groups :title "Verify")

        ("Templates" :buffers-files
         org-agenda-files
         :query (ltags "template")
         :sort (date) :narrow nil :super-groups org-super-agenda-groups :title "Templates")

        ("Habits" :buffers-files
         org-agenda-files
         :query
         (or
          (tags "habit")
          (property "STYLE" "habit"))
         :sort (date) :narrow nil :super-groups org-super-agenda-groups :title "Habits")

        )
      )

(map!
 :after org-ql
 :n "RET" #'org-ql-view-switch)


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
