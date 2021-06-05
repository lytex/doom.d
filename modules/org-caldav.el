;; Sync absoultely everything 
(setq org-icalendar-include-todo t
      org-icalendar-use-deadline '(event-if-todo event-if-not-todo todo-due)
      org-icalendar-use-scheduled '(event-if-todo event-if-not-todo todo-start)
      org-icalendar-with-timestamps t)
(use-package! org-caldav)
(setq org-caldav-sync-direction 'org->cal)

(setq org-files-without-id (seq-filter (lambda (x) (not (member x
                                           `(,(expand-file-name "~/org/0.org")
                                              ,(expand-file-name "~/org/1custom_id.org")))))
                  (org-agenda-files)))

(setq org-caldav-files org-files-without-id)

(setq org-caldav-inbox "~/org/0.org")
(setq org-agenda-default-appointment-duration 15) ;; Appointments without end datetime last 15min
;; Get user id by inspecting network while connecting to Calendar Web Interface
(setq org-caldav-url "https://shared03.opsone-cloud.ch/remote.php/dav/calendars/julianlpc15@gmail.com")

(if WORK_ENV
  (setq org-caldav-calendar "work" org-export-select-tags '("work"))
  (setq org-caldav-calendar "personal" org-caldav-exclude-tags '("work")))