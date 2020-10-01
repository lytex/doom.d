#!/bin/bash

if pgrep emacsclient; then
    # There is an open emacsclient, open in existing frame
    emacsclient "$@"
else
    # There is no open emacsclient, create a new frame
    emacsclient -a "" -c "$@"
fi