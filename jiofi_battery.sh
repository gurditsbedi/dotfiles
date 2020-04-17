#!/usr/bin/env sh

rawhtml=`curl -s  'http://jiofi.local.html/'`
[ $? -gt 0 ] && echo "" && exit 1 # exit if curl failed

html=`echo $rawhtml | tr -d '\000'`
battery_level=`echo $html | grep -oE "[0-9]+%" | rev | cut -c 2- | rev`

_=$(echo $html | grep -i -o "discharging")
[ $? = 0 ] && echo "JioFi $battery_level% ▼" || echo "JioFi $battery_level% ▲"
