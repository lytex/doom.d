#!/bin/bash

# Find duplicates in one file
rg ":ID:" projects/emacs.org | sort | uniq -c | grep "[2-9][0-9]* :ID:" 
# Find duplicates in two files
rg ":ID:" File.org archive/File_Archive.org | sort | uniq -c | grep "^[ ]*[2-9][0-9]*"
# Find duplicates in any files
cat ~/1.txt | xargs -I _ rg -I "_" | sort | uniq -c | grep -E "[ ]*[2-9][0-9]* :ID:"  