#!/bin/sh
ORGANISED_EXCHANGE_DESTINATION="/home/julian/org/calendar.org"

docker run \
       --rm \
       -v /home/julian/Work/calendar.ics:/calendar.ics \
       ettomatic/organised-exchange:latest \
       > $ORGANISED_EXCHANGE_DESTINATION

sed -i -e "s/#+STARTUP: overview/&\n#+FILETAGS: :work:\n#+TITLE: Outlook Calendar/" "$ORGANISED_EXCHANGE_DESTINATION"
