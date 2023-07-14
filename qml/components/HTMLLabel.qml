/*
 Copyright (c) 2023 Peter G. (nephros)
*/
// SPDX-License-Identifier: Apache-2.0

import QtQuick 2.6
import Sailfish.Silica 1.0

Text { id: root
    // fix up hardcoded small fonts:
    property string content
    onContentChanged: {
        text = content.replace(
            "16px/20px", Theme.fontSizeSmall+'/'+Theme.fontSizeMedium
        ).replace(
            "font-size:18px", 'font-size: '+ Theme.fontSizeSmall
        ).replace(
            "font-size:20px", 'font-size: '+ Theme.fontSizeMedium
        )
    }
    baseUrl:          moniturl
    textFormat:       Text.RichText
    //font.pixelSize:   Theme.fontSizeSmall
    //minimumPixelSize: Theme.fontSizeTiny
    fontSizeMode:     Text.HorizontalFit
}

// vim: expandtab ts=4 st=4 sw=4 filetype=javascript
