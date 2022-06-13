
(defun lytex/revert-buffer-reload-roam ()
    (interactive)
    (revert-buffer)
    (org-roam-buffer-toggle)
    (org-roam-buffer-toggle)
    (org-roam-buffer-toggle))


(use-package! org-roam
      :custom
      (org-roam-directory "~/org/")
      (org-roam-file-exclude-regexp  "\\(0\\|1\\)?\\(custom_id\\)?\\(Documents\\).org")
      (add-hook 'org-mode-hook (lambda () (org-roam-mode 1)))
      (org-roam-mode-section-functions
              (list #'org-roam-backlinks-section
              #'org-roam-reflinks-section
              ;; #'org-roam-unlinked-references-section
              ))
      (org-roam-db-gc-threshold most-positive-fixnum)

      (org-roam-db-node-include-function (lambda () (require 'org)
           (or
                (and
                        ;; It's a level 1 top heading and not a file-level id
                        (eq (org-current-level) 1) (not (eq (org-current-level) nil))
                        ;; Has not a REFILE todo-state
                        (not (equal (substring-no-properties (concat "" (org-get-todo-state))) "REFILE"))
                        ;; Has not a ROAM_EXCLUDE property
                        (not (org-entry-properties nil "ROAM_EXCLUDE"))
                        ;; It's not part of an org-trello file
                        (not (org-entry-properties nil "orgtrello_id")))
                        ;; Unless it has an explicit property ROAM_INCLUDE set to t
                        (equal (concat "" (cdr (assoc "ROAM_INCLUDE"
                                         (org-entry-properties nil "ROAM_INCLUDE")))) "t")
                        ))))

      ;; (org-roam-db-node-include-function (lambda () (and (eq (org-current-level) 1))
      ;;   ;; It's not part of an org-trello file
      ;;   (not (seq-filter (lambda (x) (string= (car x) "orgtrello_user_me"))
      ;;     (cdr (mapcar (lambda (prop) (split-string prop " ")) (car (org-collect-keywords '("PROPERTY"))))))))))

(load! "~/.doom.d/headless.el")

(if (not HEADLESS)
(progn
(use-package! websocket
    :after org)

(use-package! org-roam-ui
    :after org ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))


(defun lytex/replace-link-file-with-id (&optional lowercase completions filter-fn description link-type)
  ;; Doesn't work when linking a file to itself
  (save-window-excursion
    (evil-backward-char 1) ;; h in normal mode
    (org-open-at-point)
    ;; if the file has been opened, it returns next headline of level 1 below the cursor
    ;; avoid it by going to the first line
    (evil-goto-first-line)
    (org-forward-heading-same-level 1)
    ;; store link to first headline
    (org-element-map
        (org-element-parse-buffer 'greater-element)
        'headline
      (lambda (hl) (and (= (org-element-property :level hl) 1)
        (goto-char (org-element-property :begin hl)))
          :first-match t)
      (call-interactively 'org-store-link)))

    (if (setq old-org-link-descriptive org-link-descriptive) (org-toggle-link-display))
      ;;; Different behavior depending on whether is text after the cursor   ;;;
      ;;;                          ↓                                         ;;;
      ;;; Around words [[file:...]] the cursor is ok                         ;;;
      ;;;                                                          ↓         ;;;
      ;;; On a empty line, the cursor is one char before [[file:...]]        ;;;
      (evil-forward-char 1)
      (unless (eq ?\] (char-after))
        (evil-backward-char 1))
      ;; Delete [[file:...]] link with da[
      (apply 'evil-delete (evil-a-bracket))
    (if old-org-link-descriptive (org-toggle-link-display))
    (org-insert-link))

;; (advice-add 'org-roam-insert :after 'lytex/replace-link-file-with-id)



;;;;;;;;;;;;;;;;;;;;;;;;;; org-roam-capture templates ;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun org-journal-find-location ()
  ;; Open today's journal, but specify a non-nil prefix argument in order to
  ;; inhibit inserting the heading; org-capture will insert the heading.
  (org-journal-new-entry t))

(after! org-roam
(setq org-roam-capture-templates
    '(("d" "default" plain
        "* ${title}\n%?"
        :target (file+head "roam/%<%Y%m%d%H%M%S>-${slug}.org"
        "#+title: ${title}\n#+SETUPFILE: /home/julian/.doom.d/org-html-themes/org/theme-readtheorg-local.setup\n\n")
        :unnarrowed t)
      ("p" "project" plain
        "* ${title} :project:\n%?"
        :target (file+head "projects/${slug}.org" 
        "#+title: ${title}\n#+filetags: :project:\n#+SETUPFILE: /home/julian/.doom.d/org-html-themes/org/theme-readtheorg-local.setup\n\n")
        :unnarrowed t)
      ("a" "area" plain
        "* ${title} :area:\n%?"
        :target (file+head "areas/${slug}.org"
        "#+title: ${title}\n#+filetags: :area:\n#+SETUPFILE: /home/julian/.doom.d/org-html-themes/org/theme-readtheorg-local.setup\n\n")
        :unnarrowed t))))

(defun lytex/org-capture-inbox (n)
  (interactive "p")
  (org-capture n "i"))

(defun lytex/org-capture-inbox-clock (n)
  (interactive "p")
  (org-capture n "k"))

(map! 
      :after org-capture
      :leader
      :desc (documentation 'lytex/org-capture-inbox) "ii" #'lytex/org-capture-inbox
      :desc (documentation 'lytex/org-capture-inbox-clock) "ik" #'lytex/org-capture-inbox-clock)

(after! org-capture
(setq org-capture-templates
      '(("i" "inbox" entry (file "Inbox.org")
          "* REFILE %?\n:PROPERTIES:\n:CREATED: [%<%Y-%m-%d %a %H:%M>]\n:END:"
        :unnarrowed t)
        ("k" "clock" entry (file "Inbox.org")
                "* REFILE %?\n:PROPERTIES:\n:CREATED: [%<%Y-%m-%d %a %H:%M>]\n:END:"
                :unnarrowed t :clock-in t :clock-keep t)
        ;; Empty entry to be filled later
        ;; https://helpdeskheadesk.net/help-desk-head-desk/sub-menus-in-org/
        ("t" "templates")
        ("c" "cleanup" item (id "b6463bd3-3069-424c-94f5-23be3ce8e2cd") "[ ] Clean %a"
          :unnarrowed t))))


(after! org-roam
;; Use a standard template for ref without content
;; For ref with content, save and focus on the new note
(setq org-roam-capture-ref-templates
      '(("r" "ref" plain 
        "* ${title}\n%?"
        :target (file+head "roam/${slug}.org"
        "#+title: ${title}\n#+roam_key: ${ref}\n#+SETUPFILE: /home/julian/.doom.d/org-html-themes/org/theme-readtheorg-local.setup\n\n")
        :unnarrowed t)
        ("i" "inbox" entry
        "* REFILE ${title}\n:PROPERTIES:\n:CREATED: [%<%Y-%m-%d %a %H:%M>]\n:END:\n${ref}\n%?"
        :target (file "Inbox.org")
        :unnarrowed t)
        ("c" "content" plain
        "%?"
        :target (file+head "roam/${slug}.org"
        "#+title: ${title}\n#+roam_key: ${ref}\n#+SETUPFILE: /home/julian/.doom.d/org-html-themes/org/theme-readtheorg-local.setup\n\n%(org-web-tools--url-as-readable-org \"${ref}\")")
        :unnarrowed t
        :immediate-finish t
        :jump-to-captured t))))

(after! org-roam
(setq org-roam-completion-everywhere nil))

(after! company
(add-to-list 'company-backends 'company-capf))

(use-package! org-roam-protocol)
))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;; org-roam by headings ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun temp-title-buffer (title)
  (with-temp-buffer
      (insert (concat "#+title: " title))))

(defun lytex/org-roam-heading-unlinked-references ()
  "Get unlinked references for current heading"
  (interactive)
  (setq heading (nth 4 (org-heading-components)))
  (setq old-buffer (buffer-name))
  (temp-title-buffer heading)
  (org-roam-unlinked-references)
  (switch-to-buffer-other-window old-buffer)
  (previous-buffer))

(defun lytex/org-roam-heading-backlinks ()
  "Narrow backlinks by current heading id"
  (interactive)
  (setq id (org-id-copy))
  (setq old-buffer (buffer-name))
  (unless (org-roam-buffer-toggle) (org-roam-buffer-toggle))
  (switch-to-buffer-other-window (get-buffer "*org-roam*"))
  (org-occur id)
  (switch-to-buffer-other-window old-buffer))

(defun lytex/org-roam-headings-all ()
  "Get both backlinks and unlinked refs for current heading"
  (interactive)
  (lytex/org-roam-heading-unlinked-references)
  (lytex/org-roam-heading-backlinks))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;; org-roam open buffer ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun lytex/org-roam-open-buffer-at (position)
  (setq old-org-roam-buffer-position org-roam-buffer-position)
  (setq org-roam-buffer-position position)
  (org-roam-buffer-toggle)
  (setq org-roam-buffer-position old-org-roam-buffer-position))

(defun lytex/org-roam-open-buffer-at-bottom ()
  "Open a new roam buffer at the bottom while keeping current org-roam-buffer-position"
  (interactive)
  (lytex/org-roam-open-buffer-at 'bottom))

(defun lytex/org-follow-link-vsplit ()
  "Follow link in a new buffer to the right"
  (interactive)
  (evil-window-vsplit)
  (evil-window-right 1)
  (org-open-at-point))

(defun lytex/org-open-new-buffer ()
  "Open link in a new right window and open org-roam-buffer at the bottom"
  (interactive)
  (evil-window-vsplit)
  (evil-window-right 1)
  (org-open-at-point)
  (setq old-org-roam-buffer-height org-roam-buffer-height)
  (setq org-roam-buffer-height 0.35)
  (if (org-roam-buffer-toggle)
    ; if org-roam-buffer is closed, keep it closed
    (org-roam-buffer-toggle)
    ; if org-roam-buffer is opened, reopen at bottom
    (progn
      (org-roam-buffer-toggle)
      (org-roam-buffer-toggle)
      (lytex/org-roam-open-buffer-at 'bottom)))
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

(defun lytex/org-link-and-refile ()
  "Replace a heading with a link and refile it"
  (interactive)
  (call-interactively 'org-store-link)
  (save-excursion
      (org-insert-heading)
      (org-insert-link))
  (call-interactively 'org-refile))

;; From https://emacs.stackexchange.com/questions/8045/org-refile-to-a-known-fixed-location
(defun lytex/refile (file headline)
  (let ((pos (save-excursion
               (find-file file)
               (org-find-exact-headline-in-buffer headline))))
    (org-refile nil nil (list headline file nil pos))))

(defun lytex/org-refile-to-capture ()
  "Refile a heading to a new file using org-roam-capture"
  (interactive)
  (org-roam-capture)
  (setq new-file (org-roam-capture--get :file-path))
  (save-buffer)
  (delete-window)
  (lytex/refile new-file ""))

(defun lytex/org-link-and-refile-to-capture ()
  "Replace a heading with a link and refile to a new file using org-roam-capture"
  (interactive)
  (call-interactively 'org-store-link)
  (org-insert-heading)
  (org-insert-link)
  (org-previous-visible-heading 1)
  (lytex/org-refile-to-capture))
