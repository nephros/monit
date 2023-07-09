/*
 Copyright (c) 2023 Peter G. (nephros)
*/
// SPDX-License-Identifier: Apache-2.0

import QtQuick 2.6
import Sailfish.Silica 1.0

ListItem {

    width: ListView.view.width
    contentHeight: content.height

    states: [
        State { name: "process"
            PropertyChanges { target: details; sourceComponent: procdetails}
        },
        State { name: "program"
            PropertyChanges { target: details; sourceComponent: progdetails}
        },
        State { name: "net"
            PropertyChanges { target: details; sourceComponent: netdetails}
            PropertyChanges { target: statesw; checked: (netlink === 1)}
        }
    ]
    state: types[model.type]
    //onStateChanged: console.debug("State changed to", state, "for", name, "of type", model.type + " (" + types[model.type] + ")")

    Switch { id: monsw
        checked: (monitormodes[monitor] === 'monitored')
        palette.primaryColor: Theme.highlightColor
        automaticCheck: false
    }
    Column { id: content
        width: parent.width - monsw.width
        anchors.left: monsw.right
        TextSwitch { id: statesw
            automaticCheck: false
            //checked: (statuses[monitor] === 'ok')
            checked: monsw.checked
            busy:    (statuses[monitor] === 'initializing')
            //palette.primaryColor :{
            //    checked ? Theme.highlightColor : "red"
            //}
            palette.backgroundGlowColor :{
                checked ? "darkgreen" : "red"
            }
            text: name
            description: types[model.type] + ', ' + monitormodes[monitor]
        }
        //Label { text: name ;              color: Theme.highlightColor}
        //Label { text: types[model.type] ; color: Theme.secondaryColor; font.pixelSize: Theme.fontSizeSmall}
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
