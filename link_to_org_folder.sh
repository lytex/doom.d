#!/bin/bash

declare -A org_links
org_links["$HOME/Documents"]="$HOME/org/roam/"
org_links["$HOME/code"]="$HOME/org/projects"

for source_dir in ${!org_links[@]}; do
    readarray -t files <<< $(find "$source_dir" -iname "*.org")
    for ((i=0; i<${#files[@]}; i++)); do
        file=${files[i]}
        pushd ${org_links[$source_dir]} >> /dev/null
            ln "$file"  # It has to be a hard link
            # If do a soft link Documents -> org, then org-noter doesn't work
            # because it cannot open the .org file associated with the .pdf  properly
            # If do a soft link org -> Documents, then org-roam doesn't work
            # because it cannot create a new roam file if you write a non-existing link
            # Also set find-file-existing-other-name, find-file-visit-truename to nil
        popd >> /dev/null
    done
done