
;; from https://emacs.stackexchange.com/a/46022
(if WORK_ENV
(progn 
;; configure excorporate
;; allow opening the exchange calendar with 'e' from calendar 
(evil-define-key 'motion calendar-mode-map "e" #'exco-calendar-show-day)

(setq-default
 ;; configure email address and office 365 exchange server adddress for exchange web services
 excorporate-configuration
  (quote
   (user-mail-address . "https://outlook.office365.com/EWS/Exchange.asmx"))
  ;; integrate emacs diary entries into org agenda
  org-agenda-include-diary t
  )
;; activate excorporate and request user/password to start connection
(excorporate)
;; enable the diary integration (i.e. write exchange calendar to emacs diary file -> ~/.emacs.d/diary must exist)
(excorporate-diary-enable)
(defun ab/agenda-update-diary ()
  "call excorporate to update the diary for today"
  (exco-diary-diary-advice (calendar-current-date) (calendar-current-date) #'message "diary updated"))

;; update the diary every time the org agenda is refreshed
(add-hook 'org-agenda-cleanup-fancy-diary-hook 'ab/agenda-update-diary )))