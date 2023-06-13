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
  description: "%1 is a simple frontend to the Monit service monitor".arg(appName)

  authors: "2023 Peter G. (nephros)"
  licenses: A.License { spdxId: "Apache-2.0" }
  sourcesUrl: "https://codeberg.org/nephros/template-app"

  readonly property string email: "mailto:sailfish@nephros.org?bcc=sailfish+app@nephros.org&subject=A%20message%20from%20a%20" + Qt.application.name + "%20user&body=Hello%20nephros%2C%0A"
}

// vim: ft=javascript expandtab ts=4 sw=4 st=4
