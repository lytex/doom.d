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
(setq doom-font (font-spec :family "FuraMono Nerd Font" :size 12))
(setq doom-unicode-font (font-spec :name "FuraMono Nerd Font" :size 12))
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
(setq org-directory "~/org/")

(setq org-agenda-files
  '("~/org" "~/org/roam" "~/org/journal" "~/org/projects"))
(if WORK_ENV
    (setq org-id-locations-file (concat org-directory ".orgids_work"))
    (setq org-id-locations-file (concat org-directory ".orgids")))
(after! org
(setq org-todo-keywords
	'((sequence  "TODO(t)" "REFILE(r)" "NEXT(n)" "BLOCK(b)" "ONGOING(o)" "TICKLER(k)" "VERIFY(v)" "|" "DONE(d)" "ARCHIVED(a)" )))
    (setq org-priority-highest ?A)
    (setq org-priority-lowest ?F)
    (setq org-default-priority ?E)
    (setq org-priority-default ?E)
    (org-indent-mode)
    (map! :leader
      :desc (documentation 'org-mark-ring-goto)  "m[" #'org-mark-ring-goto))
(setq org-id-link-to-org-use-id t)  ;; Always use id instead of file
(setq  org-startup-folded t)        ;; Start with folded view

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


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
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(use-package! org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
(defun my/revert-buffer-close-roam ()
    (interactive)
    (revert-buffer)
    (org-roam))
(map!
      :after org-roam
      :leader
      "bo" #'my/revert-buffer-close-roam)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(use-package! org-roam
      :hook
      (after-init . org-roam-mode)
      :custom
      (org-roam-directory "~/org/")
      (org-roam-file-exclude-regexp  "jira/.*"))
(after! org-roam
(setq org-id-extra-files (org-roam--list-all-files)))

(use-package! company-org-roam
  :when (featurep! :completion company)
  :after org-roam
  :config
  (set-company-backend! 'org-mode '(company-org-roam company-yasnippet company-dabbrev)))


;; Workaround to work with orgzly -> each file must have a unique name
(if WORK_ENV
  (setq org-journal-dir (concat org-directory "work_journal/"))
  (setq org-journal-dir (concat org-directory "journal/")))
(if WORK_ENV
  (setq orgzly-org-journal-file-format "%Y-%m-%dW.org")
  (setq orgzly-org-journal-file-format "%Y-%m-%d.org"))

(use-package! org-journal
  :custom
  (org-journal-date-prefix "* ")
  (org-journal-date-format "%A, %d de %B de %Y")
  (org-journal-file-format orgzly-org-journal-file-format))

(defun my/set-org-journal (option)
(if (string= option "J")
    (progn  (setq orgzly-org-journal-file-format "%Y-%m-%d.org")
            (setq org-journal-dir (concat org-directory "journal/"))))
(if (string= option "I")
    (progn  (setq orgzly-org-journal-file-format "%Y-%m-%dI.org")
            (setq org-journal-dir (concat org-directory "Introspección/"))))
(if (string= option "W")
    (progn  (setq orgzly-org-journal-file-format "%Y-%m-%dW.org")
            (setq org-journal-dir (concat org-directory "work_journal/")))))

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
        "%?"
        :file-name "roam/%<%Y%m%d%H%M%S>-${slug}"
        :head "#+title: ${title}\n"
        :unnarrowed t)
      ("j" "journal" plain (function org-journal-find-location)
        "** %(format-time-string org-journal-time-format)%^{Title}\n%i%?"
        :file-name "journal/%<%Y-%m-%d>" ;; TODO use org-roam-journal-path
        :head "* %<%A, %d de %B de %Y>\n"
        :unnarrowed t)
      ("i" "introspección" plain (function org-roam-capture--get-point)
        "** %<%H:%M> %^{Title}\n%i%?"
        :file-name "Introspección/%<%Y-%m-%d>I"
        :head "* %<%A, %d de %B de %Y>\n"
        :unnarrowed t)
      ("p" "project" plain (function org-roam-capture--get-point)
        "%?"
        :file-name "projects/${slug}" 
        :head "#+title: ${title}\n#+filetags :project:\n"
        :unnarrowed t))))


(after! org-roam
;; Use a standard template for ref without content
;; For ref with content, save and focus on the new note
(setq org-roam-capture-ref-templates
      '(("r" "ref" plain (function org-roam-capture--get-point)
        "%?"
        :file-name "roam/${slug}"
        :head "#+TITLE: ${title}\n#+ROAM_KEY: ${ref}"
        :unnarrowed t)
        ("c" "content" plain (function org-roam-capture--get-point)
        "%?"
        :file-name "roam/${slug}"
        :head "#+TITLE: ${title}\n#+ROAM_KEY: ${ref}\n%(org-web-tools--url-as-readable-org \"${ref}\")"
        :unnarrowed t
        :immediate-finish t
        :jump-to-captured t))))

(use-package! org-roam-protocol)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; org-roam open buffer ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun org-roam-open-buffer-at (position)
  (setq old-org-roam-buffer-position org-roam-buffer-position)
  (setq org-roam-buffer-position position)
  (org-roam)
  (setq org-roam-buffer-position old-org-roam-buffer-position))

(defun org-roam-open-buffer-at-bottom ()
  "Open a new roam buffer at the bottom while keeping current org-roam-buffer-position"
  (interactive)
  (org-roam-open-buffer-at 'bottom))

(defun org-follow-link-to-the-side ()
  "Follow link in a new buffer to the right"
  (interactive)
  (evil-window-vsplit)
  (evil-window-right 1)
  (org-open-at-point))

(defun org-open-new-buffer ()
  "Open link in a new left window and open org-roam-buffer at the bottom"
  (interactive)
  (evil-window-vsplit)
  (evil-window-right 1)
  (org-open-at-point)
  (setq old-org-roam-buffer-height org-roam-buffer-height)
  (setq org-roam-buffer-height 0.35)
  (org-roam-open-buffer-at 'bottom)
  (setq org-roam-buffer-height old-org-roam-buffer-height))


;;;;;;;;;;;;;;;;;;;;;;;;;;; org-roam link and refile ;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun org-link-and-refile ()
  "Replace a heading with a link and refile it"
  (interactive)
  (call-interactively 'org-store-link)
  (org-insert-heading)
  (org-insert-link)
  (org-previous-visible-heading 1)
  (call-interactively 'org-refile))

;; From https://emacs.stackexchange.com/questions/8045/org-refile-to-a-known-fixed-location
(defun my/refile (file headline)
  (let ((pos (save-excursion
               (find-file file)
               (org-find-exact-headline-in-buffer headline))))
    (org-refile nil nil (list headline file nil pos))))

(defun org-refile-to-capture ()
  "Refile a heading to a new file using org-roam-capture"
  (interactive)
  (org-roam-capture)
  (setq new-file (org-roam-capture--get :file-path))
  (save-buffer)
  (delete-window)
  (my/refile new-file ""))

(defun org-link-and-refile-to-capture ()
  "Replace a heading with a link and refile to a new file using org-roam-capture"
  (interactive)
  (call-interactively 'org-store-link)
  (org-insert-heading)
  (org-insert-link)
  (org-previous-visible-heading 1)
  (org-refile-to-capture))

(use-package! org-sticky-header)

(map! :leader
      :prefix "r"
      :desc (documentation 'org-link-and-refile) "fl" #'org-link-and-refile
      :desc (documentation 'org-refile-to-capture) "fc" #'org-refile-to-capture
      :desc (documentation 'org-link-and-refile-to-capture) "fb" #'org-link-and-refile-to-capture)

(map! :after org-roam
      :leader
      :prefix "r"
      :desc (documentation 'org-roam) "o" #'org-roam
      :desc (documentation 'org-roam-open-buffer-at-bottom) "j" #'org-roam-open-buffer-at-bottom
      :desc (documentation 'org-open-new-buffer) "n" #'org-open-new-buffer
      :desc (documentation 'org-follow-link-to-the-side) "s" #'org-follow-link-to-the-side
      :desc (documentation 'org-roam-graph) "g" #'org-roam-graph
      :desc (documentation 'org-roam-capture) "c" #'org-roam-capture
      :desc (documentation 'org-roam-insert) "i" #'org-roam-insert
      :desc (documentation 'org-roam-unlinked-references) "u" #'org-roam-unlinked-references)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;; org-roam by headings ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun org-roam-heading-unlinked-references ()
  "Get unlinked references for current heading"
  (interactive)
  (setq heading (nth 4 (org-heading-components)))
  (temp-title-buffer heading)
  (org-roam-unlinked-references))

(defun org-roam-heading-backlinks ()
  "Narrow backlinks by current heading id"
  (interactive)
  (setq id (org-id-copy))
  (setq old-buffer (buffer-name))
  (unless (org-roam) (org-roam))
  (switch-to-buffer-other-window (get-buffer "*org-roam*"))
  (org-occur id)
  (switch-to-buffer-other-window old-buffer))

(map! :after org-roam
      :leader
      :prefix "r"
      :desc (documentation 'org-roam-heading-backlinks) "ho" #'org-roam-heading-backlinks
      :desc (documentation 'org-roam-heading-unlinked-references) "hu" #'org-roam-heading-unlinked-references)


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

(if WORK_ENV
  (load! "~/.doom.d/jira.el"))

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

(require 'org-web-tools)

(map! :after org-web-tools
      :leader
      :prefix "m"
      :desc (documentation 'org-web-tools-insert-web-page-as-entry) "w" 
                #'org-web-tools-insert-web-page-as-entry)

(use-package! org-wild-notifier)

(after! org-wild-notifier
  (org-wild-notifier-mode))
(setq alert-user-configuration '((nil libnotify ((:persistent . t)) )) )

(map! :after counsel
      :leader
      :prefix "f"
      :desc (documentation 'counsel-fzf) "z" #'counsel-fzf)

;; (after! pdf-tools
;; (map! :leader
;;       :mode (pdf-view-mode)
;;       :prefix "a"
;;       :desc (documentation 'pdf-annot-add-markup-annotation)  "m" #'pdf-annot-add-markup-annotation
;;       :desc (documentation 'pdf-annot-add-squiggly-markup-annotation)  "g" #'pdf-annot-add-squiggly-markup-annotation
;;       :desc (documentation 'pdf-annot-add-highlight-markup-annotation)  "h" #'pdf-annot-add-highlight-markup-annotation
;;       :desc (documentation 'pdf-annot-add-strikeout-markup-annotation)  "s" #'pdf-annot-add-strikeout-markup-annotation
;;       :desc (documentation 'pdf-annot-add-underline-markup-annotation)  "u" #'pdf-annot-add-underline-markup-annotation
;;       :desc (documentation 'pdf-annot-add-text-annotation)  "t" #'pdf-annot-add-text-annotation)
;; (map! :leader
;;       :mode (pdf-view-mode)
;;       :prefix "p"
;;       :desc (documentation 'pdf-history-backward)  "[" #'pdf-history-backward
;;       :desc (documentation 'pdf-history-forward)  "]" #'pdf-history-forward))

(use-package! org-noter-pdftools
  :after org-noter
  :config
  (with-eval-after-load 'pdf-annot
    (add-hook 'pdf-annot-activate-handler-functions #'org-noter-pdftools-jump-to-note)))

(use-package! highlight-indent-guides
  :ensure t
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

;; TODO Workaround for dark theme, remove later
(defface org-transclusion-source-block
  '((((class color) (min-colors 88) (background light))
     :background "#fff3da" :extend t)
    (((class color) (min-colors 88) (background dark))
     :background "#000c25" :extend t))
  "Face for transcluded block.")

(defface org-transclusion-block
  '((((class color) (min-colors 88) (background light))
     :background "#f3f3ff" :extend t)
    (((class color) (min-colors 88) (background dark))
     :background "#0c0c00" :extend t))
  "Face for transcluded block.")

(use-package! org-transclusion)
