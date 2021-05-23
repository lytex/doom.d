#!/bin/bash

# Add the following header to all org mode files:
#+SETUPFILE: /home/julian/.doom.d/org-html-themes/org/theme-readtheorg-local.setup

# Add header to all files who do not match
find . -type f -iname "*.org" -exec sh -c 'grep -FL "#+SETUPFILE: /home/julian/.doom.d/org-html-themes/org/theme-readtheorg-local.setup" "{}"' \; | xargs -I _ sh -c 'echo "#+SETUPFILE: /home/julian/.doom.d/org-html-themes/org/theme-readtheorg-local.setup" | cat - "_" > /tmp/out && mv /tmp/out "_"'

# Add header just below #+title: ... to all files who do not match the SETUPFILE stuff
find . -type f -iname "*.org" -exec sh -c 'grep -FL "#+SETUPFILE: /home/julian/.doom.d/org-html-themes/org/theme-readtheorg-local.setup" "{}"' \; | xargs -I _ sed -i 's%\(^#+title:.*$\)%\1\n#+SETUPFILE: /home/julian/.doom.d/org-html-themes/org/theme-readtheorg-local.setup%I'  "_"

