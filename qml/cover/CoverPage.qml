// Copyright (c) 2023 Peter G. (nephros)
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
    Image { id: dog
        source: "./dog.png"
        z: -1
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
        }
        sourceSize.width: parent.width
        fillMode: Image.PreserveAspectFit
        opacity: 0.6
    }
    Label {
        anchors.top: dog.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        text: app.summary ? app.summary : ""
        color: Theme.secondaryColor
        font.pixelSize: Theme.fontSizeExtraSmall
    }
    CoverActionList { id: actions
        CoverAction { iconSource: "image://theme/icon-m-sync"; onTriggered: {app.getData()} }
    }
}

// vim: ft=javascript expandtab ts=4 sw=4 st=4
