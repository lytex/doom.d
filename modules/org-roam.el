
(defun my/revert-buffer-reload-roam ()
    (interactive)
    (revert-buffer)
    (org-roam)
    (org-mode)
    (org-roam))


(use-package! org-roam
      :custom
      (org-roam-directory "~/org/")
      (org-roam-file-exclude-regexp  "\\(0\\|1\\)\\(custom_id\\)?.org")
      (add-hook 'org-mode-hook (lambda () (org-roam-mode 1))))


;;;;;;;;;;;;;;;;;;;;;;;;;; org-roam-capture templates ;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun org-journal-find-location ()
  ;; Open today's journal, but specify a non-nil prefix argument in order to
  ;; inhibit inserting the heading; org-capture will insert the heading.
  (org-journal-new-entry t))

(after! org-roam
(setq org-roam-capture-templates
    '(("d" "default" plain (function org-roam-capture--get-point)
        "* ${title}\n%?"
        :file-name "roam/%<%Y%m%d%H%M%S>-${slug}"
        :head "#+title: ${title}\n\n"
        :unnarrowed t)
      ("r" "refile" plain (function org-roam-capture--get-point)
        "%?"
        :unnarrowed t)
      ("p" "project" plain (function org-roam-capture--get-point)
        "* ${title} :project:\n%?"
        :file-name "projects/${slug}" 
        :head "#+title: ${title}\n#+filetags: :project:\n\n"
        :unnarrowed t)
      ("a" "area" plain (function org-roam-capture--get-point)
        "* ${title} :area:\n%?"
        :file-name "areas/${slug}" 
        :head "#+title: ${title}\n#+filetags: :area:\n\n"
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
        "* ${title}\n%?"
        :file-name "roam/${slug}"
        :head "#+title: ${title}\n#+roam_key: ${ref}\n\n"
        :unnarrowed t)
        ("i" "inbox" plain (function org-roam-capture--get-point)
        "* REFILE ${title}\n:PROPERTIES:\n:CREATED: [%<%Y-%m-%d %a %H:%M>]\n:END:\n${ref}\n%?"
        :file-name "Inbox"
        :unnarrowed t)
        ("c" "content" plain (function org-roam-capture--get-point)
        "%?"
        :file-name "roam/${slug}"
        :head "#+title: ${title}\n#+roam_key: ${ref}\n\n%(org-web-tools--url-as-readable-org \"${ref}\")"
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
  (if (org-roam)
    ; if org-roam-buffer is closed, keep it closed
    (org-roam)
    ; if org-roam-buffer is opened, reopen at bottom
    (progn
      (org-roam)
      (org-roam)
      (my/org-roam-open-buffer-at 'bottom)))
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