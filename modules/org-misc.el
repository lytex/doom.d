(use-package! org-sticky-header
    :config
    (add-hook 'org-mode-hook (lambda () (org-sticky-header-mode 1))))

(use-package! org-web-tools)


(defun lytex/clean-xtra-newlines ()
  (interactive)
  (replace-regexp "\n\n+" "\n"))

(use-package! org-tree-slide)

(map! :after org-web-tools
      :leader
      :prefix "m"
      :desc (documentation 'org-web-tools-insert-web-page-as-entry) "w" 
                #'org-web-tools-insert-web-page-as-entry)

(use-package! org-wild-notifier)

(after! org-wild-notifier
  (org-wild-notifier-mode))
(setq alert-user-configuration '((nil libnotify ((:persistent . t)))))

(if WORK_ENV
    (setq org-wild-notifier-tags-blacklist '("mantenimiento" "tareas" "relaciones")))


(use-package! counsel)

(map! :after counsel
      :leader
      :prefix "f"
      :desc (documentation 'counsel-fzf) "z" #'counsel-fzf)

(use-package! ob-plantuml
  :config
  (setq org-plantuml-jar-path "/usr/share/plantuml/plantuml.jar"))

;; org-bullets has to be loaded AFTER org-roam
;; otherwise it breaks org-roam
(use-package! org-bullets
    :config
    (add-hook 'org-mode-hook (lambda () (org-bullets-mode t))))