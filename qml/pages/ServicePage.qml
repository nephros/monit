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
            PageHeader { id: head ; title: qsTr("Monit Service Manager %1").arg(dbus.activeState) }
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
                delegate: MonitorDelegate{}
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
