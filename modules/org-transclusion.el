
(auto-save-mode nil)
(setq make-backup-files nil)
(setq org-transclusion-include-first-section nil)
(use-package! org-transclusion)
(auto-save-mode nil)
(setq make-backup-files nil)
(setq org-transclusion-include-first-section nil)

(with-eval-after-load 'org
  (define-key global-map (kbd "<f12>") #'org-transclusion-mode))