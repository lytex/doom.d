(setq display-line-numbers-type 'relative)

(use-package! evil-quickscope)
;; TODO Activate only when NOT in evil-insert-state
;; Alternatively, enable only on evil-normal-state or evil-visual-state
(global-evil-quickscope-always-mode 1)

;; On large org files, the text flickers on evil-insert-state
;; Either narrow to subtree or disable quickscope to avoid it

(map! :after evil-quickscope
      :leader
      "eq" #'global-evil-quickscope-always-mode)

;; Snipe also in visual mode with z
(evil-define-key 'visual evil-snipe-local-mode-map "z" 'evil-snipe-s)
(evil-define-key 'visual evil-snipe-local-mode-map "Z" 'evil-snipe-S)
