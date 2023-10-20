#!/bin/bash

# SPDX-FileCopyrightText: © 2023 Peter G. <sailfish@nephros.org>
#
# SPDX-License-Identifier: Apache-2.0

# docs:
# https://sailfishos.org/develop/docs/nemo-qml-plugin-notifications/qml-nemo-notifications-notification.html/

# to pipe:
#body=$(</dev/stdin)
#lbody=$(</dev/stdin)
#title="Alert: $body"

# parameters:
body="$2"
lbody="$2"
title="$1"
notificationtool -o add --application=Monit --icon=icon-lock-warning --hint="x-nemo-feedback general_warning" --hint="sound-name dialog-warning" --hint="x-nemo-display-on true" "$title $body" "$lbody" "$title" "$body"
