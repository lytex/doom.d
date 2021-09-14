
(use-package! org)

(setq org-id-locations-file "~/.emacs.d/.org-id-locations")
(setq org-directory "~/org/")
(setq org-link-file-path-type 'absolute) ;; Absolute links with ~ when possible
(setq org-display-remote-inline-image 'cache)

(setq org-cycle-open-archived-trees t)

(defun lytex/org-mode-hook ()
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
(add-hook 'org-mode-hook 'lytex/org-mode-hook)

(if WORK_ENV
(setq org-agenda-files
  '("~/org"  "~/org/areas" "~/org/roam" "~/org/journal" "~/org/projects" "~/org/work_journal"))
(setq org-agenda-files
  '("~/org" "~/org/areas" "~/org/roam" "~/org/journal" "~/org/projects")))

(setq org-log-into-drawer "LOGBOOK") ;; Log state changes in LOGBOOK
(setq org-log-done 'time)

(after! org-journal
(setq org-journal-carryover-items
"TODO=\"TODO\"|TODO=\"MAYBE\"|TODO=\"SOMEDAY\"|TODO=\"REFILE\"|TODO=\"NEXT\"|TODO=\"BLOCK\"|TODO=\"ONGOING\"|TODO=\"TICKLER\"|TODO=\"VERIFY\""))

(after! org
;; ! →  log when entering the state
;; \! → log when entering the state and also when leaving it
;; https://orgmode.org/manual/Tracking-TODO-state-changes.html#Tracking-TODO-state-changes
(setq org-todo-keywords
  '((sequence  "TODO(t!)" "ONGOING(o!)" "NEXT(n)" "BLOCK(b\!)" "SOMEDAY(s)" "MAYBE(m)" "DEFINED(e)" "REFILE(r)" "TICKLER(k)" "VERIFY(v)" "|" "DONE(d!)" "CANCELLED(c)" )))
    (setq org-priority-highest ?A)
    (setq org-priority-lowest ?F)
    (setq org-default-priority ?E)
    (setq org-priority-default ?E)
    (setq  org-priority-faces
    '((?A :foreground "red" :background "yellow")
      (?B . "dark orange")
      (?C . "yellow")
      (?D . "green")
      (?E . "cyan")
      (?F . "dark magenta")))
    (org-indent-mode)
    (map! :leader
      :desc (documentation 'org-mark-ring-goto)  "m[" #'org-mark-ring-goto
      :desc (documentation 'org-insert-drawer) "nid" #'org-insert-drawer))

(setq org-todo-keyword-faces
  '(("TODO"  . org-todo)
  ("MAYBE" . +org-todo-project)
  ("SOMEDAY" . +org-todo-project)
  ("DEFINED" . +org-todo-project)
  ("REFILE"  . org-todo)
  ("NEXT"  . org-todo)
  ("BLOCK"  . org-todo)
  ("ONGOING"  . org-todo)
  ("TICKLER" . +org-todo-project)
  ("VERIFY"  . org-todo)
 	("DONE"  . org-done)
 	("CANCELLED"  . org-done)))

(setq org-log-done nil)             ;; Do not log CLOSED time when DONE
(setq org-todo-repeat-to-state t)   ;; Do not repeat to TODO if previous state was not TODO
(setq org-id-link-to-org-use-id t)  ;; Always use id instead of file
(setq  org-startup-folded t)        ;; Start with folded view
(setq org-ellipsis "↴")

;; Disable autoindents when pressing RET on a list
(add-hook 'org-mode-hook (lambda () (electric-indent-local-mode -1)))

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

;; https://emacs.stackexchange.com/questions/60710/is-there-any-way-of-getting-overview-statistics-for-all-checkboxes-in-a-given-or
;; org-cookies also for subheadings
(defun aggregate-org-cookies ()
  (save-excursion
    (org-back-to-heading t)
    (let* ((prop (string-match "\\<aggregate\\>"
                               (or (org-entry-get nil "COOKIE_DATA") ""))))
      (if prop
          (let* ((counts (aggregate-one-level))
                 (numerator (car counts))
                 (denominator (cadr counts))
                 (cookie-regex "\\[\\([0-9]*\\)/\\([0-9]*\\)\\]")
                 (new (format "[%d/%d]" numerator denominator)))
            (re-search-forward cookie-regex (line-end-position) t)
            (if (match-beginning 0)
                (progn
                  (setq beg (match-beginning 0)
                        ndel (- (match-end 0) beg))
                  (goto-char beg)
                  (insert new)
                  (delete-region (point) (+ (point) ndel))
                  ))))
      (if (org-up-heading-safe)
          (aggregate-org-cookies)))))

(defun aggregate-one-level ()
  (save-excursion
    (let* ((current (point))
           (next (save-excursion (outline-next-heading) (point)))
           (numerator 0)
           (denominator 0)
           (cookie-regex "\\[\\([0-9]*\\)/\\([0-9]*\\)\\]")
           )
      (defun count-one ()
        (re-search-forward cookie-regex (line-end-position) t)
        (if (> (match-end 1) (match-beginning 1))
            `(,(string-to-number (match-string 1))
              ,(string-to-number (match-string 2)))
          (0 0 )))
        (while (> next current)
          (goto-char next)
          (setq current next
                next (save-excursion (org-forward-heading-same-level 1) (point))
                current_total (count-one)
                denominator (+ denominator (cadr current_total))
                numerator (+ numerator (car current_total))))
          
        `(,numerator ,denominator))))

(add-hook 'org-checkbox-statistics-hook (function aggregate-org-cookies))

;;;;;;;;;;;;;; org mode id autocompletion in all org-agenda files ;;;;;;;;;;;;;;
;; https://emacs.stackexchange.com/questions/12391/insert-org-id-link-at-point-via-outline-path-completion
;; autocomplete with all links by setting the targets as org-refile-targets
(defun org-id-complete-link (&optional arg)
  "Create an id: link using completion"
  (concat "id:"
   (org-id-get-with-outline-path-completion org-refile-targets)))

(org-link-set-parameters "id"
                         :complete 'org-id-complete-link)

(defun lytex/remove-refile (&optional arg default-buffer rfloc msg)
"If todo keyword at point is equal to REFILE, remove it"
(setq todo-keyword-at-point
(substring-no-properties
;; concat "" to nil converts it to the empty string
(concat ""
 (plist-get
  (plist-get
   (org-element-at-point)
   'headline)
  :todo-keyword))))
(if (string= todo-keyword-at-point "REFILE")
  (org-todo "")))

; remove REFILE keyword before refiling a headline
(advice-add 'org-refile :before 'lytex/remove-refile)

;; Rich copy from HTML
;; from https://xiangji.me/2015/07/13/a-few-of-my-org-mode-customizations/
;; https://emacs.stackexchange.com/questions/12121/org-mode-parsing-rich-html-directly-when-pasting
(defun kdm/html2org-clipboard ()
  "Convert clipboard contents from HTML to Org and then paste (yank)."
  (interactive)
  (kill-new (shell-command-to-string
  ;; Default to regular xclip if the clipboard doesn't contain html
    "echo ${$(xclip -loop 0 -selection clipboard -o -t text/html):-$(xclip -o)} 2>/dev/null | pandoc -f html -t json | pandoc -f json -t org --wrap=none"))
    (yank))

;; This one is for the beginning char
(setcar org-emphasis-regexp-components " \t('\" {")
;; This one is for the ending char.
(setcar (nthcdr 1 org-emphasis-regexp-components) "- \t.,: !?;'\")}\\")

;; Make org-bable templates jinja-like
(setq org-babel-noweb-wrap-start "{{ ")
(setq org-babel-noweb-wrap-end " }}")

;; Evaluate arbitrary local variables, prompting before executing
(setq enable-local-variables t)

;; Replace all ocurrences of ";; blank" with blank space
;; There is no way to control blank space AFAIK
;; https://emacs.stackexchange.com/questions/31738/org-mode-babel-ensure-more-than-one-empty-line-between-tangled-code-blocks-fo
 (add-hook 'org-babel-post-tangle-hook
      #'(lambda () (progn
          (goto-char 0)
            (while (search-forward ";; blank" nil t)
                  (replace-match ""))
          (save-buffer))))
