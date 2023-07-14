/*
 Copyright (c) 2023 Peter G. (nephros)
*/
// SPDX-License-Identifier: Apache-2.0

import QtQuick 2.6
import Sailfish.Silica 1.0

ContextMenu { id: root
    property bool monitoring: false
    property bool running: false
    property bool canControl: ((types[type] === "process") || (types[type] === "program"))
    MenuItem { text: qsTr("Open Details"); onClicked: { Qt.openUrlExternally(moniturl + '/' + name) } }
    MenuItem {
        text: qsTr("%1 Monitoring").arg(!!monitored ? qsTr("Stop") : qsTr("Start"))
        onClicked: toggleMonitor()
    }
    MenuItem {
        visible: canControl
        text: qsTr("%1 Service").arg(!!root.running ? qsTr("Stop") : qsTr("Start"))
        onClicked: toggleService()
    }
    MenuItem {
        visible: canControl
        text: qsTr("Restart Service")
        enabled: !!root.running
        onClicked: restartService()
    }
}

// vim: expandtab ts=4 st=4 sw=4 filetype=javascript
