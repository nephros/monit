/*
 Copyright (c) 2023 Peter G. (nephros)
*/
// SPDX-License-Identifier: Apache-2.0

import QtQuick 2.6
import Sailfish.Silica 1.0

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
        }
    ]
    state: types[model.type]
    //onStateChanged: console.debug("State changed to", state, "for", name, "of type", model.type + " (" + types[model.type] + ")")

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
            columns: 3
            property int cell: width /  columns
            MonitorLabel {text: procup }
            MonitorLabel {text: proccpu+'%' }
            MonitorLabel {text: procmem+'%' }
            MonitorLabel {text: "" }
            MonitorLabel {text: Math.floor(procread/1024)+'kB' }
            MonitorLabel {text: Math.floor(procwrite/1024)+'kB' }

        }}
        Component { id: progdetails; Grid {
            columns: 2
            property int cell: width /  columns
            MonitorLabel { text: progout }
            MonitorLabel { text: Date(proglast).toLocaleString(Locale.ShortFormat) }
            MonitorLabel { text: "" }
            MonitorLabel { text: progstatus }
        }}
        Component { id: netdetails; Grid {
            columns: 2
            property int cell: width /  columns
            MonitorLabel { text: netlink }
            MonitorLabel { text: "" }
            MonitorLabel { text: Math.floor(netup/1024)+"kB" }
            MonitorLabel { text: Math.floor(netdown/1024)+"kB" }
        }}
        Component { id: hostdetails; Grid {
            columns: 2
            property int cell: width /  columns
            MonitorLabel { width: cell; text: hostname+":"+hostport}
            MonitorLabel { width: cell; text: hostreq}
            MonitorLabel { width: cell; text: hostproto}
            MonitorLabel { width: cell; text: hostnetproto}
        }}
}


// vim: expandtab ts=4 st=4 sw=4 filetype=javascript
