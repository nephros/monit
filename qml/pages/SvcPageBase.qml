/*

 Copyright (c) 2023 Peter G. (nephros)

*/
// SPDX-License-Identifier: Apache-2.0

import QtQuick 2.6
//import QtQuick.XmlListModel 2.0
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
    property string subtitle: qsTr("Target")
    property ListModel model
    property Component delegate: MonitorDelegate{}

    Component.onCompleted: console.debug("Loaded page", objectName)

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
            PageHeader { id: head ; title: page.title }
            Grid { id: monit
                visible: (!!!page.objectName) // the "first" page has no object name
                width: parent.width
                columns: 2
                rows:    3
                flow: Grid.TopToBottom
                Repeater {
                    model: monitdata ? Object.keys(monitdata) : null
                    delegate: DetailItem {
                        width: platform.width/2
                        label: modelData[0].toUpperCase() + modelData.substr(1); value: platformdata[modelData]
                    }
                }
            }
            Grid { id: platform
                visible: (!!!page.objectName) // the "first" page has no object name
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
            //SectionHeader { text: page.subtitle}
            SilicaListView { id: svcview
                height: page.height - (head.height + platform.height)
                width: isLandscape ? parent.width : parent.width*2
                spacing: Theme.paddingMedium
                model: page.model
                delegate: page.delegate
            }
            ColumnView {
                visible: (!!!page.objectName)
                model: servicemodel
                delegate: MonitorDelegate{}
                itemHeight: Theme.itemSizeMedium
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
            MenuItem { text: qsTr("Refresh"); onClicked: { servicemodel.reload()} }
        }
        VerticalScrollDecorator {}
    }
}

// vim: expandtab ts=4 st=4 sw=4 filetype=javascript
