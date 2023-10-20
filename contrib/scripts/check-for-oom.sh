#!/bin/sh

# SPDX-FileCopyrightText: © 2023 Peter G. <sailfish@nephros.org>
#
# SPDX-License-Identifier: Apache-2.0

ret=$(journalctl --dmesg --since "300 sec ago" --no-tail --no-pager | grep -c oom_reaper)
exit $ret
