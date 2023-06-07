/*

 Copyright (c) 2023 Peter G. (nephros)

*/
// SPDX-License-Identifier: Apache-2.0

import QtQuick 2.6
import Sailfish.Silica 1.0

Page { id: about

  allowedOrientations: Orientation.All

  readonly property string copyright: "Peter G. (nephros)"
  readonly property string email: "mailto:sailfish@nephros.org?bcc=sailfish+app@nephros.org&subject=A%20message%20from%20a%20" + Qt.application.name + "%20user&body=Hello%20nephros%2C%0A"
  readonly property string license: "Apache-2.0"
  readonly property string licenseurl: "https://www.apache.org/licenses/LICENSE-2.0.html"
  readonly property string source: "https://codeberg.org/nephros/template-app"
  readonly property string appdesc: "%1 is ..."

  SilicaFlickable {
    contentHeight: col.height + Theme.itemSizeLarge
    anchors.fill: parent
    VerticalScrollDecorator {}
    Column {
        id: col
        width: parent.width - Theme.horizontalPageMargin
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: Theme.paddingLarge
        PageHeader { title: qsTr("About") + " " + Qt.application.name + " " + Qt.application.version }
        SectionHeader { text: qsTr("What's %1?").arg(Qt.application.name) }
        LinkedLabel {
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.secondaryColor
            font.pixelSize: Theme.fontSizeSmall
            horizontalAlignment: Text.AlignJustify
            wrapMode: Text.WordWrap
            plainText: qsTr(appdesc).arg(qsTr(Qt.application.name))
        }
        DetailItem { label: qsTr("Version:");      value: Qt.application.version }
        DetailItem { label: qsTr("Copyright:");    value: copyright;                            BackgroundItem { anchors.fill: parent; onClicked: Qt.openUrlExternally(email) } }
        DetailItem { label: qsTr("License:");      value: license + " (" + licenseurl + ")";    BackgroundItem { anchors.fill: parent; onClicked: Qt.openUrlExternally(licenseurl) } }
        DetailItem { label: qsTr("Source Code:");  value: source;                               BackgroundItem { anchors.fill: parent; onClicked: Qt.openUrlExternally(source) } }
        SectionHeader { text: qsTr("Credits") }
        //DetailItem { label: qsTr("Contributions and Help: "); value: "thigg,\nflypig" }
        DetailItem { label: qsTr("Translation: %1",  "%1 is the native language name").arg(Qt.locale("de").nativeLanguageName); value: "nephros" }
        //DetailItem { label: qsTr("Translation: %1",  "%1 is the native language name").arg(Qt.locale("sv").nativeLanguageName); value: "eson" }
    }
  }
}

// vim: ft=javascript expandtab ts=4 sw=4 st=4
