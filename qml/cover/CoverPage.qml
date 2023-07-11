/*

 Copyright (c) 2023 Peter G. (nephros)

*/

// SPDX-License-Identifier: Apache-2.0

import QtQuick 2.6
import Sailfish.Silica 1.0

CoverBackground {
    id: coverPage


    Image {
        source: "./gears.png"
        z: -1
        anchors.fill: parent
        sourceSize.height: parent.height
        fillMode: Image.PreserveAspectCrop
        opacity: 0.3
    }
    CoverPlaceholder {
        text: Qt.application.name
        textColor: Theme.highlightColor
        //icon.source: "image://theme/harbour-monit"

        Image {
            source: "./dog.png"
            z: -1
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: actions.top
            }
            sourceSize.width: parent.width
            fillMode: Image.PreserveAspectFit
            opacity: 0.6
        }

        CoverActionList { id: actions
            CoverAction { iconSource: "image://theme/icon-m-sync";            onTriggered: {app.getData()} }
        }

    }
}

// vim: ft=javascript expandtab ts=4 sw=4 st=4
