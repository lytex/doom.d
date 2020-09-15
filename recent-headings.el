(last org-recent-headings-entry-outline-path)
(mapcar )

(last (org-recent-headings-entry-outline-path (car org-recent-headings-list)))
(org-recent-headings-entry-file (nth 1 org-recent-headings-list))
(mapcar 'org-recent-headings-entry-file org-recent-headings-list)
(mapcar 'org-recent-headings-entry-outline-path org-recent-headings-list)

(setq org-directory-truename (file-truename org-directory))
(defun get-recent-headings (x)
"extract a list of org-mode link strings: file:<note.org>::*<heading>"
(s-replace org-directory-truename "" (concat "file" (org-recent-headings-entry-file x) "::*" (nth 0 (last (org-recent-headings-entry-outline-path x))))))

(defun foo (x)
(reduce 'concat (org-recent-headings-entry-outline-path x) :initial-value ""))
(mapcar 'get-recent-headings org-recent-headings-list)

(mapcar 'org-recent-headings-entry-file org-recent-headings-list)