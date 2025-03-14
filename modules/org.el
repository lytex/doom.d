 (defun org-metaup-universal ()

   (interactive)
   (condition-case nil
        (org-metaup)
        (user-error
                (save-excursion (forward-line 1) (transpose-lines -1)) (forward-line -1))))

 (defun org-metadown-universal ()
   (interactive)
   (condition-case nil
        (org-metadown)
        (user-error
                (save-excursion (forward-line 1) (transpose-lines 1)) (forward-line 1))))

(advice-add #'+org/insert-item-above :after #'(lambda (count) (org-id-get-create)))
(advice-add #'+org/insert-item-below :after #'(lambda (count) (org-id-get-create)))
(advice-add #'org-insert-subheading :after  #'(lambda (count) (org-id-get-create)))

;; From https://stackoverflow.com/questions/61621608/how-to-open-multiple-urls-at-the-same-time-in-an-emacs-buffer
(defun lytex/get-link (x)
  "Assuming x is a LINK node in an Org mode parse tree,
   return a list consisting of its type (e.g. \"http\")
   and its path."
  (let* ((link (cadr x))
         (type (plist-get link :type))
         (path (plist-get link :path)))
   (if (or (string= type "http") (string= type "https"))
     (list type path))))

(defun lytex/format-url (x)
  "Take a (TYPE PATH) list and return a proper URL. Note
   the following works for http- and https-type links, but
   might need modification for other types."
  (format "%s:%s" (nth 0 x) (nth 1 x)))

;; Also: C-c C-o → org-open-at-point
(defun lytex/visit-all-http-links ()
  (interactive)
  (let* ((parse-tree (org-element-parse-buffer))
         (links (org-element-map parse-tree 'link #'lytex/get-link)))
    (mapcar #'browse-url (mapcar #'lytex/format-url links))))



(map!
        :after org
        :map org-mode-map
        "M-j"      #'org-metadown-universal
        "M-k"      #'org-metadown-universal)


(map!
        :after evil-org
        :map evil-org-mode-map
        "M-j"      #'org-metadown-universal
        "M-k"      #'org-metadown-universal)


(evil-define-key '(normal visual insert) 'evil-org-mode
        (kbd "M-j") #'org-metadown-universal
        (kbd "M-k") #'org-metaup-universal)

(use-package! org)

(defun logseq-link-follow (s &optional avoid-pos stealth)
  (let* ((case-fold-search t)
	 (origin (point))
	 (normalized (replace-regexp-in-string "\n[ \t]*" " " s))
	 (starred (eq (string-to-char normalized) ?*))
	 (words (split-string (if starred (substring s 1) s)))
	 (s-multi-re (mapconcat #'regexp-quote words "\\(?:[ \t\n]+\\)"))
	 (s-single-re (mapconcat #'regexp-quote words "[ \t]+"))
	 type)

    (cond
    ;; Logseq id support
     ((string-match "\\`(\\(\\(.*\\)\\))\\'" normalized)
      ;; Look for coderef targets if S is enclosed within parenthesis.
      (let ((coderef (match-string-no-properties 1 normalized))
	    (re (substring s-single-re 2 -2)))
        (org-id-goto re)))))
  t)

(advice-add #'org-link-search :before-until #'logseq-link-follow)

(setq org-id-locations-file "~/.config/emacs/.org-id-locations")
(setq org-directory "~/org/")
(setq org-link-file-path-type 'absolute) ;; Absolute links with ~ when possible
(setq org-display-remote-inline-images 'cache)

;; https://emacs.stackexchange.com/questions/10354/smooth-mouse-scroll-for-inline-images
;;; Scrolling.
;; Good speed and allow scrolling through large images (pixel-scroll).
;; Note: Scroll lags when point must be moved but increasing the number
;;       of lines that point moves in pixel-scroll.el ruins large image
;;       scrolling. So unfortunately I think we'll just have to live with
;;       this.
(pixel-scroll-mode)
(setq pixel-dead-time 0) ; Never go back to the old scrolling behaviour.
(setq pixel-resolution-fine-flag t) ; Scroll by number of pixels instead of lines (t = frame-char-height pixels).
(setq mouse-wheel-scroll-amount '(1)) ; Distance in pixel-resolution to scroll each mouse wheel event.
(setq mouse-wheel-progressive-speed nil) ; Progressive speed is too fast for me.

(setq org-read-date-force-compatible-dates nil) ;; Get ready for Y2K38

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

(if (not HEADLESS)
        (use-package! org-rainbow-tags))
;; (add-hook 'org-mode-hook 'org-rainbow-tags-mode)

(defun lytex/fix-bad-fonts ()
  (interactive)
  (setq org-bullets-bullet-list '("◉" "✸" "✿"))
  (setq org-ellipsis "…"))

(setq org-list-demote-modify-bullet '(("+" . "-") ("-" . "+") ("1." . "a.") ("1)" . "a)")))

(if WORK_ENV
(setq org-agenda-files
  '("~/org"  "~/org/roam" "~/org/journal" "~/org/projects" "~/org/work_journal"))
(setq org-agenda-files
  '("~/org" "~/org/areas" "~/org/areas/random" "~/org/roam" "~/org/journal" "~/org/projects" "~/org/Introspección")))

(setq org-agenda-inhibit-startup nil)

(setq org-agenda-dim-blocked-tasks nil) ;; Do not grey out items that hava a children with a TODO state

(setq org-log-into-drawer "LOGBOOK") ;; Log state changes in LOGBOOK
(setq org-log-done 'time)

(after! org-journal
(setq org-journal-carryover-items
"TODO=\"TODO\"|TODO=\"MAYBE\"|TODO=\"SOMEDAY\"|TODO=\"REFILE\"|TODO=\"NEXT\"|TODO=\"BLOCK\"|TODO=\"ONGOING\"|TODO=\"TICKLER\"|TODO=\"VERIFY\"|TODO=\"HOLD\""))


(after! org
;; ! →  log when entering the state
;; \! → log when entering the state and also when leaving it
;; https://orgmode.org/manual/Tracking-TODO-state-changes.html#Tracking-TODO-state-changes
(setq org-todo-keywords
  '((sequence  "TODO(t!)" "ONGOING(o!)" "NEXT(n)" "BLOCK(b\!)" "SOMEDAY(s)" "MAYBE(m)" "DEFINED(e)" "HOLD(h\!)" "REFILE(r)" "TICKLER(k)" "VERIFY(v)" "|" "DONE(d!)" "CANCELLED(c)" )))
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


(add-to-list 'org-after-todo-state-change-hook (lambda ()
        (if (not (string= (concat (substring-no-properties (org-get-todo-state)) "") "TICKLER"))
        (org-set-tags (remove "idea" (remove "learn" (remove "process" (remove "read" (remove "research" (remove "track" (remove "try"
                (remove "" (split-string (substring-no-properties (org-make-tag-string (org-get-tags nil t))) ":")) ))))))))
 )))

(add-to-list 'org-after-tags-change-hook (lambda ()
        (if (seq-intersection
        (remove "" (split-string (substring-no-properties (org-make-tag-string (org-get-tags nil t))) ":"))
        '("idea" "learn" "process" "read" "research" "try"))
        (org-todo ""))))

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
  ("HOLD" . +org-todo-project)
  ("VERIFY"  . org-todo)
 	("DONE"  . org-done)
 	("CANCELLED"  . org-done)))

(setq org-modern-todo-faces org-todo-keyword-faces)

(setq org-log-done nil)             ;; Do not log CLOSED time when DONE
(setq org-todo-repeat-to-state t)   ;; Do not repeat to TODO if previous state was not TODO
(setq org-id-link-to-org-use-id t)  ;; Always use id instead of file
(setq org-link-search-must-match-exact-headline nil) ;; file:notes.org::search performs a search inside notes.org instead of querying to create a heading
(setq  org-startup-folded t)        ;; Start with folded view
(setq org-ellipsis "↴")

; global Effort estimate values
; global STYLE property values for completion
(setq org-global-properties (quote (("Effort_ALL" . "0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 0:00")
                                    ("STYLE_ALL" . "habit"))))

;; Disable autoindents when pressing RET on a list
(add-hook 'org-mode-hook (lambda () (electric-indent-local-mode -1)))

;; highlight words between ! ... !
;; https://dev.to/gonsie/highlighting-in-org-mode-291h
(font-lock-add-keywords 'org-mode
  '(("\\W\\(![^\n\r\t]+!\\)\\W" 1 '(face highlight) prepend)) 'append)

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

;; Explanation of syntax
;;
;; (font-lock-add-keywords MODE KEYWORDS &optional HOW)
;; KEYWORDS should be a list see the variable font-lock-keywords.
;; 1 means first subexpression
;; FACENAME can evaluate to a property list of
;; the form (face FACE PROP1 VAL1 PROP2 VAL2 ...)  in which case all
;; the listed text-properties will be set rather than just FACE

(font-lock-add-keywords 'org-mode
  '(("\\W\\(«[^»]+»\\)\\W" 1 '(face annotation-1) prepend)) 'append)

(font-lock-add-keywords 'org-mode
  '(("\\W\\(“[^”]+”\\)\\W" 1 '(face annotation-2) prepend)) 'append)

;; Add evil-surround with these new characters
(use-package! evil-surround)
(add-hook 'org-mode-hook (lambda ()
(let
    ((pairs
      '((?~ "~" . "~")
        (?* "*" . "*")
        (?/ "/" . "/")
        (?+ "+" . "+")
        (?= "=" . "=")
        (?« "« " . " »")
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


(if (not HEADLESS)
;; https://www.reddit.com/r/emacs/comments/6tewyl/hide_properties_drawer/
(defun org-cycle-hide-drawers (state)
  "Re-hide all drawers after a visibility state change."
  (when (and (derived-mode-p 'org-mode)
             (not (memq state '(overview folded contents))))
    (save-excursion
      (let* ((globalp (memq state '(contents all)))
             (beg (if globalp
                    (point-min)
                    (point)))
             (end (if globalp
                    (point-max)
                    (if (eq state 'children)
                      (save-excursion
                        (outline-next-heading)
                        (point))
                      (org-end-of-subtree t)))))
        (goto-char beg)
        (while (re-search-forward org-drawer-regexp end t)
          (save-excursion
            (beginning-of-line 1)
            (when (looking-at org-drawer-regexp)
              (let* ((start (1- (match-beginning 0)))
                     (limit
                       (save-excursion
                         (outline-next-heading)
                           (point)))
                     (msg (format
                            (concat
                              "org-cycle-hide-drawers:  "
                              "`:END:`"
                              " line missing at position %s")
                            (1+ start))))
                (if (re-search-forward "^[ \t]*:END:" limit t)
                  (outline-flag-region start (point-at-eol) t)
                  (user-error msg))))))))))
)

;;;;;;;;;;;;;; org mode id autocompletion in all org-ggenda files ;;;;;;;;;;;;;;
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

;; Fix counter sometimes not updating
;; Call first shiftleft because on headlines calling shifleft first triggers a transition to TODO and creates a :LOGBOOK:
(defun lytex/fix-counter (&rest args)
( if (eq (car (org-element-at-point-no-context)) 'item)
    (progn
        (org-shiftleft) (org-shiftright))))

(advice-add '+org/insert-item-below :after #'lytex/fix-counter)
(advice-add '+org/insert-item-above :after #'lytex/fix-counter)

;; https://emacs-china.org/t/org-mode-narrow-to-sublist/24682
(defun org-narrow-to-list ()
  (interactive)
  (save-excursion
    (narrow-to-region
	 (progn (org-beginning-of-item-list) (point))
	 (progn (org-end-of-item-list) (point)))))

(defun org-narrow-to-item ()
  "Narrow buffer to the current item.

Throw an error when not in a list."
  (interactive)
  (save-excursion
    (narrow-to-region
	 (progn (org-beginning-of-item) (point))
	 (progn (org-end-of-item) (1- (point))))))

;; Rich copy from HTML
;; from https://xiangji.me/2015/07/13/a-few-of-my-org-mode-customizations/
;; https://emacs.stackexchange.com/questions/12121/org-mode-parsing-rich-html-directly-when-pasting
(defun kdm/html2org-clipboard ()
  "Convert clipboard contents from HTML to Org and then paste (yank)."
  (interactive)
(if (eq (shell-command "[ -z \"$(timeout 0.05 xclip -loop 0 -selection clipboard -o -t image/png)\" ]") 1)
    (org-download-clipboard)
  (progn
  (kill-new (shell-command-to-string
  ;; Default to regular xclip if the clipboard doesn't contain html
    "echo $(xclip -loop 0 -selection clipboard -o -t text/html) 2>/dev/null | pandoc -f html -t json | pandoc -f json -t org --wrap=none"))
    (yank))))

;; This one is for the beginning char
(setcar org-emphasis-regexp-components " \t('\" {")
;; This one is for the ending char.
(setcar (nthcdr 1 org-emphasis-regexp-components) "- \t.,: !?;'\")}\\")

(evil-define-key 'normal org-mode-map "gp" 'kdm/html2org-clipboard)

;; Make org-bable templates jinja-like
(setq org-babel-noweb-wrap-start "{{ ")
(setq org-babel-noweb-wrap-end " }}")

(use-package! ob-docker-build
  :config
  (add-to-list 'org-babel-load-languages '(docker-build . t))
  (org-babel-do-load-languages 'org-babel-load-languages org-babel-load-languages)
)

   (setenv "NODE_PATH"
      (concat
       (getenv "HOME") "/node_modules"  ":"
       (getenv "NODE_PATH")))

  (add-to-list 'org-babel-load-languages '(js . t))

  (add-to-list 'org-babel-load-languages '(dot . t))

;; Evaluate arbitrary local variables, prompting before executing
(setq enable-local-variables t)

;; (use-package org-auto-tangle
;;   :hook (org-mode . org-auto-tangle-mode))

;; Replace all ocurrences of ";; blank" with blank space
;; There is no way to control blank space AFAIK
;; https://emacs.stackexchange.com/questions/31738/org-mode-babel-ensure-more-than-one-empty-line-between-tangled-code-blocks-fo
 (add-hook 'org-babel-post-tangle-hook
      #'(lambda () (progn
          (goto-char 0)
            (while (search-forward ";; blank" nil t)
                  (replace-match ""))
          (save-buffer))))
;; Also for languages which have another type of comment characters:
 (add-hook 'org-babel-post-tangle-hook
      #'(lambda () (progn
          (goto-char 0)
            (while (search-forward "# blank" nil t)
                  (replace-match ""))
          (save-buffer))))

 (add-hook 'org-babel-post-tangle-hook
      #'(lambda () (progn
          (goto-char 0)
            (while (search-forward "// blank" nil t)
                  (replace-match ""))
          (save-buffer))))

 (add-hook 'org-babel-post-tangle-hook
      #'(lambda () (progn
          (goto-char 0)
            (while (search-forward "% blank" nil t)
                  (replace-match ""))
          (save-buffer))))
