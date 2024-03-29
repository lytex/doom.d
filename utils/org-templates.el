#!/home/julian/.config/emacs/bin/doomscript

;; (defcli! export-notes (&args files)
;;         (princ "Hello\n")
;;         (require 'doom-start)
;;         (require 'find-lisp)
;;
;;
;;         (princ "Before print-to-file\n")
;;         (use-package! org-ql)
;;         (use-package! org)
;;         (princ "Before print-to-file\n")
;;         )

;; https://stackoverflow.com/questions/2321904/elisp-how-to-save-data-in-a-file/44834833#44834833
(defun print-to-file (filename data)
  (with-temp-file filename
    (prin1 data (current-buffer))))

(princ "Before print-to-file\n")
(princ "Before print-to-file\n")

(print-to-file "/home/julian/.cache/org-templates" (org-ql-query :select
              '(cons (substring-no-properties (org-get-heading)) (org-id-get-create))
          :from
          (org-agenda-files)
          :where
          '(ltags "template")))
(org-save-all-org-buffers)

;; (run! "export-notes")

;; vim: ft=lisp

