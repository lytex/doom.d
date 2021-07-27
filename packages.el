;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

(load! "~/.doom.d/work.el")

(package! org-wild-notifier)
(package! org-bullets)
(package! org-transclusion :recipe
        (:host github :repo "nobiot/org-transclusion"))
(package! helm-org-rifle)
(package! org-recent-headings)
(package! org-ql :recipe
        (:host github :repo "alphapapa/org-ql"))
(package! origami :recipe
        (:host github :repo "gregsexton/origami.el"))
(package! org-sticky-header :recipe
        (:host github :repo "alphapapa/org-sticky-header"))
(package! pdf-tools)
(package! pdf-continuous-scroll-mode :recipe
        (:host github :repo "dalanicolai/pdf-continuous-scroll-mode.el"))
(package! pdf-view-restore)
(package! org-pdftools)
(package! nov)
(package! org-noter-pdftools :recipe
        (:host github :repo "fuxialexander/org-pdftools"))
(package! org-noter)
(package! org-web-tools)
(package! fzf :recipe
        (:host github :repo "seenaburns/fzf.el"))
(package! beacon)
(package! evil-quickscope :recipe 
        (:host github :repo "blorbx/evil-quickscope"))
(if WORK_ENV
  (package! excorporate))
(if WORK_ENV
  (package! org-trello :recipe
        (:host github :repo "org-trello/org-trello" :build (:not native-compile))))
(package! activity-watch-mode :recipe
        (:host github :repo "pauldub/activity-watch-mode"))

;; (package! calfw :recipe
;;         (:host github :repo "kiwanami/emacs-calfw"))

;; (package! calfw-org :recipe
;;         (:host github :repo "kiwanami/emacs-calfw"))

;; (package! org-timeline :recipe
;;         (:host github :repo "Fuco1/org-timeline"))

;; (package! org-vcard)