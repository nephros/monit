#!/bin/sh
/usr/bin/systemctl --quiet --user stop ngfd.service
/usr/bin/systemctl --quiet --user start ngfd.service
/usr/bin/systemctl --quiet --user is-active ngfd.service
exit $?
