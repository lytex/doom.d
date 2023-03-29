#!/bin/sh
ORGANISED_EXCHANGE_DESTINATION="/home/julian/org/work_journal/calendar.org"

docker run \
       --rm \
       -v /home/julian/Work/calendar.ics:/calendar.ics \
       ettomatic/organised-exchange:latest \
       > $ORGANISED_EXCHANGE_DESTINATION

sed -i -e "s/#+STARTUP: overview/:PROPERTIES:\n:ID:       4e3bf895-68bb-4a93-a592-c6329581b6f0\n:ROAM_INCLUDE: t\n:END:\n&\n#+FILETAGS: :work:\n#+TITLE: Outlook Calendar/" "$ORGANISED_EXCHANGE_DESTINATION"
