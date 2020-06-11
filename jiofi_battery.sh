#!/usr/bin/env sh

icon=""
rawhtml=`curl -s  'http://jiofi.local.html/'`
[ $? -gt 0 ] && echo "{\"text\": \" $icon\"}" && exit 1 # exit if curl failed

html=`echo $rawhtml | tr -d '\000'`
battery_level=`echo $html | grep -oE "[0-9]+%" | rev | cut -c 2- | rev`

symbol="▲"
[ $(echo $html | grep -i -o "discharging") ] && symbol="▼"

state="Idle"
[ "$battery_level" -le "20"  ] && state="Warning"
[ "$battery_level" -le "10"  ] && state="Critical"

echo "{\"text\": \" $icon $battery_level%$symbol\", \"state\":\"$state\"}"
