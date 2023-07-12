#!/bin/sh
/usr/bin/systemctl-user is-active --quiet ngfd.service
exit $?
