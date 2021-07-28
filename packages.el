;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

(load! "~/.doom.d/work.el")

(package! org-roam :recipe
        (:host github :repo "org-roam/org-roam")
        :pin "9065f6a999b98d4b495e3d8fa1fa4424eddd25a8")
(package! org-wild-notifier :recipe
        (:host github :repo "akhramov/org-wild-notifier.el")
        :pin "772806f9d46fb93cabe9409c7a559eb7b9cda3d3")
(package! org-bullets :recipe
        (:host github :repo "integral-dw/org-bullets")
        :pin "767f55feb58b840a5a04eabfc3fbbf0d257c4792")
(package! org-transclusion :recipe
        (:host github :repo "nobiot/org-transclusion")
        :pin "8bf2ecc2dffc9d365e0f14d45158f44df587fb12")
(package! helm-org-rifle)
(package! org-recent-headings :recipe
        (:host github repo "alphapapa/org-recent-headings")
        :pin "5da516a1586675992c0122ed32978c18dda06318")
(package! org-ql :recipe
        (:host github :repo "alphapapa/org-ql")
        :pin "94f9e6f3031b32cf5e2149beca7074807235dcb0")
(package! origami :recipe
        (:host github :repo "gregsexton/origami.el"
        :pin "e558710a975e8511b9386edc81cd6bdd0a5bda74"))
(package! org-sticky-header :recipe
        (:host github :repo "alphapapa/org-sticky-header")
        :pin "79136b8c54c48547ba8a07a72a9790cb8e23ecbd")
(package! pdf-continuous-scroll-mode :recipe
        (:host github :repo "dalanicolai/pdf-continuous-scroll-mode.el")
        :pin "615dcfbf7a9b2ff602a39da189e5eb766600047f")
(package! pdf-view-restore :recipe
        (:host github :repo "007kevin/pdf-view-restore")
        :pin "5a1947c01a3edecc9e0fe7629041a2f53e0610c9")
(package! nov)
(package! org-noter-pdftools :recipe
        (:host github :repo "fuxialexander/org-pdftools")
        :pin "a5b61bca3f8c91b0859bb0df1a929f9a31a57b99")
(package! org-web-tools :recipe
        (:host github :repo "alphapapa/org-web-tools")
        :pin "b94a07add8558ef7b0666173dbb8a2554f1d41a6")
(package! fzf :recipe
        (:host github :repo "seenaburns/fzf.el")
        :pin "499b532403364d4e7af3c289dab989678da3c1e1")
(package! beacon :recipe
        (:host github :repo "Malabarba/beacon.git")
        :pin "bde78180c678b233c94321394f46a81dc6dce1da")
(package! evil-quickscope :recipe 
        (:host github :repo "blorbx/evil-quickscope")
        :pin "37a20e4c56c6058abf186ad4013c155e695e876f")
(if WORK_ENV
  (package! excorporate))
(if WORK_ENV
  (package! org-trello :recipe
        (:host github :repo "org-trello/org-trello" :build (:not native-compile))))
(package! activity-watch-mode :recipe
        (:host github :repo "pauldub/activity-watch-mode")
        :pin "9d591c5ec9a2b2c7b55a754dd37c7434b2ef9fdc")

(package! org-caldav :recipe
        (:host github :repo "dengste/org-caldav")
        :pin "8569941a0a5a9393ba51afc8923fd7b77b73fa7a")

;; (package! calfw :recipe
;;         (:host github :repo "kiwanami/emacs-calfw"))

;; (package! calfw-org :recipe
;;         (:host github :repo "kiwanami/emacs-calfw"))

;; (package! org-timeline :recipe
;;         (:host github :repo "Fuco1/org-timeline"))

;; (package! org-vcard)