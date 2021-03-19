
(auto-save-mode nil)
(setq make-backup-files nil)
(setq org-transclusion-include-first-section nil)
(use-package! org-transclusion)
(auto-save-mode nil)
(setq make-backup-files nil)
(setq org-transclusion-include-first-section nil)

(defun my/org-transclusion-read-only (&optional arg)
(if org-transclusion-mode
  (setq buffer-read-only t)
  (setq buffer-read-only nil)))

(with-eval-after-load 'org
  (define-key global-map (kbd "<f12>") #'org-transclusion-mode))

(advice-add 'org-transclusion-mode :after 'my/org-transclusion-read-only)

(advice-add 'org-metaup :before (lambda (&optional arg) (if org-transclusion-mode (org-transclusion-deactivate))))
(advice-add 'org-metaleft :before (lambda (&optional arg) (if org-transclusion-mode (org-transclusion-deactivate))))
(advice-add 'org-metadown :before (lambda (&optional arg) (if org-transclusion-mode (org-transclusion-deactivate))))
(advice-add 'org-metaright :before (lambda (&optional arg) (if org-transclusion-mode (org-transclusion-deactivate))))