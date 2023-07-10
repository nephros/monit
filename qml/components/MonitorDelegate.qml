/*
 Copyright (c) 2023 Peter G. (nephros)
*/
// SPDX-License-Identifier: Apache-2.0

import QtQuick 2.6
import Sailfish.Silica 1.0
//import "../js/unix.js" as Unix

ListItem { id: root

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
            PropertyChanges { target: stateindicator; checked: (netlink === 1)}
        },
        State { name: "host"
            PropertyChanges { target: details; sourceComponent: hostdetails}
        },
        State { name: "filesystem"
            PropertyChanges { target: details; sourceComponent: fsdetails}
        }
    ]
    state: types[model.type]
    //onStateChanged: console.debug("State changed to", state, "for", name, "of type", model.type + " (" + types[model.type] + ")")

    menu: MonitorMenu {
        monitoring: (monitormodes[monitor] === 'monitored')
        running:  (monitormodes[monitor] === 'monitored')
    }
    // Odd/even marking:
    property color oddColor: "transparent"
    property color evenColor: Theme.highlightBackgroundColor
    property bool isOdd: (index %2 != 0)
    Rectangle { id: oddevenrect
        anchors.fill: parent
        //visible: showOddEven
        radius: Theme.paddingSmall
        opacity: Theme.opacityFaint
        color: isOdd ? oddColor : evenColor
        border.color: "transparent"
        border.width: radius/2
    }

    Row { id: indicators
        //anchors.top: parent.top
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        rightPadding: Theme.paddingSmall
        Indicator { id: monindicator
            width: Theme.iconSizeSmall
            height: width
            checked: (monitormodes[monitor] === 'monitored')
            palette.primaryColor: Theme.highlightColor
        }
        Indicator { id: stateindicator
            width: Theme.iconSizeSmall
            height: width
            //checked: (statuses[monitor] === 'ok')
            checked: monindicator.checked
            busy:    (statuses[monitor] === 'initializing')
            palette.backgroundGlowColor :{
                checked ? "darkgreen" : "red"
            }
        }
        Label {
            // important: fixed width to make the labels blow appear aligned:
            width: Theme.itemSizeExtraLarge
            truncationMode: TruncationMode.Fade
            text: name
            font.pixelSize: Theme.fontSizeSmall
        }
    }
    Row { id: content
        anchors.top: parent.top
        anchors.left: indicators.right
        width: parent.width - (indicators.width)
        height: details.height
        Loader { id: details; width: parent.width}
    }
    Component { id: procdetails; Grid {
        columns: isLandscape ? 5 : 3
        property int cell: width /  columns
        MonitorLabel {text: Format.formatDuration(procup, Formatter.DurationElapsed) }
        MonitorLabel {text: 'cpu %1%'.arg(proccpu) }
        MonitorLabel {text: 'mem %1%'.arg(procmem) }
        //MonitorLabel {text: Format.formatFileSize(Math.floor(read_total)) }
        //MonitorLabel {text: Format.formatFileSize(Math.floor(write_total)) }
        MonitorLabel {text: 'r/w: ' + Format.formatFileSize(Math.floor(read_total)) +'/'+ Format.formatFileSize(Math.floor(write_total)) }

    }}
    Component { id: progdetails; Grid {
        columns: isLandscape ? 5 : 2
        property int cell: width /  columns
        MonitorLabel { text: progout }
        MonitorLabel { text: qsTr("checked %1").arg(Format.formatDate( new Date(proglast*1000), Formatter.DurationElapsedShort)) }
        MonitorLabel { text: "" }
        MonitorLabel { text: progstatus }
    }}
    Component { id: netdetails; Grid {
        columns: isLandscape ? 5 : 2
        property int cell: width /  columns
        MonitorLabel { text: (netlink === 1) ? qsTr("Up") : qsTr("Down") }
        MonitorLabel { text: "" }
        MonitorLabel { text: Math.floor(netup/1024)+"kB" }
        MonitorLabel { text: Math.floor(netdown/1024)+"kB" }
    }}
    Component { id: hostdetails; Grid {
        columns: isLandscape ? 5 : 2
        property int cell: width /  columns
        //MonitorLabel { text: hostname + (hostport ? ":" + hostport : '') }
        //MonitorLabel { text: hostreq}
        //MonitorLabel { text: hostproto}
        //MonitorLabel { text: hostnetproto}
        MonitorLabel { text: hostreq}
        MonitorLabel { text: hostname }
        MonitorLabel { text: hostnetproto + "/" + hostproto + " port " + hostport }
    }}
    Component { id: fsdetails; Grid {
        columns: isLandscape ? 5 : 4
        /*
        function group(id) { return user(id) }
        function user(id) {
            if (id === 0) return "root";
            if (id === 1000000) return "nemo";
            return "ID" + id
        }
        */
        property int cell: width /  columns
        MonitorLabel { text: fstype}
        //MonitorLabel { text: fsflags}
        //MonitorLabel { text: fsmode + '/' + fsuid + '/' + fsgid }
        //MonitorLabel { text: !!fsmode ? Unix.octal2string(fsmode, "d") : "-" }
        //MonitorLabel { text: user(fsuid) + '/' + group(fsgid) }
        //MonitorLabel { text: Unix.octal2string(fsmode, "d") + " " + user(fsuid) + '/' + group(fsgid) }
        //MonitorLabel { text: 'kB: %1/%2 (%3%)'.arg(fs_bl_usage).arg(fs_bl_total).arg(fs_bl_percent) }
        //MonitorLabel { text: ' i: %1/%2 (%3%)'.arg(fs_in_usage).arg(fs_in_total).arg(fs_in_percent) }
        MonitorLabel { text: 'used: %1% (%2)'.arg(fs_bl_percent).arg(Format.formatFileSize(Math.floor(fs_bl_usage*1024*1024))) }
        MonitorLabel { text: 'inodes: %1%'.arg(fs_in_percent) }
        //MonitorLabel { text: Math.floor(read_total/1024)+'kB' }
        //MonitorLabel { text: Math.floor(write_total/1024)+'kB' }
        MonitorLabel { text: 'r/w: '+ Math.floor(read_now/1024) +'/'+ Math.floor(write_now/1024)+'kB' }
    }}
}


// vim: expandtab ts=4 st=4 sw=4 filetype=javascript
