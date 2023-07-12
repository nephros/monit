#!/bin/sh
SYSFSFILE=/sys/class/power_supply/battery/temp
if [ -e  $SYSFSFILE ]; then
  cat /sys/class/power_supply/battery/temp
fi
echo 0
