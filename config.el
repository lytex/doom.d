;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Julian Lopez"
      user-mail-address "julianlpc15@gmail.com")

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
(setq org-directory "~/org/")

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
 '(package-selected-packages
   (quote
    (use-package org-roam-server neotree fira-code-mode zygospore org-roam org-plus-contrib
    org-bullets))))
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(after! org
(setq org-todo-keywords
	'((sequence "TODO(t)" "NEXT(n)" "BLOCK(b)" "ONGOING(o)" "TICKLER(k)" "VERIFY(v)" "|" "DONE(d)")))
(setq org-priority-highest ?A)
(setq org-priority-lowest ?F)
(setq org-default-priority ?E)
(setq org-priority-default ?E)
(setq org-directory "~/org")
)
(use-package org-roam
      :hook
      (after-init . org-roam-mode)
      :custom
      (org-roam-directory "~/org"))

;; SPC is implicitly included
(map! :leader
      :map org-roam-mode-map
      :desc (documentation 'org-roam) "ro" #'org-roam)
(map! :leader
      :map org-roam-mode-map
      :desc (documentation 'org-roam-graph) "rg" #'org-roam-graph)
(map! :leader
      :map org-roam-mode-map
      :desc (documentation 'org-roam-capture) "rc" #'org-roam-capture)
(map! :leader
      :map org-mode-map
      :desc (documentation 'org-roam-insert) "ri" #'org-roam-insert)


(use-package org-journal
  :custom
  (org-journal-date-prefix "* ")
  (org-journal-date-format "%A, %d de %B de %Y")
  (org-journal-file-format "%Y-%m-%d.org")
  (org-journal-dir "~/org/journal"))

;; SPC is implicitly included
(map! :leader
      :desc (documentation 'org-journal-new-entry)  "mj" #'org-journal-new-entry)
(setq org-default-notes-file (concat org-directory "/Inbox.org"))
(setq org-capture-templates
      '(("t" "Todo" entry (file "~/org/Inbox.org" )
         "* TODO %?\n  %i\n  %a")))
(require 'helm-org-rifle)