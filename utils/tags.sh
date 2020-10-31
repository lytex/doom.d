#!/bin/bash

# Rename tags
old_tag="myoldtag"; new_tag="mynewtag"; sed -Ei "s/:$old_tag:/:$new_tag:/g" $(grep -rl ":$old_tag:" * --exclude-dir=Documents --exclude-dir=code --binary-files=without-match)

# get all tags (filtering out properties)
grep -hEor  " (:[0-9a-Z_-]+)+"  --exclude-dir=Documents --exclude-dir=code --exclude-dir=jira | grep -v "Binary file"  | sed "s/:/\n/g" | sort | uniq | grep -Ev "[A-Z]+"