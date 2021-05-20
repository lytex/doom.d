
(use-package! pdf-view-restore
  :after pdf-tools
  :config
  (add-hook 'pdf-view-mode-hook 'pdf-view-restore-mode))

(setq pdf-view-restore-filename "~/.emacs.d/.pdf-view-restore")

(use-package! org-pdftools
  :hook ((org-load . org-pdftools-setup-link))
          (pdf-tools-enable-minor-mode))
(pdf-loader-install)

(use-package! pdf-continuous-scroll-mode
  :after pdf-tools
  :config
  (add-hook 'pdf-view-mode-hook 'pdf-continuous-scroll-mode))

(use-package! pdf-history
  :after pdf-tools
  :config
  (add-hook 'pdf-view-mode-hook 'pdf-history-minor-mode))

(use-package! pdf-annot
  :after pdf-tools
  :config
  (add-hook 'pdf-view-mode-hook 'pdf-annot-minor-mode))

(defun lytex/pdf-annot-add-markup-annotation () (interactive)
                (call-interactively 'pdf-annot-add-markup-annotation))
(defun lytex/pdf-annot-add-squiggly-markup-annotation () (interactive)
                (call-interactively 'pdf-annot-add-squiggly-markup-annotation))
(defun lytex/pdf-annot-add-highlight-markup-annotation () (interactive)
                (call-interactively 'pdf-annot-add-highlight-markup-annotation))
(defun lytex/pdf-annot-add-strikeout-markup-annotation () (interactive)
                (call-interactively 'pdf-annot-add-strikeout-markup-annotation))
(defun lytex/pdf-annot-add-underline-markup-annotation () (interactive)
                (call-interactively 'pdf-annot-add-underline-markup-annotation))
(defun lytex/pdf-annot-add-text-annotation () (interactive)
                (call-interactively 'pdf-annot-add-text-annotation))

(defun lytex/join-org-headline-next ()
  ;; ]] j daE k D
  (interactive)
  (org-next-visible-heading 1) ;; ]]
  (evil-next-line) ;; j
  (while (not (eq (car (org-element-at-point)) 'paragraph))
    ;; Equivalent to daE in normal mode
    (apply 'evil-delete (evil-org-an-element)))
  (evil-previous-line) ;; k
  (call-interactively 'evil-delete-whole-line)) ;; D

(defun lytex/join-org-headline-previous ()
  (interactive)
  (if (eq (car (org-element-at-point)) 'headline)
      (org-previous-visible-heading 1)
      (org-previous-visible-heading 2))
    (lytex/join-org-headline-next))


(use-package! org-noter-pdftools
  :after org-noter
  :config
  (with-eval-after-load 'pdf-annot
    (add-hook 'pdf-annot-activate-handler-functions #'org-noter-pdftools-jump-to-note))
  (setq org-noter-pdftools-insert-content-heading nil))


(defun lytex/clean-pdf-fontifications ()
  (replace-regexp "ﬃ" "ffi") 
  (replace-regexp "ﬁ" "fi") 
  (replace-regexp "ﬀ" "ff")
  (replace-regexp ". . ." "..."))

(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
(use-package! nov)