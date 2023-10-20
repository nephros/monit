#!/bin/sh

# SPDX-FileCopyrightText: © 2023 Peter G. <sailfish@nephros.org>
#
# SPDX-License-Identifier: Apache-2.0

SYSFSFILE=/sys/class/power_supply/battery/temp
if [ -e  $SYSFSFILE ]; then
  cat /sys/class/power_supply/battery/temp
fi
echo 0
