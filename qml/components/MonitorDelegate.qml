/*
 Copyright (c) 2023 Peter G. (nephros)
*/
// SPDX-License-Identifier: Apache-2.0

import QtQuick 2.6
import Sailfish.Silica 1.0

ListItem {
    states: [
        State { name: "proc" },
        State { name: "prog" },
        State { name: "net" }
    ]
    width: ListView.view.width
    contentHeight: content.height
    Switch { id: sw
        checked: (statuses[monitor] === 'ok')
        busy:    (statuses[monitor] === 'initializing')
    }
    Column { id: content
        width: parent.width - sw.width
        anchors.left: sw.right
        anchors.top: sw.top
        Label { text: name ;              color: Theme.highlightColor}
        Label { text: types[model.type] ; color: Theme.secondaryColor; font.pixelSize: Theme.fontSizeSmall}
        Loader { id: details; width: parent.width }
        Component { id: procdetails; Row {
            DetailItem { width: parent.width/5; forceValueBelow: true; label: "Up"; value: procup }
            DetailItem { width: parent.width/5; forceValueBelow: true; label: "CPU"; value: proccpu+'%' }
            DetailItem { width: parent.width/5; forceValueBelow: true; label: "Mem"; value: procmem+'%' }
            DetailItem { width: parent.width/5; forceValueBelow: true; label: "Read"; value: Math.floor(procread/1024)+'kB' }
            DetailItem { width: parent.width/5; forceValueBelow: true; label: "Write"; value: Math.floor(procwrite/1024)+'kB' }
        }}
        Component { id: progdetails; Row {
            DetailItem { width: parent.width/3; forceValueBelow: true; label: "Output"; value: progout }
            DetailItem { width: parent.width/3; forceValueBelow: true; label: "Last"; value: Date(proglast).toLocaleString(Locale.ShortFormat) }
            DetailItem { width: parent.width/3; forceValueBelow: true; label: "Exit"; value: progstatus }
        }}
        Component { id: netdetails; Row {
            DetailItem { width: parent.width/2; forceValueBelow: true; label: "Link"; value: netlink }
            DetailItem { width: parent.width/2; forceValueBelow: true; label: "Up"; value: Math.floor(netup/1024)+"kB" }
            DetailItem { width: parent.width/2; forceValueBelow: true; label: "Down"; value: Math.floor(netdown/1024)+"kB" }
        }}
    }
}


// vim: expandtab ts=4 st=4 sw=4 filetype=javascript
