#!/usr/bin/env bash

html=`curl -s  http://jiofi.local.html/ | tr -d '\000'`
battery_level=`echo $html | egrep -o "[0-9]+%"`
is_discharging=`echo $html | grep -i -o "discharging"`

if [[ "$html" ]] ; then
    if [[ "$is_discharging" ]] ; then
        echo "JioFi $battery_level ▼"
    else
        echo "JioFi $battery_level ▲"
    fi
fi

