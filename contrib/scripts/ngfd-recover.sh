#!/bin/sh
/usr/bin/systemctl-user stop ngfd.service
/usr/bin/systemctl-user start ngfd.service
/usr/bin/systemctl-user is-active ngfd.service
exit $?
