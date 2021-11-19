;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-



(load! "~/.doom.d/work.el")


(setq user-full-name "Julian Lopez Carballal")
(if WORK_ENV
    (setq user-mail-address "julopezc@acciona.com")
    (setq user-mail-address "julianlpc15@gmail.com"))

 ;; Calendar starts on monday
(setq calendar-week-start-day 1)


(setq doom-font (font-spec :family "Fantasque Sans Mono" :size 14))
(setq doom-unicode-font (font-spec :name "Fantasque Sans Mono" :size 14))
(setq org-emph-face (font-spec :family "Fantasque Sans Mono" :size 14))

(beacon-mode 1)
(setq beacon-color "dark orange")

(setq doom-theme 'doom-one)

(load! "~/.doom.d/modules/LectureNotes.el")

(load! "~/.doom.d/modules/org.el")

(load! "~/.doom.d/modules/org-clock.el")

(map!
      :after org
      :leader
      :desc (documentation 'bh/punch-in) "mcpi" #'bh/punch-in
      :desc (documentation 'bh/punch-out) "mcpo" #'bh/punch-out
      )


(load! "~/.doom.d/modules/evil.el")
(load! "~/.doom.d/modules/xournalpp.el")


(setq  persp-save-dir (expand-file-name (concat org-directory ".sessions")))

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
      :desc (documentation 'org-journal-new-scheduled-entry)  "mJ " #'org-journal-new-scheduled-entry
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
      :after org-ql
      :leader
      :prefix ("oq" . "org-ql-search")
      :desc (documentation 'org-ql-view)  "w" #'org-ql-view
      :desc (documentation 'org-ql-view-sidebar)  "s" #'org-ql-view-sidebar
      :desc (documentation 'org-ql-sparse-tree)  "t" #'org-ql-sparse-tree
      :desc (documentation 'org-ql-search)  "q" #'org-ql-search
      :desc (documentation 'lytex/reload-org-ql)  "r" #'lytex/reload-org-ql)

(map! :after org-ql
      :leader
      :prefix ("rt" . "lytex/org-sparse-tree")
      :desc (documentation 'lytex/org-sparse-tree-full) "j" #'lytex/org-sparse-tree-full
      :desc (documentation 'lytex/org-sparse-tree-almost-full) "k" #'lytex/org-sparse-tree-almost-full
      :desc (documentation 'lytex/org-sparse-tree-trimmed) "l" #'lytex/org-sparse-tree-trimmed
      :desc (documentation 'lytex/org-sparse-sparse-tree) ";" #'lytex/org-sparse-sparse-tree
      :desc (documentation 'lytex/org-sparse-sparse-sparse-tree) "'" #'lytex/org-sparse-sparse-sparse-tree
      :desc (documentation 'lytex/org-jira-assigned) "e" #'lytex/org-jira-assigned
)


(use-package! helm-rg)
(setq helm-rg-default-directory org-directory)
(map! :after helm
      :leader
      :desc (documentation 'helm-rg) "nrg" #'helm-rg)

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
      :desc (documentation 'org-noter-insert-precise-note) "i" #'org-noter-insert-precise-note
      :desc (documentation 'org-noter-kill-session) "q" #'org-noter-kill-session))

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


(load! "~/.doom.d/modules/org-transclusion.el"  )

;; (load! "~/.doom.d/modules/excorporate.el")

(if WORK_ENV
  (use-package! org-trello))

(if WORK_ENV
  (load! "~/.doom.d/jira.el"))

(load! "~/.doom.d/modules/org-export.el")

(load! "~/.doom.d/modules/org-caldav.el")

(use-package! emojify)

(add-hook 'after-init-hook #'global-emojify-mode)

(defun lytex/disable-emojify (match &rest ignored)
  (or (string= match "↔") (string= match "↖") (string= match "↗") (string= match "↘") (string= match "↙")))

(add-hook 'emojify-inhibit-functions #'lytex/disable-emojify)

(setq org-id-locations-file "~/.emacs.d/.org-id-locations")
(defun lytex/toggle-work ()
  "Toggle work profile"
  (interactive)
  (setq WORK_ENV (not WORK_ENV))
  (lytex/reload-org-ql))
(map!
      :after org-ql
      :leader
      :desc (documentation 'lytex/toggle-work) "tw" #'lytex/toggle-work)
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


;; Disable hl-mode or all faces will be the same!
(defun what-face (pos)
  (interactive "d")
  (let ((face (or (get-char-property (point) 'read-face-name)
                  (get-char-property (point) 'face))))
    (if face (message "Face: %s" face) (message "No face at %d" pos))))
