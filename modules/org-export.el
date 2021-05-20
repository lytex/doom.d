(setq org-export-exclude-tags '("private" "area"))
(setq org-export-with-broken-links t)
(setq org-export-preserve-breaks t)
(setq org-export-in-background t)
(setq org-export-with-properties '("NEXT" "BLOCK" "GOAL"))

(defun lytex/org-export-on-save ()
      ;; Detecting org-mode is not straightforward:
      ;; https://emacs.stackexchange.com/questions/53167/check-whether-buffer-is-in-org-mode
      (if (and (eq major-mode 'org-mode) (not (eq (buffer-name) "Inbox.org")))
          (progn
            (setq old-transclusion-mode org-transclusion-mode)
            (unless org-transclusion-mode (org-transclusion-mode t))
            (org-html-export-to-html)
            (unless old-transclusion-mode (org-transclusion-mode -1)))))

(add-hook 'after-save-hook #'lytex/org-export-on-save)

;; (defun lytex/ox-html-format-drawer (name content backend)
;;   "Export :NOTES: and :LOGBOOK: drawers to HTML class"
;;   (cond
;;     ((string-match "RELATED\\|DEPENDS\\|TAGS" name)
;;     (cond
;;       ((eq backend 'html)
;;       (format "@<div class=\".org-org-drawer\"> %s @</div>" content))
;;       (t nil)))
;;     (t nil)))


(use-package-hook! org
  :pre-init
  (setq org-html-head-extra
"<style> #content{max-width:79%;}</style>
<style> p{max-width:99%;}</style>
<style> li{max-width:99%;}</style>"))
;;   (setq org-html-format-drawer-function 'lytex/ox-html-format-drawer))