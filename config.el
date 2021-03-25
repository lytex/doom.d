;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq org-id-locations-file "~/.emacs.d/.org-id-locations")

(load! "~/.doom.d/work.el")


(setq user-full-name "Julian Lopez Carballal")
(if WORK_ENV
    (setq user-mail-address "julopezc@acciona.com")
    (setq user-mail-address "julianlpc15@gmail.com"))


(setq doom-font (font-spec :family "Fantasque Sans Mono" :size 14))
(setq doom-unicode-font (font-spec :name "Fantasque Sans Mono" :size 14))
(setq org-emph-face (font-spec :family "Fantasque Sans Mono" :size 14))

(beacon-mode 1)
(setq beacon-color "dark orange")

(setq doom-theme 'doom-one)

(load! "~/.doom.d/modules/org.el")

(load! "~/.doom.d/modules/evil.el")

(load! "~/.doom.d/modules/xournalpp.el")

(load! "~/.doom.d/modules/org-roam.el")

(map!
      :after org-roam
      :leader
      "bo" #'my/revert-buffer-reload-roam)

(map! :after org-roam
      :leader
      :prefix ("r" . "org-roam")
      :desc (documentation 'org-roam) "o" #'org-roam
      :desc (documentation 'org-roam-unlinked-references) "u" #'org-roam-unlinked-references
      :desc (documentation 'org-roam-capture) "c" #'org-roam-capture
      :desc (documentation 'org-roam-insert) "i" #'org-roam-insert
      :desc (documentation 'org-roam-find-file) "r" #'org-roam-find-file
      :desc (documentation 'my/org-roam-open-buffer-at-bottom) "j" #'my/org-roam-open-buffer-at-bottom
      :desc (documentation 'my/org-open-new-buffer) "n" #'my/org-open-new-buffer
      :desc (documentation 'my/org-follow-link-vsplit) "v" #'my/org-follow-link-vsplit
      :desc (documentation 'org-roam-graph) "g" #'org-roam-graph)

(map! :after org-roam
      :leader
      :prefix ("rp" . "my/xournalpp")
      :desc (documentation 'my/insert-global-sketch) "i" #'my/insert-global-sketch
      :desc (documentation 'my/reset-sketch) "p" #'my/reset-sketch)

(map! :after org-roam
      :leader
      :prefix ("rf" . "my/org-roam-refile")
      :desc (documentation 'my/org-link-and-refile) "l" #'my/org-link-and-refile
      :desc (documentation 'my/org-refile-to-capture) "c" #'my/org-refile-to-capture
      :desc (documentation 'my/org-link-and-refile-to-capture) "b" #'my/org-link-and-refile-to-capture)
      
(map! :after org-roam
      :leader
      :prefix ("rh" . "my/org-roam-heading")
      :desc (documentation 'my/org-roam-heading-backlinks) "o" #'my/org-roam-heading-backlinks
      :desc (documentation 'my/org-roam-heading-unlinked-references) "u" #'my/org-roam-heading-unlinked-references
      :desc (documentation 'my/org-roam-headings-all) "l" #'my/org-roam-headings-all)

(load! "~/.doom.d/modules/org-journal.el")

(map!
      :after org-journal
      :leader
      "jm" #'org-journal-mode)
(map!
      :leader
      "om" #'org-mode)

(map! 
      :after org-journal
      :leader
      :desc (documentation 'org-journal-new-entry)  "mj" #'org-journal-new-entry
      "jj" #'my/set-org-journal-J
      "ji" #'my/set-org-journal-I
      "jw" #'my/set-org-journal-W)

(load! "~/.doom.d/modules/org-misc.el")

(load! "~/.doom.d/modules/org-ql.el")

(map!
      :after org-ql-search
      :leader
      :prefix ("oq" . "org-ql-search")
      :desc (documentation 'oql/refile-not-inbox)  "rfn" #'oql/refile-not-inbox
      :desc (documentation 'oql/today)  "to" #'oql/today
      :desc (documentation 'oql/next-3-days)  "n3" #'oql/next-3-days
      :desc (documentation 'oql/week)  "w" #'oql/week
      :desc (documentation 'oql/templates)  "te" #'oql/templates
      :desc (documentation 'oql/habits)  "ha" #'oql/habits
      )

(use-package! helm-rg)
(setq helm-rg-default-directory org-directory)
(map! :after helm-org-rifle
      :leader
      :prefix ("nr" . "helm-org-rifle")
      :desc (documentation 'helm-org-rifle)  "r" #'helm-org-rifle
      :desc (documentation 'helm-org-rifle-directories)  "d" #'helm-org-rifle-directories
      :desc (documentation 'helm-org-rifle-occur)  "o" #'helm-org-rifle-occur
      :desc (documentation 'helm-rg) "g" #'helm-rg)

(load! "~/.doom.d/modules/pdf.el")

(use-package! highlight-indent-guides
  :hook (prog-mode . highlight-indent-guides-mode)
  :init
  (setq highlight-indent-guides-method 'character))

(add-hook 'ediff-load-hook
               (lambda ()
                 (set-face-background
                   ediff-current-diff-face-A  "red")
                 (set-face-background
                   ediff-current-diff-face-B "blue")))

(use-package! activity-watch-mode)
(global-activity-watch-mode)


(load! "~/.doom.d/modules/org-transclusion.el")

;; (load! "~/.doom.d/modules/excorporate.el")

(if WORK_ENV
  (use-package! org-trello))

(load! "~/.doom.d/modules/org-export.el")

(defun my/disable-emojify (match &rest ignored)
  (or (string= match "↔") (string= match "↖") (string= match "↗") (string= match "↘") (string= match "↙")))

(add-hook 'emojify-inhibit-functions #'my/disable-emojify)

(setq org-id-locations-file "~/.emacs.d/.org-id-locations")
