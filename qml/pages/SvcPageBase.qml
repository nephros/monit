/*

 Copyright (c) 2023 Peter G. (nephros)

*/
// SPDX-License-Identifier: Apache-2.0

import QtQuick 2.6
import QtQuick.XmlListModel 2.0
import Sailfish.Silica 1.0
import "../components"

Page { id: page

    allowedOrientations: Orientation.All
    // populate the stack:
    onStatusChanged: {
        if ( status === PageStatus.Active && pageStack.nextPage() === null ) {
            var next = pages.pop()
            if (!!next) pageStack.pushAttached(Qt.resolvedUrl("SvcPageBase.qml"), next)
        }
    }
    property string title: qsTr("Monit Service Manager %1").arg(dbus.activeState)
    property string subtitle: ""
    property string footer:  qsTr("Last updated: %1, next update: %2").arg(
        Format.formatDate(refreshed,Formatter.DurationElapsed)).arg(
        Format.formatDate(new Date(Date.now()+polling*1000),Formatter.TimepointRelative)
        )
    property XmlListModel model
    property Component delegate: MonitorDelegate{}

    //Component.onCompleted: console.debug("Loaded page", objectName)

    SilicaFlickable {
        id: flick
        anchors.fill: parent
        contentHeight: col.height
        Column {
            id: col
            width: parent.width - Theme.horizontalPageMargin
            anchors.horizontalCenter: parent.horizontalCenter
            //spacing: Theme.paddingLarge
            spacing: Theme.paddingSmall
            bottomPadding: Theme.itemSizeLarge
            add:      Transition { FadeAnimation { duration: 1200 } }
            move:     Transition { FadeAnimation { duration: 1200 } }
            populate: Transition { FadeAnimation { duration: 1200 } }
            PageHeader { id: head ; title: page.title; description: subtitle }
            SectionHeader { text: qsTr("Monit Daemon"); visible: monit.visible}
            Grid { id: monit
                visible: (!!!page.objectName) // the "first" page has no object name
                width: parent.width
                columns: isLandscape ? 3 : 2
                flow: Grid.TopToBottom
                Repeater {
                    model: monitdata ? Object.keys(monitdata) : null
                    delegate: DetailItem {
                        width: monit.width/monit.columns
                        label: modelData[0].toUpperCase() + modelData.substr(1)
                        value: {
                           if (modelData == "uptime") {
                                return Format.formatDuration(monitdata[modelData], Formatter.TimePoint)
                           } else if  ((modelData == "poll") || (modelData == "delay")) {
                                return monitdata[modelData]+'s'
                           }
                           return monitdata[modelData]
                        }
                    }
                }
            }
            SectionHeader { text: qsTr("Platform"); visible: platform.visible}
            Grid { id: platform
                visible: (!!!page.objectName) // the "first" page has no object name
                width: parent.width
                columns: isLandscape ? 3 : 2
                flow: Grid.TopToBottom
                Repeater {
                    model: platformdata ? Object.keys(platformdata) : null
                    delegate: DetailItem {
                        width: platform.width/platform.columns
                        label: modelData[0].toUpperCase() + modelData.substr(1)
                        value: {
                            if  ((modelData == "memory") || (modelData == "swap")) {
                                return Math.floor(platformdata[modelData]/1024)+'MB'
                            }
                            return platformdata[modelData]
                        }
                    }
                }
            }

            SectionHeader { text: qsTr("System"); visible: system.visible}
            Grid { id: system
                visible: (!!!page.objectName) // the "first" page has no object name
                width: parent.width
                columns: isLandscape ? 3 : 2
                flow: Grid.TopToBottom
                Repeater {
                    model: systemdata ? Object.keys(systemdata) : null
                    delegate: DetailItem {
                        width: system.width/system.columns
                        label: modelData[0].toUpperCase() + modelData.substr(1)
                        value: {
                            if  ((modelData == "memory") || (modelData == "swap")) {
                                return Math.floor(systemdata[modelData]/1024)+'MB'
                            }
                            if  (/^CPU/.test(modelData) || /^load/.test(modelData) ||  /%$/.test(modelData)) {
                                return systemdata[modelData].toFixed(2)
                            }
                            return systemdata[modelData]
                        }
                    }
                }
            }
            SilicaListView { id: svcview
                visible: (!!page.objectName) // the "first" page has no object name
                height: page.height - (head.height + platform.height)
                //width: isLandscape ? parent.width : parent.width*2
                width:  parent.width
                spacing: Theme.paddingMedium
                model: page.model
                delegate: page.delegate
            }
            Label {
                text: footer
                font.pixelSize: Theme.fontSizeTiny
                color: Theme.secondaryColor
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
            //MenuItem { text: qsTr("Refresh"); onClicked: { servicemodel.reload()} }
            MenuItem { text: qsTr("Refresh"); onClicked: { app.getData() } }
        }
        VerticalScrollDecorator {}
    }
}

// vim: expandtab ts=4 st=4 sw=4 filetype=javascript
