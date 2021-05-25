;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-



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
      "bo" #'lytex/revert-buffer-reload-roam)

(map! :after org-roam
      :leader
      :prefix ("r" . "org-roam")
      :desc (documentation 'org-roam) "o" #'org-roam
      :desc (documentation 'org-roam-unlinked-references) "u" #'org-roam-unlinked-references
      :desc (documentation 'org-roam-capture) "c" #'org-roam-capture
      :desc (documentation 'org-roam-insert) "i" #'org-roam-insert
      :desc (documentation 'org-roam-find-file) "r" #'org-roam-find-file
      :desc (documentation 'lytex/org-roam-open-buffer-at-bottom) "j" #'lytex/org-roam-open-buffer-at-bottom
      :desc (documentation 'lytex/org-open-new-buffer) "n" #'lytex/org-open-new-buffer
      :desc (documentation 'lytex/org-follow-link-vsplit) "v" #'lytex/org-follow-link-vsplit
      :desc (documentation 'org-roam-graph) "g" #'org-roam-graph)

(map! :after org-roam
      :leader
      :prefix ("rp" . "lytex/xournalpp")
      :desc (documentation 'lytex/insert-global-sketch) "i" #'lytex/insert-global-sketch
      :desc (documentation 'lytex/reset-sketch) "p" #'lytex/reset-sketch)

(map! :after org-roam
      :leader
      :prefix ("rf" . "lytex/org-roam-refile")
      :desc (documentation 'lytex/org-link-and-refile) "l" #'lytex/org-link-and-refile
      :desc (documentation 'lytex/org-refile-to-capture) "c" #'lytex/org-refile-to-capture
      :desc (documentation 'lytex/org-link-and-refile-to-capture) "b" #'lytex/org-link-and-refile-to-capture)

(map! :after org-roam
      :leader
      :prefix ("rh" . "lytex/org-roam-heading")
      :desc (documentation 'lytex/org-roam-heading-backlinks) "o" #'lytex/org-roam-heading-backlinks
      :desc (documentation 'lytex/org-roam-heading-unlinked-references) "u" #'lytex/org-roam-heading-unlinked-references
      :desc (documentation 'lytex/org-roam-headings-all) "l" #'lytex/org-roam-headings-all)

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
      "jj" #'lytex/set-org-journal-J
      "ji" #'lytex/set-org-journal-I
      "jw" #'lytex/set-org-journal-W)

(map! :after org-journal
      :leader
      :desc (documentation 'org-journal-previous-entry) "jp" #'org-journal-previous-entry
      :desc (documentation 'org-journal-next-entry) "jn" #'org-journal-next-entry)

(load! "~/.doom.d/modules/org-misc.el")

(load! "~/.doom.d/modules/org-ql.el")

(map!
      :after org-ql-search
      :leader
      :prefix ("oq" . "org-ql-search")
      :desc (documentation 'oql/refile-not-inbox)  "rfn" #'oql/refile-not-inbox
      :desc (documentation 'oql/today)  "to" #'oql/today
      :desc (documentation 'oql/next-3-days)  "n3" #'oql/next-3-days
      :desc (documentation 'oql/week)  "we" #'oql/week
      :desc (documentation 'oql/templates)  "te" #'oql/templates
      :desc (documentation 'oql/habits)  "ha" #'oql/habits
      :desc (documentation 'oql/todo)  "td" #'oql/todo
      :desc (documentation 'oql/ongoing)  "ong" #'oql/ongoing
      :desc (documentation 'oql/ongoing-left)  "onl" #'oql/ongoing-left
      :desc (documentation 'oql/ongoing-projects)  "onp" #'oql/ongoing-projects
      :desc (documentation 'oql/work)  "wo" #'oql/work
      :desc (documentation 'oql/research)  "re" #'oql/research
      :desc (documentation 'oql/learn)  "le" #'oql/learn
      :desc (documentation 'oql/try)  "try" #'oql/try
      :desc (documentation 'oql/indepth)  "ind" #'oql/indepth
      :desc (documentation 'oql/refile)  "rff" #'oql/refile
      )

(map! :after org-ql
      :leader
      :prefix ("rt" . "lytex/org-sparse-tree")
      :desc (documentation 'lytex/org-sparse-tree-full) "j" #'lytex/org-sparse-tree-full
      :desc (documentation 'lytex/org-sparse-tree-almost-full) "k" #'lytex/org-sparse-tree-almost-full
      :desc (documentation 'lytex/org-sparse-tree-trimmed) "l" #'lytex/org-sparse-tree-trimmed)


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

(after! (pdf-tools)
(map! :leader
      :mode (pdf-view-mode)
      :prefix ("a" . "annotations in pdf")
      :desc (documentation 'pdf-annot-add-markup-annotation)
      "a" #'lytex/pdf-annot-add-markup-annotation
      :desc (documentation 'pdf-annot-add-squiggly-markup-annotation)
      "g" #'lytex/pdf-annot-add-squiggly-markup-annotation
      :desc (documentation 'pdf-annot-add-highlight-markup-annotation)
      "f" #'lytex/pdf-annot-add-highlight-markup-annotation
      :desc (documentation 'pdf-annot-add-strikeout-markup-annotation)
      "s" #'lytex/pdf-annot-add-strikeout-markup-annotation
      :desc (documentation 'pdf-annot-add-underline-markup-annotation)
      "d" #'lytex/pdf-annot-add-underline-markup-annotation
      :desc (documentation 'lytex/join-org-headline-previous)
      "p" #'lytex/join-org-headline-previous
      :desc (documentation 'lytex/join-org-headline-next)
      "n" #'lytex/join-org-headline-next)


(map! :leader
      :mode (pdf-view-mode)
      :prefix "p"
      :desc (documentation 'pdf-history-backward)  "[" #'pdf-history-backward
      :desc (documentation 'pdf-history-forward)  "]" #'pdf-history-forward))

(after! org-noter
      (map! :leader
      :prefix ("on" . "org-noter")
      :desc (documentation 'org-noter-sync-current-note) "s" #'org-noter-sync-current-note
      :desc (documentation 'org-noter-sync-prev-note) "p" #'org-noter-sync-prev-note
      :desc (documentation 'org-noter-sync-next-note) "n" #'org-noter-sync-next-note
      :desc (documentation 'org-noter-insert-precise-note) "i" #'org-noter-insert-precise-note))

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

(defun lytex/disable-emojify (match &rest ignored)
  (or (string= match "↔") (string= match "↖") (string= match "↗") (string= match "↘") (string= match "↙")))

(add-hook 'emojify-inhibit-functions #'lytex/disable-emojify)

(setq org-id-locations-file "~/.emacs.d/.org-id-locations")
;; From https://emacs.stackexchange.com/a/33344:
(defun yf/advice-list (symbol)
  (let (result)
    (advice-mapc
     (lambda (ad props)
       (push ad result))
     symbol)
    (nreverse result)))

(defun yf/kill-advice (symbol advice)
  "Kill ADVICE from SYMBOL."
  (interactive (let* ((sym (intern (completing-read "Function: " obarray #'yf/advice-list t)))
                      (advice (let ((advices-and-their-name
                                     (mapcar (lambda (ad) (cons (prin1-to-string ad)
                                                                ad))
                                             (yf/advice-list sym))))
                                (cdr (assoc (completing-read "Remove advice: " advices-and-their-name nil t)
                                            advices-and-their-name)))))
                 (list sym advice)))
  (advice-remove symbol advice))
