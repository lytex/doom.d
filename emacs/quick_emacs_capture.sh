#!/bin/bash

if pgrep emacsclient; then
    # There is an open emacsclient
    emacsclient "$@"
elif pgrep emacs; then
    # There is no open emacsclient but emacs daemon is running
    emacsclient -c "$@"
else
    # Start emacs daemon and client
    emacsclient -a '' -c "$@"
fi