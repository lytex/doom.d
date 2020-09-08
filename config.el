;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

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
(if WORK_ENV
    (setq org-id-locations-file (concat org-directory ".orgids_work"))
    (setq org-id-locations-file (concat org-directory ".orgids")))
(after! org
(setq org-todo-keywords
	'((sequence  "TODO(t)" "REFILE(r)" "NEXT(n)" "BLOCK(b)" "ONGOING(o)" "TICKLER(k)" "VERIFY(v)" "|" "DONE(d)")))
    (setq org-priority-highest ?A)
    (setq org-priority-lowest ?F)
    (setq org-default-priority ?E)
    (setq org-priority-default ?E)
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
      (org-roam-file-exclude-regexp  "~/org/jira/*"))
(after! org-roam
(setq org-id-extra-files (org-roam--list-all-files)))

(require 'company-org-roam)
    (use-package company-org-roam
      :when (featurep! :completion company)
      :after org-roam
      :config
      (set-company-backend! 'org-mode '(company-org-roam company-yasnippet company-dabbrev)))

(if WORK_ENV
  (setq org-roam-capture-directory "work_roam/")
  (setq org-roam-capture-directory "roam/"))
(setq org-roam-capture-path (concat org-roam-capture-directory "%<%Y%m%d%H%M%S>-${slug}"))

(setq org-roam-capture-templates
    '(("d" "default" plain (function org-roam--capture-get-point)
        "%?"
        :file-name "roam/%<%Y%m%d%H%M%S>-${slug}" ;; TODO use org-roam-capture-path
        :head "#+title: ${title}\n* ${title}\nCREATED:%T\n:PROPERTIES:\n:custom_id: ${title}\n:END:\n"
        :unnarrowed t
        :jump-to-captured nil)))

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

(after! org-roam
      (map! :leader
            :prefix "r"
            :desc (documentation 'org-roam) "o" #'org-roam
            :desc (documentation 'org-roam-open-buffer-at-bottom) "j" #'org-roam-open-buffer-at-bottom
            :desc (documentation 'org-open-new-buffer) "n" #'org-open-new-buffer
            :desc (documentation 'org-follow-link-to-the-side) "s" #'org-follow-link-to-the-side
            :desc (documentation 'org-roam-graph) "g" #'org-roam-graph
            :desc (documentation 'org-roam-capture) "c" #'org-roam-capture
            :desc (documentation 'org-roam-insert) "i" #'org-roam-insert
            :desc (documentation 'org-roam-insert) "u" #'org-roam-unlinked-references))

(use-package! org-journal
  :custom
  (org-journal-date-prefix "* ")
  (org-journal-date-format "%A, %d de %B de %Y")
  (org-journal-file-format "%Y-%m-%d.org"))
(if WORK_ENV
  (setq org-journal-dir (concat org-directory "work_journal/"))
  (setq org-journal-dir (concat org-directory "journal/")))
(if WORK_ENV
  (setq inbox-file "Work_Inbox.org")
  (setq inbox-file "Inbox.org"))

(map! :leader
      :desc (documentation 'org-journal-new-entry)  "mj" #'org-journal-new-entry)
(setq org-default-notes-file inbox-file)
(setq org-capture-templates
      '(("t" "Todo" entry (file inbox-file)
         "* TODO %?\n  %i\n  %a")))
(require 'helm-org-rifle)

(map! :leader
      :prefix "n"
      :desc (documentation 'helm-org-rifle)  "rr" #'helm-org-rifle
      :desc (documentation 'helm-org-rifle-directories)  "rd" #'helm-org-rifle-directories)

(use-package! org-recent-headings
  :config (org-recent-headings-mode))

(require 'org-notify)
(org-notify-start)
(org-notify-add 'default '(:time "1m" :actions -notify/window :duration 36000))

(if WORK_ENV
  (load! "~/.doom.d/jira.el"))

;; (require 'org-vcard) ;; Only needed when loading contacts