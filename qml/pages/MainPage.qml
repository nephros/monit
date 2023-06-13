/*

 Copyright (c) 2023 Peter G. (nephros)

*/
// SPDX-License-Identifier: Apache-2.0

import QtQuick 2.6
import Sailfish.Silica 1.0
import "../components"

Page { id: page

    allowedOrientations: Orientation.All
    SilicaFlickable {
        id: flick
        anchors.fill: parent
        contentHeight: col.height
        Column {
            id: col
            width: parent.width - Theme.horizontalPageMargin
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Theme.paddingLarge
            bottomPadding: Theme.itemSizeLarge
            add:      Transition { FadeAnimation { duration: 1200 } }
            move:     Transition { FadeAnimation { duration: 1200 } }
            populate: Transition { FadeAnimation { duration: 1200 } }
            PageHeader { id: head ; title: qsTr("Monit Service %1").arg(dbus.activeState) }
            SectionHeader { text: qsTr("System") }
            Grid { id: platform
                width: parent.width
                columns: 2
                rows:    3
                flow: Grid.TopToBottom
                Repeater {
                    model: platformdata ? Object.keys(platformdata) : null
                    delegate: DetailItem {
                        width: platform.width/2
                        label: modelData[0].toUpperCase() + modelData.substr(1); value: platformdata[modelData]
                    }
                }
            }

            SectionHeader { text: qsTr("Targets") }
            SilicaListView {
                height: page.height - (head.height + platform.height)
                width: parent.width
                spacing: Theme.paddingMedium
                model: servicemodel
                delegate: ListItem {
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
                      Row { id: procdetails
                            width: parent.width
                            visible: types[model.type] === "process"
                            DetailItem { width: parent.width/5; forceValueBelow: true; label: "Up"; value: procup }
                            DetailItem { width: parent.width/5; forceValueBelow: true; label: "CPU"; value: proccpu+'%' }
                            DetailItem { width: parent.width/5; forceValueBelow: true; label: "Mem"; value: procmem+'%' }
                            DetailItem { width: parent.width/5; forceValueBelow: true; label: "Read"; value: Math.floor(procread/1024)+'kB' }
                            DetailItem { width: parent.width/5; forceValueBelow: true; label: "Write"; value: Math.floor(procwrite/1024)+'kB' }
                       }
                      Row { id: progdetails
                            width: parent.width
                            visible: types[model.type] === "program"
                            DetailItem { width: parent.width/3; forceValueBelow: true; label: "Output"; value: progout }
                            DetailItem { width: parent.width/3; forceValueBelow: true; label: "Last"; value: Date(proglast).toLocaleString(Locale.ShortFormat) }
                            DetailItem { width: parent.width/3; forceValueBelow: true; label: "Exit"; value: progstatus }
                       }
                      Row { id: netdetails
                            width: parent.width
                            visible: types[model.type] === "net"
                            DetailItem { width: parent.width/2; forceValueBelow: true; label: "Up"; value: Math.floor(netup/1024)+"kB" }
                            DetailItem { width: parent.width/2; forceValueBelow: true; label: "Down"; value: Math.floor(netdown/1024)+"kB" }
                       }
                    }
                }
            }
        }
        ViewPlaceholder {
            enabled: (dbus.activeState !== "active")
            text: qsTr("Monit is inactive.")
            hintText: qsTr("Pull down to go to Settings")
        }
        PullDownMenu { id: pdp
            MenuItem { text: qsTr("About"); onClicked: { pageStack.push(Qt.resolvedUrl("AboutPage.qml")) } }
            MenuItem { text: qsTr("Settings"); onClicked: { pageStack.push(Qt.resolvedUrl("SettingsPage.qml")) } }
            MenuItem { text: qsTr("Open Browser"); onClicked: { Qt.openUrlExternally(moniturl) } }
            MenuItem { text: qsTr("Refresh"); onClicked: { servicemodel.reload() } }
        }
        VerticalScrollDecorator {}
    }
}

// vim: expandtab ts=4 st=4 sw=4 filetype=javascript
