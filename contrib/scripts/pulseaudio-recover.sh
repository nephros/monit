#!/bin/sh
/usr/bin/systemctl --quiet --user stop pulseaudio.service
/usr/bin/systemctl --quiet --user start pulseaudio.service
/usr/bin/systemctl --quiet --user is-active pulseaudio.service
exit $?
