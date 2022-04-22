#!/usr/bin/env bash

for file in $(find . -iname "*.org"); do
    emacs --batch \
    -l "$HOME/.emacs.d/early-init.el" \
    -l "$HOME/.emacs.d/init.el" \
    --eval="(progn (find-file \"$file\") (setq org-export-babel-evaluate nil) (org-transclusion-mode t) (org-html-export-to-html))"
done
