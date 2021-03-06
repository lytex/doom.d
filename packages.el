;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

(load! "~/.doom.d/work.el")

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
;(package! some-package)

;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/raxod502/straight.el#the-recipe-format
;(package! another-package
;  :recipe (:host github :repo "username/repo"))
(package! highlight-indent-guides)
(package! org-roam :recipe
        (:host github :repo "org-roam/org-roam"))
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

(package! org-caldav :recipe
        (:host github :repo "dengste/org-caldav"))

(package! emojify :recipe
        (:host github :repo "iqbalansari/emacs-emojify"))
;(package! org-vcard)

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
;(package! this-package
;  :recipe (:host github :repo "username/repo"
;           :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
;(package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
;(package! builtin-package :recipe (:nonrecursive t))
;(package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see raxod502/straight.el#279)
;(package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
;(package! builtin-package :pin "1a2b3c4d5e")


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
;(unpin! pinned-package)
;; ...or multiple packages
;(unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
;(unpin! t)
