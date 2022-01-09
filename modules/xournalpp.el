
(defun lytex/org-edit-sketch (sketch-name)
  (setq global-sketch sketch-name)
  (setq book-name (car (split-string sketch-name ":"))
      page (cadr (split-string sketch-name ":")))
  (setq notebook (concat (format-time-string "/home/julian/Documents/xournalpp/") book-name ".xopp"))
  (if (equal page nil)
      (async-start-process "xournalpp-sketch" "xournalpp" nil notebook)
      (async-start-process "xournalpp-sketch" "xournalpp" nil notebook "-n" page)))

(org-link-set-parameters "sketch" :follow 'lytex/org-edit-sketch)


(setq global-sketch nil)
(use-package! ido)
(defun lytex/insert-global-sketch ()
  (interactive)
  (unless global-sketch (setq global-sketch (concat (format-time-string "%Y%m%d%H%M%S-") 
        (ido-completing-read "sketch: " nil))))
  (insert (concat "[[sketch:" global-sketch "]]")))

(defun lytex/reset-sketch ()
  (interactive)
  (setq global-sketch nil))

