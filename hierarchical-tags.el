(defun my-file-contents (filename)
  "Return the contents of FILENAME."
  (with-temp-buffer
    (insert-file-contents filename)
    (buffer-string)))

(setq my-file (my-file-contents "~/org/0rganización.org"))

()