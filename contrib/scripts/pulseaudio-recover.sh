#!/bin/sh

# SPDX-FileCopyrightText: © 2023 Peter G. <sailfish@nephros.org>
#
# SPDX-License-Identifier: Apache-2.0

/usr/bin/systemctl-user stop pulseaudio.service
/usr/bin/systemctl-user start pulseaudio.service
/usr/bin/systemctl-user is-active pulseaudio.service
exit $?
