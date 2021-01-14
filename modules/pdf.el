
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

(defun my/pdf-annot-add-markup-annotation () (interactive)
                (call-interactively 'pdf-annot-add-markup-annotation))
(defun my/pdf-annot-add-squiggly-markup-annotation () (interactive)
                (call-interactively 'pdf-annot-add-squiggly-markup-annotation))
(defun my/pdf-annot-add-highlight-markup-annotation () (interactive)
                (call-interactively 'pdf-annot-add-highlight-markup-annotation))
(defun my/pdf-annot-add-strikeout-markup-annotation () (interactive)
                (call-interactively 'pdf-annot-add-strikeout-markup-annotation))
(defun my/pdf-annot-add-underline-markup-annotation () (interactive)
                (call-interactively 'pdf-annot-add-underline-markup-annotation))
(defun my/pdf-annot-add-text-annotation () (interactive)
                (call-interactively 'pdf-annot-add-text-annotation))

(defun my/join-org-headline-next ()
  (interactive)
  (org-next-visible-heading 1)
  (evil-next-line)
  (while (not (eq (car (org-element-at-point)) 'paragraph))
    ;; Equivalent to daE in normal mode
    (apply 'evil-delete (evil-org-an-element)))
  (evil-previous-line)
  (call-interactively 'evil-delete-whole-line))

(defun my/join-org-headline-previous ()
  (interactive)
  (if (eq (car (org-element-at-point)) 'headline)
      (org-previous-visible-heading 1)
      (org-previous-visible-heading 2))
    (my/join-org-headline-next))

(after! (pdf-tools)
(map! :leader
      :mode (pdf-view-mode)
      :prefix ("a" . "annotations in pdf")
      :desc (documentation 'pdf-annot-add-markup-annotation) 
      "a" #'my/pdf-annot-add-markup-annotation
      :desc (documentation 'pdf-annot-add-squiggly-markup-annotation) 
      "g" #'my/pdf-annot-add-squiggly-markup-annotation
      :desc (documentation 'pdf-annot-add-highlight-markup-annotation)
      "f" #'my/pdf-annot-add-highlight-markup-annotation
      :desc (documentation 'pdf-annot-add-strikeout-markup-annotation)
      "s" #'my/pdf-annot-add-strikeout-markup-annotation
      :desc (documentation 'pdf-annot-add-underline-markup-annotation)
      "d" #'my/pdf-annot-add-underline-markup-annotation
      :desc (documentation 'my/join-org-headline-previous)
      "p" #'my/join-org-headline-previous
      :desc (documentation 'my/join-org-headline-next)
      "n" #'my/join-org-headline-next)


(map! :leader
      :mode (pdf-view-mode)
      :prefix "p"
      :desc (documentation 'pdf-history-backward)  "[" #'pdf-history-backward
      :desc (documentation 'pdf-history-forward)  "]" #'pdf-history-forward))

(use-package! org-noter-pdftools
  :after org-noter
  :config
  (with-eval-after-load 'pdf-annot
    (add-hook 'pdf-annot-activate-handler-functions #'org-noter-pdftools-jump-to-note))
  (setq org-noter-pdftools-insert-content-heading nil))


(defun my/clean-pdf-fontifications ()
  (replace-regexp "ﬃ" "ffi") 
  (replace-regexp "ﬁ" "fi") 
  (replace-regexp "ﬀ" "ff")
  (replace-regexp ". . ." "..."))

(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
(use-package! nov)