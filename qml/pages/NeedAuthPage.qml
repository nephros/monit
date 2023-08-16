/*

 Copyright (c) 2023 Peter G. (nephros)

*/
// SPDX-License-Identifier: Apache-2.0

import QtQuick 2.6
import Sailfish.Silica 1.0
import "../components"

Dialog { id: settingsPage

    allowedOrientations: Orientation.All

    //onStatusChanged: (status === PageStatus.Deactivating) ? app.refresh() : 0
    SilicaFlickable{
        anchors.fill: parent
        contentHeight: col.height
        Column {
            id: col
            spacing: Theme.paddingSmall
            bottomPadding: Theme.itemSizeLarge
            width: parent.width - Theme.horizontalPageMargin
            anchors.horizontalCenter: parent.horizontalCenter
            DialogHeader{ title: qsTr("Authorization required.", "page title")}
            SectionHeader {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Server")
            }
            TextField{ id: host
                text: moniturl
            }
            SectionHeader {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Authrization")
            }
            Label {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Default values are hardcoded. You can change them, but changes are not saved.")
                horizontalAlignment: Qt.AlignRight
            }
            TextField{ id: user
                text: monit.auth.split(":")[0]
            }
            PasswordField{ id: pass
                text: monit.auth.split(":")[1]
            }
            SectionHeader {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Service")
            }
            TextSwitch{ id: svcsw
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                checked: dbus.activeState === "active"
                busy: dbus.activeState === "activating" || dbus.activeState === "deactivating"
                automaticCheck: false
                text: qsTr("Monit Service")
                description: qsTr("The service is %1.").arg(dbus.activeState)
                onClicked: {
                    checked  ? dbus.stop() : dbus.start()
                }
            }
            TextSwitch{ id: unitsw
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                checked: dbus.unitFileState === "enabled"
                automaticCheck: false
                text: qsTr("Start at boot")
                description: qsTr("The service is %1.").arg(dbus.unitFileState)
                onClicked: {
                    checked  ? dbus.disable() : dbus.enable()
                }
            }
            /*
            SectionHeader {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Application")
            }
            TextSwitch{ id: notifysw
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                checked: app.notify
                automaticCheck: true
                text: qsTr("Show Notifications")
                description: qsTr("If enabled, the app will send notifications.<br /> Use the slider below to specify how often to check.")
                onClicked: app.notify = checked
            }
            Slider {
                id: intervalSlider
                enabled: notifysw.checked
                handleVisible: enabled
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                //label: qsTr("Interval in %1","parameter is minutes or seconds").arg(qsTr("minutes"));
                label: qsTr("Check every");
                minimumValue: 1
                maximumValue: 120
                stepSize: 1
                value: app.checkInterval / 5
                //valueText: value * 5
                valueText: Format.formatDuration(value*5,Formatter.DurationShort) + " " + qsTr("min");
                onReleased: app.checkInterval = sliderValue * 5
            }
           TextSwitch{
                enabled: notifysw.checked
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                checked: app.notifySticky
                automaticCheck: true
                text: qsTr("Sticky Notifications")
                description: qsTr("If enabled, the app will update a single notification (as opposed to sending a new one each time).")
                onClicked: app.notifySticky = checked
            }

            SectionHeader { text: qsTr("Advanced:")}
            TextSwitch{
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                checked: !app.showFoo
                automaticCheck: true
                text: qsTr("Hide Foo")
                description: qsTr("If enabled, the app will ...")
                onClicked: app.hybris = !checked
            }
            TextSwitch{
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                checked: app.showBar
                automaticCheck: true
                text: qsTr("Show bar")
                description: qsTr("If enabled, the app will ...")
                onClicked: app.boring = !checked
            }
        */
        }
        /*
        PullDownMenu {
            //MenuLabel { text: qsTr("Settings") }
            MenuItem {
                text: qsTr("Reset all to default")
                onClicked: { Remorse.popupAction(settingsPage, qsTr("All settings cleared"), function() { app.resetSettings() } )}
            }
        }
        PushUpMenu {
            visible: (app.pignore.count > 0 || app.ignore.count > 0)
            MenuItem {
                enabled: pList.count > 0
                text: qsTr("Clear permanent ignore list")
                onClicked: { Remorse.popupAction(settingsPage, qsTr("List Cleared."), function() { app.resetIgnorePerm() } )}
            }
            MenuItem {
                enabled: iList.count > 0
                text: qsTr("Clear session ignore list")
                onClicked: { Remorse.popupAction(settingsPage, qsTr("List Cleared."), function() { app.ignore.clear(); } )}
            }
        }
        */
        VerticalScrollDecorator {}
    }
}

// vim: ft=javascript expandtab ts=4 sw=4 st=4
