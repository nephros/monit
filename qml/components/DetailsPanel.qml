/*

 Copyright (c) 2023 Peter G. (nephros)

*/
// SPDX-License-Identifier: Apache-2.0

import QtQuick 2.6
import Sailfish.Silica 1.0

DockedPanel { id: panel
    z: 10 // this fixes transparency and focus problems
    property string title
    property string text

    Rectangle {
        clip: true
        anchors.fill: parent
        anchors.centerIn: parent
        radius: Theme.paddingSmall
        property color backgroundColor: Theme.secondaryHighlightColor
        gradient: Gradient {
            GradientStop { position: 0; color: Theme.rgba(Theme.highlightDimmerFromColor(backgroundColor, Theme.colorScheme), Theme.opacityOverlay) }
            GradientStop { position: 2; color: Theme.rgba(Theme.overlayBackgroundColor, Theme.opacityOverlay) }
        }
    }
    Separator {
        anchors {
            verticalCenter: parent.top
            horizontalCenter: parent.horizontalCenter
            bottomMargin: Theme.paddingMedium
        }
        width: parent.width ; height: Theme.paddingSmall
        color: Theme.lightPrimaryColor;
        horizontalAlignment: Qt.AlignHCenter
    }
    SilicaFlickable {anchors.fill: parent
        anchors.top:parent.top
        width: parent.width
        contentHeight: col.height
        Column { id:col; width: parent.width
            //DialogHeader { title: dlg.title }
            HTMLLabel { content: panel.text ; width: parent.width }
        }
    }
}

// vim: expandtab ts=4 st=4 sw=4 filetype=javascript
