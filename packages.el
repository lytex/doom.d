;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

(load! "~/.doom.d/work.el")
(load! "~/.doom.d/headless.el")

(package! org-transclusion :recipe
        (:host github :repo "nobiot/org-transclusion"))

(package! org-remark :recipe
        (:host github :repo "nobiot/org-remark"))

(if (not HEADLESS)
    (progn
        (package! org-roam-ui)
        (package! org-wild-notifier)
        (package! org-superstar :disable t)
        (package! org-rainbow-tags :recipe
                (:host github :repo "KaratasFurkan/org-rainbow-tags"))
        (package! org-modern)
        (package! org-ql :recipe
                (:host github :repo "alphapapa/org-ql"))
        (package! ob-async :recipe
                (:host github :repo "astahlman/ob-async"))
        ;; org-ql breaks in emacs28 because of transient
        ;; https://emacs.stackexchange.com/questions/75827/doom-emacs-error-running-hook-global-git-commit-mode-because-void-variable
        (package! transient
              :pin "c2bdf7e12c530eb85476d3aef317eb2941ab9440"
              :recipe (:host github :repo "magit/transient"))

        (package! with-editor
                  :pin "bbc60f68ac190f02da8a100b6fb67cf1c27c53ab"
                  :recipe (:host github :repo "magit/with-editor"))
        (package! helm-ag)
        (package! org-re-reveal :recipe
                (:host gitlab :repo "oer/org-re-reveal"))
        (package! origami :recipe
                (:host github :repo "gregsexton/origami.el"))
        (package! org-sticky-header :recipe
                (:host github :repo "alphapapa/org-sticky-header"))
        (package! org-tree-slide)
        (package! org-hyperscheduler :recipe
                (:host github :repo "dmitrym0/org-hyperscheduler"))
        (package! org-anki :recipe
                (:host github :repo "eyeinsky/org-anki"))
        (package! pdf-continuous-scroll-mode :recipe
                (:host github :repo "dalanicolai/pdf-continuous-scroll-mode.el"))
        (package! pdf-view-restore)
        ;; (package! nov)
        ;; (disable-packages! org-noter-pdftools)
        (unpin! org-pdftools)
        (package! org-pdftools
                :pin "5618b6c9176db11daf0208aa538ddf2c4c2aa5fd"
                :recipe
                (:host github :repo "lytex/org-pdftools"))
        (unpin! org-noter-pdftools)
        (package! org-noter-pdftools
                :pin "5618b6c9176db11daf0208aa538ddf2c4c2aa5fd"
                :recipe
                (:host github :repo "lytex/org-pdftools"))
        ;; https://github.com/fuxialexander/org-pdftools/issues/93
        (unpin! org-noter)
        (package! org-noter 
                :pin "ab838691f0d6ae281597451de311f71a50ba8da6"
                :recipe
                (:host github :repo "org-noter/org-noter"))
        (package! org-web-tools)
        (package! org-download :recipe
                (:host github :repo "abo-abo/org-download"))
        (package! fzf)
        (package! beacon)
        (package! evil-quickscope :recipe
                (:host github :repo "blorbx/evil-quickscope"))
        (package! targets :recipe
                (:host github :repo "noctuid/targets.el"))))

;; (if WORK_ENV
;;   (package! org-trello :recipe
;;         (:host github :repo "org-trello/org-trello" :build (:not native-compile))))
;; (if WORK_ENV
;;   (package! org-jira :recipe
;;         (:host github :repo "ahungry/org-jira")))

(package! org-caldav :recipe
        (:host github :repo "dengste/org-caldav"))

(package! ob-docker-build :recipe
  (:host github :repo "ifitzpat/ob-docker-build"))

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

        ))
;; (package! calfw :recipe
;;         (:host github :repo "kiwanami/emacs-calfw"))

;; (package! calfw-org :recipe
;;         (:host github :repo "kiwanami/emacs-calfw"))

;; (package! org-timeline :recipe
;;         (:host github :repo "Fuco1/org-timeline"))

;; (package! org-vcard)
