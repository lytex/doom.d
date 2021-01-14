;; org-journal with three different journals

(defun my/set-work-journal ()
        (setq org-journal-dir (concat org-directory "work_journal/"))
        ;; Workaround to work with orgzly -> each file must have a unique name
        (setq orgzly-org-journal-file-format "%Y-%m-%dW.org")
        (setq org-journal-file-format orgzly-org-journal-file-format)
        ;; All work journal files have the tag "work"
        (setq org-journal-file-header "#+FILETAGS: :work:")
        (setq org-journal-date-format "%A, %d de %B de %Y :work:"))

(defun my/set-personal-journal ()
        (setq org-journal-dir (concat org-directory "journal/"))
        (setq orgzly-org-journal-file-format "%Y-%m-%d.org")
        (setq org-journal-file-format orgzly-org-journal-file-format)
        (setq org-journal-file-header "")
        (setq org-journal-date-format "%A, %d de %B de %Y"))

(defun my/set-introspection-journal ()
        (setq orgzly-org-journal-file-format "%Y-%m-%dI.org")
        (setq org-journal-file-format orgzly-org-journal-file-format)
        (setq org-journal-dir (concat org-directory "Introspección/"))
        (setq org-journal-date-format "%A, %d de %B de %Y"))

(if WORK_ENV
    (my/set-work-journal)
    (my/set-personal-journal))

(use-package! org-journal
  :custom
  (org-journal-date-prefix "* ")
  (if WORK_ENV
      (setq org-journal-date-format "%A, %d de %B de %Y :work:")
      (setq org-journal-date-format "%A, %d de %B de %Y"))
  (org-journal-file-format orgzly-org-journal-file-format)
  (org-journal-after-entry-create-hook (lambda ()
    (org-set-property "CREATED" (format-time-string "[%Y-%m-%d %a %H:%M]"))
    (call-interactively 'org-close-fold))))

(defun my/set-org-journal (option)
(if (string= option "J")
    (my/set-personal-journal))
(if (string= option "W")
    (my/set-work-journal))
(if (string= option "I")
    (my/set-introspection-journal)))

(defun my/set-org-journal-J ()
    (interactive)
    (my/set-org-journal "J"))
(defun my/set-org-journal-I ()
    (interactive)
    (my/set-org-journal "I"))
(defun my/set-org-journal-W ()
    (interactive)
    (my/set-org-journal "W"))

