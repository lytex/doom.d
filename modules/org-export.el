(setq org-export-exclude-tags '("private" "area"))
(setq org-export-use-babel nil)
(setq org-export-with-broken-links t)
(setq org-export-preserve-breaks t)
(setq org-export-with-archived-trees t)
(setq org-export-with-sub-superscripts nil)
(setq org-export-with-properties '("NEXT" "BLOCK" "GOAL"))

(defun lytex/org-export-on-save ()
      ;; Widen if the buffer is narrowed
      (save-restriction
      (if (or (/= (point-max) (+ (buffer-size) 1)) (/= (point-min) 1))
       (widen))
      ;; Detecting org-mode is not straightforward:
      ;; https://emacs.stackexchange.com/questions/53167/check-whether-buffer-is-in-org-mode
      (if (and (eq major-mode 'org-mode) (not (eq (buffer-name) "Inbox.org")))
          (progn
            (setq old-transclusion-mode org-transclusion-mode)
            (unless org-transclusion-mode (org-transclusion-mode t))
            (org-html-export-to-html)
            (unless old-transclusion-mode (org-transclusion-mode -1))))))

(after! ox-html
;; From https://gist.github.com/jethrokuan/d6f80caaec7f49dedffac7c4fe41d132
  (defun org-html--reference (datum info &optional named-only)
    "Return an appropriate reference for DATUM.
  DATUM is an element or a `target' type object.  INFO is the
  current export state, as a plist.
  When NAMED-ONLY is non-nil and DATUM has no NAME keyword, return
  nil.  This doesn't apply to headlines, inline tasks, radio
  targets and targets."
    (let* ((type (org-element-type datum))
  	 (user-label
  	  (org-element-property
  	   (pcase type
  	     ((or `headline `inlinetask) :CUSTOM_ID)
  	     ((or `radio-target `target) :value)
  	     (_ :name))
  	   datum))
           (user-label (or user-label
                           (when-let ((path (org-element-property :ID datum)))
                             (concat "ID-" path)))))
      (cond
       ((and user-label
  	   (or (plist-get info :html-prefer-user-labels)
  	       ;; Used CUSTOM_ID property unconditionally.
  	       (memq type '(headline inlinetask))))
        user-label)
       ((and named-only
  	   (not (memq type '(headline inlinetask radio-target target)))
  	   (not user-label))
        nil)
       (t
        (org-export-get-reference datum info))))))

;; This is managed by orgzly-integrations, enable if needed
;; (add-hook 'after-save-hook #'lytex/org-export-on-save)

;; (defun lytex/ox-html-format-drawer (name content backend)
;;   "Export :NOTES: and :LOGBOOK: drawers to HTML class"
;;   (cond
;;     ((string-match "RELATED\\|DEPENDS\\|TAGS" name)
;;     (cond
;;       ((eq backend 'html)
;;       (format "@<div class=\".org-org-drawer\"> %s @</div>" content))
;;       (t nil)))
;;     (t nil)))

(setq org-html-postamble-format
      '(("en" "<p class=\"author\">Author: %a (%e)</p>
<p class=\"date\">Date: 123 %d</p>
<p class=\"creator\">%c</p>
<p class=\"creator\" Except where otherwise noted, content on this wiki is licensed under the following license:
<a href=\"https://www.gnu.org/licenses/fdl-1.3.html\"> GNU Free Documentation License 1.3 </a></p>
<p class=\"validation\">%v</p>")))

(setq org-export-headline-levels 4)


(setq org-html-htmlize-output-type 'css)

(setq org-html-head-extra
        "<style> #content{max-width:79%;}</style>
        <style> p{max-width:99%;}</style>
        <style> li{max-width:99%;}</style>
        <link rel=\"stylesheet\" type=\"text/css\" href=\"src/readtheorg_theme/css/htmlize.css\"/>")

;;   (setq org-html-format-drawer-function 'lytex/ox-html-format-drawer))
