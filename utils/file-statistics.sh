#!/bin/bash

# Number of total org files
find . -iname "*.org" | wc -l

# Create a csv file with information about each file
now="`date +'%Y-%m-%d %H:%M:%S'`"
echo "lines,words,bytes,path" > "statistics $now.csv"
find . -iname "*.org" -exec bash -c 'wc "{}"' \; | \
sed -E 's/[ ]*([0-9]+)[ ]+([0-9]+)[ ]+([0-9]+)[ ]+/\1,\2,\3,/g' >> "statistics $now.csv"

# Create a csv file with information about each file (sorted desc by lines)
now="`date +'%Y-%m-%d %H:%M:%S'`"
echo "lines,words,bytes,path" > "statistics $now.csv"
find . -iname "*.org" -exec bash -c 'wc "{}"' \; | \
sed -E 's/[ ]*([0-9]+)[ ]+([0-9]+)[ ]+([0-9]+)[ ]+/\1,\2,\3,/g' | sort -nr >> "statistics $now.csv"

# Count how many links of each website you have
rg --no-filename -o "https?://[^/]+" | sed -E "s#https?://[^/]+\zs.*##" | sort | uniq -c | sort -nr | less