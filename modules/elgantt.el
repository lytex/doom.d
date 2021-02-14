
;; (setq elgantt-agenda-files org-agenda-files)
(setq elgantt-agenda-files (concat user-emacs-directory ".local/straight/repos/elgantt/test.org"))
(add-to-list 'load-path (concat user-emacs-directory ".local/straight/repos/elgantt")) 
(setq elgantt-start-date "2020-01-01")
(require 'elgantt)