#!/usr/bin/env bash

for file in $(find . -iname "*.org" -not -path "./doom.d/*" -not -path ".emacs.d/*"); do
    echo "Exporting file"

    echo "\033[1;34mExporting file $file...\033[0m"
    emacs --batch \
    -l "$HOME/.emacs.d/early-init.el" \
    -l "$HOME/.emacs.d/init.el" \
    --eval="(progn (find-file \"$file\") (setq org-export-babel-evaluate nil) (org-transclusion-mode t) (org-html-export-to-html))"
    echo "\033[1;32mFile $file exported.\033[0m"
done
