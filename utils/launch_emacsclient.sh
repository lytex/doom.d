#!/bin/bash

false; while (($? != 0)); do killall emacs; emacs --daemon; done