/*
 Copyright (c) 2023 Peter G. (nephros)
*/
// SPDX-License-Identifier: Apache-2.0

import QtQuick 2.6
import Sailfish.Silica 1.0

Text { id: root
    baseUrl:          moniturl
    textFormat:       Text.RichText
    font.pixelSize:   Theme.fontSizeSmall
    minimumPixelSize: Theme.fontSizeTiny
    fontSizeMode:     Text.HorizontalFit
    //scale: 2
}

// vim: expandtab ts=4 st=4 sw=4 filetype=javascript
