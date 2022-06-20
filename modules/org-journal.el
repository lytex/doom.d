;; org-journal with three different journals

(defun lytex/set-work-journal ()
        (setq org-journal-file-type 'monthly)
        (setq org-journal-dir (concat org-directory "work_journal/"))
        (setq org-journal-file-format "%Y%mW.org")
        ;; All work journal files have the tag "work"
        (setq org-journal-file-header "#+TITLE:%Y%mW\n#+FILETAGS: :work:\n\n")
        (setq org-journal-date-format "%A, %d de %B de %Y :work:"))

(defun lytex/set-personal-journal ()
        (setq org-journal-file-type 'daily)
        (setq org-journal-dir (concat org-directory "journal/"))
        (setq org-journal-file-format "%Y-%m-%d.org")
        (setq org-journal-file-header "#+TITLE: %Y-%m-%d\n\n")
        (setq org-journal-date-format "%A, %d de %B de %Y"))

(defun lytex/set-introspection-journal ()
        (setq org-journal-file-type 'daily)
        ;; Workaround to work with orgzly -> each file must have a unique name
        (setq org-journal-file-format "%Y-%m-%dI.org")
        (setq org-journal-dir (concat org-directory "Introspección/"))
        (setq org-journal-file-header "#+TITLE: %Y-%m-%dI\n\n")
        (setq org-journal-date-format "%A, %d de %B de %Y"))

(if WORK_ENV
    (lytex/set-work-journal)
    (lytex/set-personal-journal))

(use-package! org-journal
  :custom
  (org-journal-date-prefix "* ")
  (if WORK_ENV
      (setq org-journal-date-format "%A, %d de %B de %Y :work:")
      (setq org-journal-date-format "%A, %d de %B de %Y")))

  (setq org-extend-today-until 4)

  (setq org-journal-after-entry-create-hook (lambda ()
    (org-set-property "CREATED" (format-time-string "[%Y-%m-%d %a %H:%M]"))))

(defun lytex/set-org-journal (option)
(if (string= option "J")
    (lytex/set-personal-journal))
(if (string= option "W")
    (lytex/set-work-journal))
(if (string= option "I")
    (lytex/set-introspection-journal)))

(defun lytex/set-org-journal-J ()
    (interactive)
    (lytex/set-org-journal "J"))
(defun lytex/set-org-journal-I ()
    (interactive)
    (lytex/set-org-journal "I"))
(defun lytex/set-org-journal-W ()
    (interactive)
    (lytex/set-org-journal "W"))

;; https://systemcrafters.net/build-a-second-brain-in-emacs/5-org-roam-hacks/#automatically-copy-or-move-completed-tasks-to-dailies

(defun lytex/org-roam-copy-todo-to-today ()
  (interactive)
  (let ((org-refile-keep nil) ;; Set this to nil to delete the original!
        (org-roam-dailies-capture-templates
          '(("t" "tasks" entry "%?"
             :if-new (file+head+olp "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n" ("Tasks")))))
        (org-after-refile-insert-hook #'save-buffer)
        today-file
        pos)
    (save-window-excursion
      (org-journal-new-entry t)
      (setq today-file (buffer-file-name))
      (setq pos (point)))

    ;; Only refile if the target file is different than the current file
    (unless  (or (equal (file-truename today-file)
                   (file-truename (buffer-file-name)))
                  (org-get-repeat)) ;; If task repeats, do not refile
      (org-refile nil nil (list "Tasks" today-file nil pos)))))
(if WORK_ENV
    (add-to-list 'org-after-todo-state-change-hook
                (lambda ()
                (when (equal org-state "DONE")
                    (lytex/org-roam-copy-todo-to-today)))))

