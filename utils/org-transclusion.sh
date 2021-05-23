#!/bin/bash

find . -type f -iname "*.org" -exec sh -c 'grep -iFl "#+transclude" "{}"' \; | xargs -I _ sed -i -z 's/\(#+transclude: t\)[ ]\+\(:hlevel[ ]\+\([0-9]\)\)\?\n\([^\n]\+\)/\1 \4 :level \3/gi' "_"

