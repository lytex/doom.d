#!/bin/bash

# Where to link (target) from and destination of that link (name)
declare -A org_links
org_links["$HOME/Documents"]="$HOME/org/roam/"
org_links["$HOME/code"]="$HOME/org/projects"

# Whether to include basedir as part of the link
declare -A include_basedir
include_basedir["$HOME/Documents"]=false
include_basedir["$HOME/code"]=true

for source_dir in ${!org_links[@]}; do
    readarray -t files <<< $(find "$source_dir" -iname "*.org")
    for ((i=0; i<${#files[@]}; i++)); do
        file=${files[i]}
        filename="${file%"."*}"
        dirname=`basename ${file%"/"*}`
        link_directory=${org_links[$source_dir]}

        pushd $link_directory >> /dev/null
            if [ "${include_basedir[$source_dir]}" = true ]; then
                link_directory="$dirname/$link_directory"
                mkdir "$dirname"
                cd $dirname
            fi
            ln "$file"  # It has to be a hard link
            # If do a soft link Documents -> org, then org-noter doesn't work
            # because it cannot open the .org file associated with the .pdf  properly
            # If do a soft link org -> Documents, then org-roam doesn't work
            # because it cannot create a new roam file if you write a non-existing link
            # Also set find-file-existing-other-name, find-file-visit-truename to nil
            ln "$filename.pdf"  # Hard link to the pdf also so that org-noter can open it
        popd >> /dev/null
    done
done