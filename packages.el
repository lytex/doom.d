;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

(load! "~/.doom.d/work.el")

(package! org-roam :recipe
        (:host github :repo "org-roam/org-roam")
        :pin "9065f6a999b98d4b495e3d8fa1fa4424eddd25a8")
(package! org-wild-notifier)
(package! org-bullets)
(package! org-transclusion :recipe
        (:host github :repo "nobiot/org-transclusion"))
(package! org-ql :recipe
        (:host github :repo "alphapapa/org-ql"))
(package! origami :recipe
        (:host github :repo "gregsexton/origami.el"))
(package! org-sticky-header :recipe
        (:host github :repo "alphapapa/org-sticky-header"))
(package! org-tree-slide)
(package! pdf-continuous-scroll-mode :recipe
        (:host github :repo "dalanicolai/pdf-continuous-scroll-mode.el"))
(package! pdf-view-restore)
(package! nov)
(package! org-noter-pdftools :recipe
        (:host github :repo "fuxialexander/org-pdftools"))
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
(if WORK_ENV
  (package! org-jira :recipe
        (:host github :repo "ahungry/org-jira")))
(package! activity-watch-mode :recipe
        (:host github :repo "pauldub/activity-watch-mode"))

(package! org-caldav :recipe
        (:host github :repo "dengste/org-caldav"))

(package! vimrc-mode)
(package! ob-go)

;; (package! calfw :recipe
;;         (:host github :repo "kiwanami/emacs-calfw"))

;; (package! calfw-org :recipe
;;         (:host github :repo "kiwanami/emacs-calfw"))

;; (package! org-timeline :recipe
;;         (:host github :repo "Fuco1/org-timeline"))

;; (package! org-vcard)
