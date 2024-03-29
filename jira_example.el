;; (setq org-id-track-globally t)

;; (use-package ejira
;;   :init
;;   (setq jiralib2-url              "https://subdomain.atlassian.net"
;;         jiralib2-auth             'token
;;         jiralib2-user-login-name  "email@example.com"
;;         jiralib2-token            "secret_token"

;;         ejira-org-directory       "~/org/jira"
;;         ejira-projects            '("JIR" "JER")

;;         ejira-priorities-alist    '(("Highest" . ?A)
;;                                     ("High"    . ?B)
;;                                     ("Medium"  . ?C)
;;                                     ("Low"     . ?D)
;;                                     ("Lowest"  . ?E))
;;         ejira-todo-states-alist   '(("To Do"       . 1)
;;                                     ("En Pausa" . 2)
;;                                     ("Blocked" . 3)
;;                                     ("In Progress" . 4)
;;                                     ("Done"        . 6)))
;;   :config
;;   ;; Tries to auto-set custom fields by looking into /editmeta
;;   ;; of an issue and an epic.
;;   (add-hook 'jiralib2-post-login-hook #'ejira-guess-epic-sprint-fields)

;;   ;; They can also be set manually if autoconfigure is not used.
;;   ;; (setq ejira-sprint-field       'customfield_10001
;;   ;;       ejira-epic-field         'customfield_10002
;;   ;;       ejira-epic-summary-field 'customfield_10004)

;;   (require 'ejira-agenda)

;;   ;; Make the issues visisble in your agenda by adding `ejira-org-directory'
;;   ;; into your `org-agenda-files'.
;;   (add-to-list 'org-agenda-files ejira-org-directory)

;;   ;; Add an agenda view to browse the issues that
;;   (org-add-agenda-custom-command
;;    '("j" "My JIRA issues"
;;      ((ejira-jql "assignee = currentUser() AND sprint in openSprints() AND resolution = Unresolved and project = 'JIR'"
;;                  ((org-agenda-overriding-header "Assigned to me")))))))

;; (use-package org-roam
;;       :hook
;;       (after-init . org-roam-mode)
;;       :custom
;;       (org-roam-file-exclude-regexp  "home/julian/org/jira/*"))


(setq jiralib-url "https://subdomain.atlassian.net")
(setq org-jira-working-dir "~/org/jira")
(setq org-jira-default-jql "project = 'JIR'")
(setq org-jira-custom-jqls
      '((:jql "project = 'JIR'" :limit 1000 :filename "DM")
        (:jql "project = 'JIR' AND sprint in openSprints()" :limit 1000 :filename "current_sprint")
        (:jql "project = 'JIR' AND sprint in openSprints() and assignee = currentUser()" :limit 1000 :filename "assigned")
        ))

(use-package! org-jira)
(use-package! async)

(async-start
 `(lambda nil ,(async-inject-variables "auth-sources")
    (load "/home/julian/.emacs.d/early-init.el")
    (load "/home/julian/.emacs.d/init.el")
    (require 'org)
    (require 'org-jira)
    (add-to-list 'auth-sources "/home/julian/.authinfo")
    (setq org-element-use-cache nil)
    (call-interactively 'org-jira-get-issues)
    (org-save-all-org-buffers))
 (lambda
   (&rest args)
   (message "Jira issues saved")))
