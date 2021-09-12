#!/bin/bash

# Remove extra newlines caused by orgzly when using the option:
# Sync>Org file format>Separate header and content

find . -iname "*.org" -type f -print0  | xargs -0 sed -zEi 's/:END:\n\n/:END:\n/'