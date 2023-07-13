/*
 Copyright (c) 2023 Peter G. (nephros)
*/
// SPDX-License-Identifier: Apache-2.0

import QtQuick 2.6
import Sailfish.Silica 1.0
//import Opal.About 1.0 as A
import "../external/opal-about/Opal/About" as A

A.AboutPageBase { id: about

  allowedOrientations: Orientation.All

  appName: Qt.application.name
  appVersion: Qt.application.version
  description: "%1 is a simple frontend to the Monit service monitor.\nIts name derives.from Monit's slogan, 'barking at daemons', adding a maritime twist.".arg(appName)

  authors: "2023 Peter G. (nephros)"
  licenses: A.License { spdxId: "Apache-2.0" }
  sourcesUrl: "https://github.com/nephros/monit/tree/app"
  readonly property string email: "mailto:sailfish@nephros.org?bcc=sailfish+app@nephros.org&subject=A%20message%20from%20a%20" + Qt.application.name + "%20user&body=Hello%20nephros%2C%0A"
  extraSections: A.InfoSection {
      title: qsTr("Monit")
      text: qsTr("%1 is a frontend to the Monit program. See the links for more information.").arg(appName)
      buttons: [
          A.InfoButton {
          text: qsTr("Home")
          onClicked: openOrCopyUrl("https://mmonit.com")
      },
          A.InfoButton {
          text: qsTr("Documentation")
          onClicked: openOrCopyUrl("https://mmonit.com/monit/#documentation")
      },
      A.InfoButton {
          text: qsTr("Wiki")
          onClicked: openOrCopyUrl("https://mmonit.com/wiki/")
      }
      ]
  }
}

// vim: ft=javascript expandtab ts=4 sw=4 st=4
