/*
 Copyright (c) 2023 Peter G. (nephros)
*/
// SPDX-License-Identifier: Apache-2.0

import QtQuick 2.6
import Sailfish.Silica 1.0

Text { id: root
    property string content
    // fix up CSS to match Silica style:
    onContentChanged: {
        var newtext = content.replace(
            '16px/20px', Theme.fontSizeSmall+'px/'+Theme.fontSizeMedium+'px'
        ).replace(
            '14px/0px', Theme.fontSizeSmall+'px/0px'
        ).replace(
            'font-size:18px', 'font-size: '+ Theme.fontSizeSmall + 'px'
        ).replace(
            'font-size:20px', 'font-size: '+ Theme.fontSizeMedium + 'px'
        ).replace(
            'body {background-color: white', 'body {background-color: ' +  Theme.rgba(Theme.highlightDimmerFromColor(Theme.highlightBackgroundColor, Theme.colorScheme), Theme.opacityOverlay)
        ).replace(
            'max-width: 350px',  'max-width: '+ parent.width + 'px'
        ).replace(
            /#222/gim, '' +  Theme.primaryColor
        ).replace(
            /#333|#555|#ccc/gim, '' +  Theme.secondaryColor
        ).replace(
            /#999999/gim, '' + Theme.highlightBackgroundColor
        ).replace(
            /#EFF7FF/gim, '' + Theme.secondaryHighlightColor
        ).replace(
            /#edf5ff/gim, '' + Theme.rgba(Theme.highlightDimmerFromColor(Theme.highlightBackgroundColor, Theme.colorScheme), Theme.opacityOverlay)
        ).replace(
            /#ddd/gim, '' + Theme.highlightDimmerFromColor(Theme.secondaryHightlightColor, Theme.colorScheme)
        )
        text = newtext;
        //console.debug("mangled:", newtext);
    }
    baseUrl:          moniturl
    linkColor:        Theme.darkSecondaryColor
    textFormat:       Text.RichText
    //font.pixelSize:   Theme.fontSizeSmall
    //minimumPixelSize: Theme.fontSizeTiny
    fontSizeMode:     Text.HorizontalFit
}

// vim: expandtab ts=4 st=4 sw=4 filetype=javascript
