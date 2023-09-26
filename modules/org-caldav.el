;; Sync absoultely everything 
(setq org-icalendar-include-todo t
      org-icalendar-use-deadline '(event-if-todo event-if-not-todo todo-due)
      org-icalendar-use-scheduled '(event-if-todo event-if-not-todo todo-start)
      org-icalendar-with-timestamps nil)
(setq org-icalendar-alarm-time 5) ;; Alert 5 min before
(setq org-caldav-todo-percent-states
      '(
       (0 "TODO")
       (50 "ONGOING")
       (0 "NEXT")
       (25 "BLOCK")
       (0 "SOMEDAY")
       (0 "MAYBE")
       (0 "DEFINED")
       (25 "HOLD")
       (0 "REFILE")
       (0 "TICKLER")
       (75 "VERIFY")
       (100 "DONE")
       (100 "CANCELLED")
       ))

(use-package! org-caldav)
(setq org-caldav-sync-direction 'org->cal)

(setq org-files-without-id (seq-filter (lambda (x) (not (member x
                                           `(,(expand-file-name "~/org/0.org")
                                              ,(expand-file-name "~/org/1custom_id.org")
                                              ,(expand-file-name "~/org/LectureNotes.org")))))
                  (org-agenda-files)))

(setq org-caldav-files org-files-without-id)

(setq org-caldav-inbox "~/org/0.org")
(setq org-agenda-default-appointment-duration 15) ;; Appointments without end datetime last 15min
;; Get user id by inspecting network while connecting to Calendar Web Interface
(setq org-caldav-url "https://shared03.opsone-cloud.ch/remote.php/dav/calendars/julianlpc15@gmail.com")

(defun lytex/org-agenda-skip-entry-if-non-work ()
(let* (;; (beg (point))
      (end (if nil (save-excursion (org-end-of-subtree t) (point))
      (org-entry-end-position)))
      (planning-end (if nil end (line-end-position 2)))
      m)
      (and 
					(not (string-match-p "work" (substring-no-properties (org-make-tag-string (org-get-tags)))))
          (string-match-p "mantenimiento" (substring-no-properties (org-make-tag-string (org-get-tags))))
					(re-search-forward org-heading-regexp))))

(if (not HEADLESS)
(defun lytex/reload-org-hyperscheduler ()
  (interactive)
  (setq org-hyperscheduler-agenda-filter
        (format-time-string "TIMESTAMP>=\"<%Y-%m-%d>\"|SCHEDULED>=\"<%Y-%m-%d>\"|DEADLINE>=\"<%Y-%m-%d>\""
                ;; Seven days into the future
                    (time-add (current-time) (* 8 24 3600))))
))

(lytex/reload-org-hyperscheduler)

;; (with-demoted-errors "org-hyperscheduler error: %S"
;;   (use-package! org-hyperscheduler
;;     :custom
;;     (org-hyperscheduler-inbox-file (concat org-directory "/Inbox.org"))
;;     (org-hyperscheduler-hide-done-tasks t)
;;     (org-hyperscheduler-root-dir org-directory)
;;     (org-hyperscheduler-readonly-mode nil)
;;   ))
;; )
;; https://github.com/dengste/org-caldav/blob/master/org-caldav.el#L1297-L1298
;; Also set org-caldav-skip-conditions even if it's unused
;; (if WORK_ENV
;;   (setq org-caldav-skip-conditions '(regexp "randomstring")))

;; (if WORK_ENV
;; (defun org-caldav-skip-function (backend)
;;   (when (eq backend 'icalendar)
;;     (org-map-entries
;;      (lambda ()
;;        (let ((pt (save-excursion (lytex/org-agenda-skip-entry-if-non-work))))
;; 		 (when pt (delete-region (point) (- pt 1)))))))))
;;

;; From https://d12frosted.io/posts/2021-04-08-straight-el-retries.html
(defvar lytex/retry-count 3
  "Amount of retries for lytex/call-with-retry")

(defun lytex/call-with-retry (orig-fn &rest args)
  "Wrapper around ORIG-FN supporting retries.

ORIG-FN is called with ARGS and retried
`elpa-straight-retry-count' times."
  (let ((n lytex/retry-count)
        (res nil))
    (while (> n 0)
      (condition-case err
          (progn
            (setq res (apply orig-fn args)
                  n 0)
            res)
        (error
         (setq n (- n 1))
         (unless (> n 0)
           (signal (car err) (cdr err))))))))

(if WORK_ENV
  (setq org-caldav-calendar-id "work" org-caldav-select-tags '("work") org-caldav-exclude-tags '("mantenimiento" "tareas" "habit"))
  (setq org-caldav-calendar-id "personal" org-caldav-exclude-tags '("work" "habit")))
