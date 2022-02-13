;;; org-edna.el -*- lexical-binding: t; -*-

(use-package! org-edna)
(org-edna-mode)

(use-package! org-linker)

(use-package! org-linker-edna
  ;; follows org-super-link binding patterns
  :bind (("C-c s e" . org-linker-edna)))

(use-package! org-graph-edna)
