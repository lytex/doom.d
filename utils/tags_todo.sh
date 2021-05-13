#!/bin/bash

find . -iname "*.org" -type f -print0  | xargs -0 sed -Ei 's#\*+ ([^:]+) :idea:#IDEA \1#'

find . -iname "*.org" -type f -print0  | xargs -0 sed -Ei 's#\*+ ([^:]+) :maybe:#MAYBE \1#'

find . -iname "*.org" -type f -print0  | xargs -0 sed -Ei 's#\*+ ([^:]+) :someday:#SOMEDAY \1#'