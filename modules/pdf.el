
(use-package! pdf-view-restore
  :after pdf-tools
  :config
  (add-hook 'pdf-view-mode-hook 'pdf-view-restore-mode))

(setq pdf-view-restore-filename "~/.config/emacs/.pdf-view-restore")


(use-package! org-pdftools
  :hook (org-mode . org-pdftools-setup-link)
          (pdf-tools-enable-minor-mode))

;; (use-package! pdf-continuous-scroll-mode
;;   :after pdf-tools)


;; (map! :map pdf-view-mode-map
;;       :after evil-collection-pdf
;;       :n "j" #'pdf-continuous-scroll-forward
;;       :n "k" #'pdf-continuous-scroll-backward
;;       :n (kbd "C-d") #'(lambda () (interactive) (pdf-continuous-scroll-forward (/ (window-pixel-height) 2)))
;;       :n (kbd "C-u") #'(lambda () (interactive) (pdf-continuous-scroll-backward (/ (window-pixel-height) 2)))
;;       :n (kbd "C-f") #'(lambda () (interactive) (pdf-continuous-scroll-forward (window-pixel-height)))
;;       :n (kbd "C-b") #'(lambda () (interactive) (pdf-continuous-scroll-backward (window-pixel-height)))
;; )


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


(defun lytex/import-notes-from-current (offset)
  (interactive "nEnter offset from current page: ")
(org-noter-pdftools-create-skeleton (pdf-info-normalize-page-range (list (pdf-view-current-page) (+ offset (pdf-view-current-page))))))

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

(use-package! org-noter
  :config (setq org-noter-always-create-frame nil))

(add-hook 'org-noter-doc-mode-hook #'(lambda ()
  ;; Only load after entering org-noter mode
  (use-package! org-noter-pdftools
    :after org-noter
    :config
    (with-eval-after-load 'pdf-annot
      (add-hook 'pdf-annot-activate-handler-functions #'org-noter-pdftools-jump-to-note))
    (setq org-noter-pdftools-insert-content-heading nil))))


(defun lytex/clean-pdf-fontifications ()
  (replace-regexp "ﬃ" "ffi") 
  (replace-regexp "ﬁ" "fi") 
  (replace-regexp "ﬀ" "ff")
  (replace-regexp "ﬂ" "fl")
  (replace-regexp "…" "..."))

;; (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
;; (use-package! nov)

(use-package! s)
(defun lytex/okular-open (link)
      (setq find-expr (cadr (split-string link "--find ")))
      (if (equal find-expr nil)
        (progn
          (message (concat "okular " link))
          (async-start-process "okular" "okular" nil link))
        (progn
          (setq find-expr (s-replace "'" "" find-expr))
          (setq link (car (split-string link "--find ")))
          (message (concat "okular " link " --find " find-expr))
          (async-start-process "okular" "okular" nil link "--find" find-expr))))

(org-link-set-parameters "okular" :follow 'lytex/okular-open)
