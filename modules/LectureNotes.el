;;; LectureNotes.el -*- lexical-binding: t; -*-
;; https://emacs.stackexchange.com/questions/20574/default-inline-image-background-in-org-mode/37927#3792

(defcustom org-inline-image-background nil
  "The color used as the default background for inline images.
When nil, use the default face background."
  :group 'org
  :type '(choice color (const nil)))

(defun create-image-with-background-color (args)
  "Specify background color of Org-mode inline image through modify `ARGS'."
  (let* ((file (car args))
         (type (cadr args))
         (data-p (caddr args))
         (props (cdddr args)))
    ;; Get this return result style from `create-image'.
    (append (list file type data-p)
            (list :background (or org-inline-image-background (face-background 'default)))
            props)))

(advice-add 'create-image :filter-args
            #'create-image-with-background-color)

(setq org-inline-image-background "light gray")
