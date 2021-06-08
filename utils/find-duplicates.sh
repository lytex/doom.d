#!/bin/bash

# Find duplicates in id
# rg ":ID:" projects/emacs.org | sort | uniq -c | grep "[2-9][0-9]* :ID:" 
rg ":ID:" File.org archive/File_Archive.org | sort | uniq -c | grep "^[ ]*[2-9][0-9]*"