(setq org-export-exclude-tags '("private" "area"))
(setq org-export-with-broken-links t)
(setq org-export-preserve-breaks t)
(setq org-export-in-background t)
(setq org-export-with-properties '("NEXT" "BLOCK" "GOAL"))

(defun my/org-export-on-save ()
      ;; Detecting org-mode is not straightforward:
      ;; https://emacs.stackexchange.com/questions/53167/check-whether-buffer-is-in-org-mode
      (if (and (eq major-mode 'org-mode) (not (eq (buffer-name) "Inbox.org"))
          (progn
            (unless org-transclusion-mode (org-transclusion-mode))
            (org-html-export-to-html))))

(add-hook 'after-save-hook #'my/org-export-on-save)

;; (defun my/ox-html-format-drawer (name content backend)
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
;;   (setq org-html-format-drawer-function 'my/ox-html-format-drawer))