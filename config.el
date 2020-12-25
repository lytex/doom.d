;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;; Allow hardlinks to be opened in its own directory
(setq find-file-existing-other-name nil)
(setq find-file-visit-truename nil)

(load! "~/.doom.d/work.el")

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Julian Lopez Carballal")
(if WORK_ENV
    (setq user-mail-address "julopezc@acciona.com")
    (setq user-mail-address "julianlpc15@gmail.com"))


;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
(setq doom-font (font-spec :family "Fantasque Sans Mono" :size 14))
(setq doom-unicode-font (font-spec :name "Fantasque Sans Mono" :size 14))
(setq org-emph-face (font-spec :family "Fantasque Sans Mono" :size 14))
;; Set headline weight to normal instead of bold
(defun my/org-mode-hook ()
  (dolist (face '(org-level-1
                  org-level-2
                  org-level-3
                  org-level-4
                  org-level-5
                  org-level-6
                  org-level-7
                  org-level-8))
    (set-face-attribute face nil :weight 'normal))
  (set-face-attribute 'org-ellipsis nil :foreground "orange")
    (setq tab-width 2))
(add-hook 'org-mode-hook 'my/org-mode-hook)
(beacon-mode 1)
(setq beacon-color "dark orange")


;;(require 'fira-code-mode)
;; (custom-set-variable 'fira-code-mode-disabled-ligatures '("[]" "#{" "#(" "#_" "#_(" "x")) ;; List of ligatures to turn off

;; Enable fira-code-mode automatically for programming major modes
;; (add-hook 'prog-mode-hook 'fira-code-mode)
;; Or, you can use the global mode instead of adding a hook:
;; (global-fira-code-mode)

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; org-mode config ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (with-eval-after-load "org"
;;     (setq org-emphasis-alist (cons (cons "!"  '(:foreground "Yellow")) org-emphasis-alist)))

(setq org-directory "~/org/")

(setq org-cycle-open-archived-trees t)

(if WORK_ENV
(setq org-agenda-files
  '("~/org" "~/org/roam" "~/org/journal" "~/org/projects" "~/org/work_journal"))
(setq org-agenda-files
  '("~/org" "~/org/roam" "~/org/journal" "~/org/projects")))

(defun my/org-sparse-tree1 ()
  (interactive)
  (org-match-sparse-tree nil "+TODO=\"TODO\"|+TODO=\"NEXT\"|+TODO=\"BLOCK\"|+TODO=\"ONGOING\"|+TODO=\"TICKLER\"|+TODO=\"VERIFY\"|+someday|+maybe|+incubate|+idea"))

(defun my/org-sparse-tree2 ()
  (interactive)
  (org-match-sparse-tree nil "+TODO=\"TODO\"|+TODO=\"NEXT\"|+TODO=\"BLOCK\"|+TODO=\"ONGOING\"|+TODO=\"TICKLER\"|+TODO=\"VERIFY\"|+someday|+maybe"))

(map! :after org
      :leader
      :prefix ("rs" . "my/org-sparse-tree")
      :desc (documentation 'my/org-sparse-tree1) "f" #'my/org-sparse-tree1
      :desc (documentation 'my/org-sparse-tree2) "j" #'my/org-sparse-tree2)

(if WORK_ENV
    (setq org-id-locations-file (concat org-directory ".orgids_work"))
    (setq org-id-locations-file (concat org-directory ".orgids")))
(after! org-journal
(setq org-journal-carryover-items
"TODO=\"TODO\"|TODO=\"REFILE\"|TODO=\"NEXT\"|TODO=\"BLOCK\"|TODO=\"ONGOING\"|TODO=\"TICKLER\"|TODO=\"VERIFY\""))

(after! org
(setq org-todo-keywords
	'((sequence  "TODO(t)" "REFILE(r)" "NEXT(n)" "BLOCK(b)" "ONGOING(o)" "TICKLER(k)" "VERIFY(v)" "|" "DONE(d)" )))
    (setq org-priority-highest ?A)
    (setq org-priority-lowest ?F)
    (setq org-default-priority ?E)
    (setq org-priority-default ?E)
    (org-indent-mode)
    (map! :leader
      :desc (documentation 'org-mark-ring-goto)  "m[" #'org-mark-ring-goto
      :desc (documentation 'org-insert-drawer) "nid" #'org-insert-drawer))
(setq org-id-link-to-org-use-id t)  ;; Always use id instead of file
(setq  org-startup-folded t)        ;; Start with folded view
(setq org-ellipsis "⤵")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; highlight words between ! ... !
;; https://dev.to/gonsie/highlighting-in-org-mode-291h
(font-lock-add-keywords 'org-mode
  '(("\\W\\(![^\n\r\t]+!\\)\\W" 1 '(face highlight invisible nil) prepend)) 'append)

(defface annotation-1
  '((((class color) (min-colors 88) (background dark)) (:foreground "chocolate1"))
    (((class color) (min-colors 8)  (background dark)) (:foreground "red"))
    (t (:bold t :italic t)))
  "Annotation-1")

(defface annotation-2
  '((((class color) (min-colors 88) (background dark)) (:foreground "DeepSkyBlue"))
    (((class color) (min-colors 8)  (background dark)) (:foreground "cyan"))
    (t (:bold t :italic t)))
  "Annotation-2")

(font-lock-add-keywords 'org-mode
  '(("\\W\\(«[^\n\r\t]+»\\)\\W" 1 '(face annotation-1 invisible nil) prepend)) 'append)

(font-lock-add-keywords 'org-mode
  '(("\\W\\(“[^\n\r\t]+”\\)\\W" 1 '(face annotation-2 invisible nil) prepend)) 'append)

;; Add evil-surround with these new characters
(use-package! evil-surround)
(add-hook 'org-mode-hook (lambda ()
(let
    ((pairs
      '((?« "« " . " »")
        (?» "«" . "»")
        (?“ "“ " . " ”")
        (?” "“" . "”"))))
  (prependq! evil-surround-pairs-alist pairs)
  (prependq! evil-embrace-evil-surround-keys
             (mapcar #'car pairs)))))


;; Disable autoindents when pressing RET on a list
(add-hook 'org-mode-hook (lambda () (electric-indent-local-mode -1)))


(defun my/revert-buffer-reload-roam ()
    (interactive)
    (revert-buffer)
    (org-roam)
    (org-mode)
    (org-roam))
(map!
      :after org-roam
      :leader
      "bo" #'my/revert-buffer-reload-roam)

(use-package! org-roam
      :custom
      (org-roam-directory "~/org/")
      (org-roam-file-exclude-regexp  "0.org")
      (add-hook 'org-mode-hook (lambda () (org-roam-mode 1))))

;; weird behavior      :hook (org-load . org-roam-mode)

;; :custom (add-hook 'org-mode-hook (lambda () (org-roam-mode 1)))
;; shows backlinks in current file (self-links)

;; :hook (org-load . org-roam-mode)
;; only shows links from another files (not self-links)


;; (after! org-roam
;; (setq org-id-extra-files (org-roam--list-all-files)))


;;;;;;;;;;;;;;;;;;;;;;;; org-journal & org-roam-capture ;;;;;;;;;;;;;;;;;;;;;;;;

(defun my/set-work-journal ()
        (setq org-journal-dir (concat org-directory "work_journal/"))
        ;; Workaround to work with orgzly -> each file must have a unique name
        (setq orgzly-org-journal-file-format "%Y-%m-%dW.org")
        (setq org-journal-file-format orgzly-org-journal-file-format)
        ;; All work journal files have the tag "work"
        (setq org-journal-file-header "#+FILETAGS: :work:")
        (setq org-journal-date-format "%A, %d de %B de %Y :work:"))

(defun my/set-personal-journal ()
        (setq org-journal-dir (concat org-directory "journal/"))
        (setq orgzly-org-journal-file-format "%Y-%m-%d.org")
        (setq org-journal-file-format orgzly-org-journal-file-format)
        (setq org-journal-file-header "")
        (setq org-journal-date-format "%A, %d de %B de %Y"))

(defun my/set-introspection-journal ()
        (setq orgzly-org-journal-file-format "%Y-%m-%dI.org")
        (setq org-journal-file-format orgzly-org-journal-file-format)
        (setq org-journal-dir (concat org-directory "Introspección/"))
        (setq org-journal-date-format "%A, %d de %B de %Y"))

(if WORK_ENV
    (my/set-work-journal)
    (my/set-personal-journal))

(use-package! org-journal
  :custom
  (org-journal-date-prefix "* ")
  (if WORK_ENV
      (setq org-journal-date-format "%A, %d de %B de %Y :work:")
      (setq org-journal-date-format "%A, %d de %B de %Y"))
  (org-journal-file-format orgzly-org-journal-file-format)
  (org-journal-after-entry-create-hook (lambda ()
    (org-set-property "CREATED" (format-time-string "[%Y-%m-%d %a %H:%M]"))
    (call-interactively 'org-close-fold))))

(defun my/set-org-journal (option)
(if (string= option "J")
    (my/set-personal-journal))
(if (string= option "W")
    (my/set-work-journal))
(if (string= option "I")
    (my/set-introspection-journal)))

(defun my/set-org-journal-J ()
    (interactive)
    (my/set-org-journal "J"))
(defun my/set-org-journal-I ()
    (interactive)
    (my/set-org-journal "I"))
(defun my/set-org-journal-W ()
    (interactive)
    (my/set-org-journal "W"))


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

(defun org-journal-find-location ()
  ;; Open today's journal, but specify a non-nil prefix argument in order to
  ;; inhibit inserting the heading; org-capture will insert the heading.
  (org-journal-new-entry t))

(after! org-roam
(setq org-roam-capture-templates
    '(("d" "default" plain (function org-roam-capture--get-point)
        "* ${title}\n%?"
        :file-name "roam/%<%Y%m%d%H%M%S>-${slug}"
        :head "#+title: ${title}\n"
        :unnarrowed t)
      ("r" "refile" plain (function org-roam-capture--get-point)
        "%?"
        :unnarrowed t)
      ("p" "project" plain (function org-roam-capture--get-point)
        "* ${title}\n%?"
        :file-name "projects/${slug}" 
        :head "#+title: ${title}\n#+filetags :project:\n"
        :unnarrowed t))))

(defun my/org-capture-inbox ()
  (interactive)
  (org-capture nil "i"))

(map! 
      :after org-capture
      :leader
      :desc (documentation 'my/org-capture-inbox) "ii" #'my/org-capture-inbox)

(after! org-capture
(setq org-capture-templates
      '(("i" "inbox" entry (file "Inbox.org")
          "* REFILE %?\n:PROPERTIES:\n:CREATED: [%<%Y-%m-%d %a %H:%M>]\n:END:"
        :unnarrowed t))))


(after! org-roam
;; Use a standard template for ref without content
;; For ref with content, save and focus on the new note
(setq org-roam-capture-ref-templates
      '(("r" "ref" plain (function org-roam-capture--get-point)
        "%?"
        :file-name "roam/${slug}"
        :head "#+title: ${title}\n#+roam_key: ${ref}"
        :unnarrowed t)
        ("i" "inbox" plain (function org-roam-capture--get-point)
        "* REFILE ${title}\n:PROPERTIES:\n:CREATED: [%<%Y-%m-%d %a %H:%M>]\n:END:\n${ref}%?"
        :file-name "Inbox"
        :unnarrowed t)
        ("c" "content" plain (function org-roam-capture--get-point)
        "%?"
        :file-name "roam/${slug}"
        :head "#+title: ${title}\n#+roam_key: ${ref}\n%(org-web-tools--url-as-readable-org \"${ref}\")"
        :unnarrowed t
        :immediate-finish t
        :jump-to-captured t))))

(after! org-roam
(setq org-roam-completion-everywhere t))

(after! company
(add-to-list 'company-backends 'company-capf))

(use-package! org-roam-protocol)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;; org-roam by headings ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun temp-title-buffer (title)
  (with-temp-buffer
      (insert (concat "#+title: " title))))

(defun my/org-roam-heading-unlinked-references ()
  "Get unlinked references for current heading"
  (interactive)
  (setq heading (nth 4 (org-heading-components)))
  (setq old-buffer (buffer-name))
  (temp-title-buffer heading)
  (org-roam-unlinked-references)
  (switch-to-buffer-other-window old-buffer)
  (previous-buffer))

(defun my/org-roam-heading-backlinks ()
  "Narrow backlinks by current heading id"
  (interactive)
  (setq id (org-id-copy))
  (setq old-buffer (buffer-name))
  (unless (org-roam) (org-roam))
  (switch-to-buffer-other-window (get-buffer "*org-roam*"))
  (org-occur id)
  (switch-to-buffer-other-window old-buffer))

(defun my/org-roam-headings-all ()
  "Get both backlinks and unlinked refs for current heading"
  (interactive)
  (my/org-roam-heading-unlinked-references)
  (my/org-roam-heading-backlinks))


(use-package! helm-org-rifle)

(map! :after helm-org-rifle
      :leader
      :prefix "n"
      :desc (documentation 'helm-org-rifle)  "rr" #'helm-org-rifle
      :desc (documentation 'helm-org-rifle-directories)  "rd" #'helm-org-rifle-directories)

(require 'helm-source)
(after! helm-source
(use-package! org-recent-headings
  :config (org-recent-headings-mode)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;; org-roam open buffer ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my/org-roam-open-buffer-at (position)
  (setq old-org-roam-buffer-position org-roam-buffer-position)
  (setq org-roam-buffer-position position)
  (org-roam)
  (setq org-roam-buffer-position old-org-roam-buffer-position))

(defun my/org-roam-open-buffer-at-bottom ()
  "Open a new roam buffer at the bottom while keeping current org-roam-buffer-position"
  (interactive)
  (my/org-roam-open-buffer-at 'bottom))

(defun my/org-follow-link-vsplit ()
  "Follow link in a new buffer to the right"
  (interactive)
  (evil-window-vsplit)
  (evil-window-right 1)
  (org-open-at-point))

(defun my/org-open-new-buffer ()
  "Open link in a new right window and open org-roam-buffer at the bottom"
  (interactive)
  (evil-window-vsplit)
  (evil-window-right 1)
  (org-open-at-point)
  (setq old-org-roam-buffer-height org-roam-buffer-height)
  (setq org-roam-buffer-height 0.35)
  (my/org-roam-open-buffer-at 'bottom)
  (setq org-roam-buffer-height old-org-roam-buffer-height))


;;;;;;;;;;;;;;;;;;;;;;;;;;; org-roam link and refile ;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; from https://yiming.dev/blog/2018/03/02/my-org-refile-workflow/
;; refile-targets are only opened files
(defun +org/opened-buffer-files ()
  "Return the list of files currently opened in emacs"
  (delq nil
        (mapcar (lambda (x)
                  (if (and (buffer-file-name x)
                           (string-match "\\.org$"
                                         (buffer-file-name x)))
                      (buffer-file-name x)))
                (buffer-list))))

(setq org-refile-targets '((+org/opened-buffer-files :maxlevel . 9)))

(defun my/org-link-and-refile ()
  "Replace a heading with a link and refile it"
  (interactive)
  (call-interactively 'org-store-link)
  (save-excursion
      (org-insert-heading)
      (org-insert-link))
  (call-interactively 'org-refile))

;; From https://emacs.stackexchange.com/questions/8045/org-refile-to-a-known-fixed-location
(defun my/refile (file headline)
  (let ((pos (save-excursion
               (find-file file)
               (org-find-exact-headline-in-buffer headline))))
    (org-refile nil nil (list headline file nil pos))))

(defun my/org-refile-to-capture ()
  "Refile a heading to a new file using org-roam-capture"
  (interactive)
  (org-roam-capture)
  (setq new-file (org-roam-capture--get :file-path))
  (save-buffer)
  (delete-window)
  (my/refile new-file ""))

(defun my/org-link-and-refile-to-capture ()
  "Replace a heading with a link and refile to a new file using org-roam-capture"
  (interactive)
  (call-interactively 'org-store-link)
  (org-insert-heading)
  (org-insert-link)
  (org-previous-visible-heading 1)
  (my/org-refile-to-capture))


;;;;;;;;;;;;;; org mode id autocompletion in all org-agenda files ;;;;;;;;;;;;;;
;; https://emacs.stackexchange.com/questions/12391/insert-org-id-link-at-point-via-outline-path-completion
;; autocomplete with all links by setting the targets as org-refile-targets
(defun org-id-complete-link (&optional arg)
  "Create an id: link using completion"
  (concat "id:"
   (org-id-get-with-outline-path-completion org-refile-targets)))

(org-link-set-parameters "id"
                         :complete 'org-id-complete-link)

;;;;;;;;;;;;;;;;;;;;;;;;; org-roam & related mappings ;;;;;;;;;;;;;;;;;;;;;;;;;;

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; misc org plugins ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package! org-sticky-header
    :config
    (add-hook 'org-mode-hook (lambda () (org-sticky-header-mode 1))))

(use-package! org-web-tools)

(use-package! org-ql)

(defun my/clean-xtra-newlines ()
  (interactive)
  (replace-regexp "\n\n+" "\n"))

(map! :after org-web-tools
      :leader
      :prefix "m"
      :desc (documentation 'org-web-tools-insert-web-page-as-entry) "w" 
                #'org-web-tools-insert-web-page-as-entry)

(use-package! org-wild-notifier)

(after! org-wild-notifier
  (org-wild-notifier-mode))
(setq alert-user-configuration '((nil libnotify ((:persistent . t)) )) )


(use-package! counsel)

(map! :after counsel
      :leader
      :prefix "f"
      :desc (documentation 'counsel-fzf) "z" #'counsel-fzf)


;; org-bullets has to be loaded AFTER org-roam
;; otherwise it breaks org-roam
(use-package! org-bullets
    :config
    (add-hook 'org-mode-hook (lambda () (org-bullets-mode t))))

;; (require 'org-vcard) ;; Only needed when loading contacts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; pdf and notes ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package! pdf-view-restore
  :after pdf-tools
  :config
  (add-hook 'pdf-view-mode-hook 'pdf-view-restore-mode))

(setq pdf-view-restore-filename "~/.emacs.d/.pdf-view-restore")

(use-package! org-pdftools
  :hook ((org-load . org-pdftools-setup-link))
          (pdf-tools-enable-minor-mode))
(pdf-loader-install)

(use-package! pdf-continuous-scroll-mode
  :after pdf-tools
  :config
  (add-hook 'pdf-view-mode-hook 'pdf-continuous-scroll-mode))

(use-package! pdf-history
  :after pdf-tools
  :config
  (add-hook 'pdf-view-mode-hook 'pdf-history-minor-mode))

(use-package! pdf-annot
  :after pdf-tools
  :config
  (add-hook 'pdf-view-mode-hook 'pdf-annot-minor-mode))

(defun my/pdf-annot-add-markup-annotation () (interactive)
                (call-interactively 'pdf-annot-add-markup-annotation))
(defun my/pdf-annot-add-squiggly-markup-annotation () (interactive)
                (call-interactively 'pdf-annot-add-squiggly-markup-annotation))
(defun my/pdf-annot-add-highlight-markup-annotation () (interactive)
                (call-interactively 'pdf-annot-add-highlight-markup-annotation))
(defun my/pdf-annot-add-strikeout-markup-annotation () (interactive)
                (call-interactively 'pdf-annot-add-strikeout-markup-annotation))
(defun my/pdf-annot-add-underline-markup-annotation () (interactive)
                (call-interactively 'pdf-annot-add-strikeout-markup-annotation))
(defun my/pdf-annot-add-text-annotation () (interactive)
                (call-interactively 'pdf-annot-add-text-annotation))

(after! (pdf-tools)
(map! :leader
      :mode (pdf-view-mode)
      :prefix ("a" . "annotations in pdf")
      :desc (documentation 'pdf-annot-add-markup-annotation) 
      "m" #'my/pdf-annot-add-markup-annotation
      :desc (documentation 'pdf-annot-add-squiggly-markup-annotation) 
      "g" #'my/pdf-annot-add-squiggly-markup-annotation
      :desc (documentation 'pdf-annot-add-highlight-markup-annotation)
      "h" #'my/pdf-annot-add-highlight-markup-annotation
      :desc (documentation 'pdf-annot-add-strikeout-markup-annotation)
      "s" #'my/pdf-annot-add-strikeout-markup-annotation
      :desc (documentation 'pdf-annot-add-underline-markup-annotation)
      "u" #'my/pdf-annot-add-underline-markup-annotation
      :desc (documentation 'pdf-annot-add-text-annotation)
      "t" #'my/pdf-annot-add-text-annotation)
(map! :leader
      :mode (pdf-view-mode)
      :prefix "p"
      :desc (documentation 'pdf-history-backward)  "[" #'pdf-history-backward
      :desc (documentation 'pdf-history-forward)  "]" #'pdf-history-forward))

(use-package! org-noter-pdftools
  :after org-noter
  :config
  (with-eval-after-load 'pdf-annot
    (add-hook 'pdf-annot-activate-handler-functions #'org-noter-pdftools-jump-to-note)))


(defun my/clean-pdf-fontifications ()
  (replace-regexp "ﬃ" "ffi") 
  (replace-regexp "ﬁ" "fi") 
  (replace-regexp "ﬀ" "ff")
  (replace-regexp ". . ." "..."))

(defun my/clean-skeleton ()
  (interactive)
  (my/clean-xtra-newlines)
  (my/clean-pdf-fontifications)
  (replace-regexp "\*\*\*\*\*[\*]* Contents\n" "")
  (my/clean-xtra-newlines))
  
(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
(use-package! nov)

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;; org-transclusion (wip) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(auto-save-mode nil)
(setq make-backup-files nil)
(setq org-transclusion-include-first-section t)
(use-package! org-transclusion)
(auto-save-mode nil)
(setq make-backup-files nil)
(setq org-transclusion-include-first-section t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; xournalpp ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun my:org-edit-sketch (sketch-name)
  (async-start-process "xournalpp-sketch" "xournalpp" nil
    (concat (format-time-string "~/Documents/xournalpp/%Y%m%d%H%M%S") "-" sketch-name ".xopp" )))

(org-link-set-parameters "sketch" :follow 'my:org-edit-sketch)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; excorporate ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; from https://emacs.stackexchange.com/a/46022
(if WORK_ENV
(progn 
;; configure excorporate
;; allow opening the exchange calendar with 'e' from calendar 
(evil-define-key 'motion calendar-mode-map "e" #'exco-calendar-show-day)

(setq-default
 ;; configure email address and office 365 exchange server adddress for exchange web services
 excorporate-configuration
  (quote
   (user-mail-address . "https://outlook.office365.com/EWS/Exchange.asmx"))
  ;; integrate emacs diary entries into org agenda
  org-agenda-include-diary t
  )
;; activate excorporate and request user/password to start connection
(excorporate)
;; enable the diary integration (i.e. write exchange calendar to emacs diary file -> ~/.emacs.d/diary must exist)
(excorporate-diary-enable)
(defun ab/agenda-update-diary ()
  "call excorporate to update the diary for today"
  (exco-diary-diary-advice (calendar-current-date) (calendar-current-date) #'message "diary updated"))

;; update the diary every time the org agenda is refreshed
(add-hook 'org-agenda-cleanup-fancy-diary-hook 'ab/agenda-update-diary )))
