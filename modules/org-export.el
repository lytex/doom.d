(setq org-export-exclude-tags '("private" "area"))
(setq org-export-with-broken-links t)
(setq org-export-preserve-breaks t)
(setq org-export-in-background t)
(setq org-export-with-properties '("NEXT" "BLOCK" "GOAL"))

(defun my/org-export-on-save ()
      ;; Detecting org-mode is not straightforward:
      ;; https://emacs.stackexchange.com/questions/53167/check-whether-buffer-is-in-org-mode
      (if (eq major-mode 'org-mode)
          (progn
            (unless org-transclusion-mode (org-transclusion-mode))
            (org-html-export-to-html))))

(add-hook 'after-save-hook #'my/org-export-on-save)