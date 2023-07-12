#!/bin/sh
ret=$(journalctl --dmesg --since "300 sec ago" --no-tail --no-pager | grep -c oom_reaper)
exit $ret
