#!/bin/sh
/usr/bin/systemctl-user stop pulseaudio.service
/usr/bin/systemctl-user start pulseaudio.service
/usr/bin/systemctl-user is-active pulseaudio.service
exit $?
