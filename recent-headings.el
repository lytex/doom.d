(setq org-directory-truename (file-truename org-directory))
(defun get-recent-headings (x)
"extract a list of org-mode link strings: file:<note.org>::*<heading>"
(s-replace org-directory-truename "" (concat "file" (org-recent-headings-entry-file x) "::*" (nth 0 (last (org-recent-headings-entry-outline-path x))))))
