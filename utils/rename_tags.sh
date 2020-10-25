#!/bin/bash

old_tag="myoldtag"; new_tag="mynewtag"; sed -Ei "s/:$old_tag:/:$new_tag:/g" $(grep -rl ":$old_tag:" * --exclude-dir=Documents --exclude-dir=code --binary-files=without-match)