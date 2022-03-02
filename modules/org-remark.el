
(setq org-remark-notes-file-name #'org-remark-notes-file-name-function)
(setq org-remark-use-org-id t)

(use-package! org-remark
  :custom
        (setq org-remark-notes-file-name #'org-remark-notes-file-name-function)
        (setq org-remark-use-org-id t))


(use-package! org-remark-global-tracking)
(org-remark-global-tracking-mode +1)
