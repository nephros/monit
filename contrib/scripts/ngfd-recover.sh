#!/bin/sh

# SPDX-FileCopyrightText: © 2023 Peter G. <sailfish@nephros.org>
#
# SPDX-License-Identifier: Apache-2.0

/usr/bin/systemctl-user stop ngfd.service
/usr/bin/systemctl-user start ngfd.service
/usr/bin/systemctl-user is-active ngfd.service
exit $?
