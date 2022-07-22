;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

(load! "~/.doom.d/work.el")
(load! "~/.doom.d/headless.el")

(package! org-transclusion :recipe
        (:host github :repo "nobiot/org-transclusion"))

(package! org-remark :recipe
        (:host github :repo "nobiot/org-remark"))

;; (package! org-auto-tangle)

(if (not HEADLESS)
    (progn
        (package! org-roam-ui)
        (package! org-wild-notifier)
        (package! org-superstar :disable t)
        (package! org-modern)
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
        (package! fzf :recipe)
        (package! beacon)
        (package! evil-quickscope :recipe
                (:host github :repo "blorbx/evil-quickscope"))))

(if WORK_ENV
  (package! org-trello :recipe
        (:host github :repo "org-trello/org-trello" :build (:not native-compile))))
(if WORK_ENV
  (package! org-jira :recipe
        (:host github :repo "ahungry/org-jira")))

(package! org-caldav :recipe
        (:host github :repo "dengste/org-caldav"))

(if (not HEADLESS) (progn

        (package! activity-watch-mode :recipe
                (:host github :repo "pauldub/activity-watch-mode"))


        (package! vimrc-mode)
        (package! ob-go)

        (package! org-linker :recipe
                (:host github :repo "toshism/org-linker"))

        (package! org-linker-edna :recipe
                (:host github :repo "toshism/org-linker-edna"))

        (package! org-graph-edna :recipe
                (:host github :repo "lytex/org-graph-edna"))
        (package! habitica)

        ;; (package! emacs-async :recipe
        ;;         (:host github :repo "jwiegley/emacs-async"
        ;;          :files ("async.el")))

        ))
;; (package! calfw :recipe
;;         (:host github :repo "kiwanami/emacs-calfw"))

;; (package! calfw-org :recipe
;;         (:host github :repo "kiwanami/emacs-calfw"))

;; (package! org-timeline :recipe
;;         (:host github :repo "Fuco1/org-timeline"))

;; (package! org-vcard)

(package! benchmark-init)
