#!/bin/sh
/usr/bin/systemctl --user is-active --quiet pulseaudio.service
exit $?
