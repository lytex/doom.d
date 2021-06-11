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

;; https://github.com/dengste/org-caldav/blob/master/org-caldav.el#L1297-L1298
;; Also set org-caldav-skip-conditions even if it's unused
;; (if WORK_ENV
;; (defun org-caldav-skip-function (backend)
;;   (when (eq backend 'icalendar)
;;     (org-map-entries
;;      (lambda ()
;;        (let ((pt (save-excursion (apply 'org-agenda-skip-entry-if org-caldav-skip-conditions))))
;; 		 (when pt (delete-region (point) (- pt 1))))))))
;; )

(if WORK_ENV
  (setq org-caldav-calendar-id "work" org-caldav-select-tags '("work") org-caldav-exclude-tags nil)
  (setq org-caldav-calendar-id "personal" org-caldav-select-tags nil org-caldav-exclude-tags '("work")))