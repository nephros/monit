#!/bin/bash

# SPDX-FileCopyrightText: © 2023 Peter G. <sailfish@nephros.org>
#
# SPDX-License-Identifier: Apache-2.0

# this sends messages using a telegram bot.
# you will need curl installed.
# message the BotFather at Telegram to learn how to create a bot.

TOOL=/usr/bin/curl
OPTS='--silent'
# replace with your telegram token
TOKEN=1234567890:aaaaaaaa-bbbbbbbbbbbbbb-ccccccccccc
# replace with your chat/group id
CHAT_ID=012345678
URL="https://api.telegram.org/bot$TOKEN/sendMessage"

# to pipe messages:
#MESSAGE=$(</dev/stdin)
# as parameter:
MESSAGE="$1"

$TOOL $OPTS -X POST $URL -d chat_id=$CHAT_ID -d disable_web_page_preview=true -d text="$MESSAGE"
