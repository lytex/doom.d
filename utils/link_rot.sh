#!/bin/bash
# Creates a "|" separated file of file, link and http status
now="$(date +'%Y-%m-%d %H:%M:%S')"
echo "file|link|status" > "link_rot $now.csv"
rg -H "https?://" \
    | sed -E 's%(.+\.org)\:.+?(https?://[^] ]+).+?%\1|\2%g' \
    | parallel --colsep '\|' curl -o /dev/null -s -w '{1}\|{2}\|%{http_code}\\n' '{2}' \
    | tee -a  "link_rot $now.csv"
