#!/bin/bash

prefix="$HOME"
declare -A org_links
org_links["$HOME/Documents"]="$HOME/org/roam/"
org_links["$HOME/code"]="$HOME/org/projects"

for source_dir in ${!org_links[@]}; do
    readarray -t files <<< $(find "$source_dir" -iname "*.org")
    for ((i=0; i<${#files[@]}; i++)); do
        file=${files[i]}
        pushd ${org_links[$source_dir]} >> /dev/null
            if [ ! -f "$file" ]; then
                ln -s "$file"
            fi
        popd >> /dev/null
    done
done