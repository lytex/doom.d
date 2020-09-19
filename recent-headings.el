;; TODOs
;; Optional variable for s-replacing
;; save-recent-headings use variable
;; add requirements (org-recent-headings, s)
;; write to buffer on the background
;; run as a service each x min (x=5 for example)

(setq org-directory-truename (file-truename org-directory))
(defun get-recent-heading-link (x)
  "extract a list of org-mode link strings: file:<note.org>::*<heading>"
  (setq modified-at (car (alist-get :frecency-timestamps (org-recent-headings-entry-frecency x))))
  (setq org-mode-link (s-replace org-directory-truename "" (concat "[[file:" (org-recent-headings-entry-file x) "::*" (nth 0 (last (org-recent-headings-entry-outline-path x))) "]]")))
  (concat "* " org-mode-link "\n:PROPERTIES:\nMODIFIED: " (format-time-string "<%Y-%m-%d %a %H:%M:%S>" (seconds-to-time (round modified-at))) "\n:END:\n"))

;; (get-recent-heading-link (nth 1 org-recent-headings-list))

(defun write-recent-heading (recent-heading)
      (insert get-recent-heading-link recent-heading))

(defun save-recent-headings ()
    (interactive)
    (switch-to-buffer (find-file-noselect "~/org/1Recent.org" nil nil ""))
    (erase-buffer)
    ;; TODO Doesn't work with headings which contain links
    (mapcar 'write-recent-heading org-recent-headings-list))
