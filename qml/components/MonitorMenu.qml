/*
 Copyright (c) 2023 Peter G. (nephros)
*/
// SPDX-License-Identifier: Apache-2.0

import QtQuick 2.6
import Sailfish.Silica 1.0

ContextMenu { id: root
    property bool running: false
    property bool canControl: ((types[type] === "process") || (types[type] === "program"))
    MenuItem { text: qsTr("Open Details"); onClicked: { Qt.openUrlExternally(moniturl + '/' + name) } }
    /*
     * Doing this over HTTP would be nice, but can not work, becasue
     * XMLHttpeRequest can not set Cookies in the response, which is needed in
     * the authentication scheme.

        <form method=POST action=MyProcessName>
          <input type=hidden name='securitytoken' value='d5a2fe327d0dd20f5e4544e1369a3c7b'>
          <input type=hidden value='unmonitor' name=action>
          <input type=submit value='Disable monitoring'>
        </form>
    function toggleMonitor() {
        if (!token.length > 0) { console.warn("Toggle monitoring called without token!"); return}
        const action = monitored ? "unmonitor" : "monitor"
        // xhrpost(url, type, payload, callback) {
        const payload = encodeURI("securitytoken=" + token + '&' + "action=" + action)
        //const payload = "action=" + action + '&' + "securitytoken=" + token
        xhri.xhrpost(posturl + '/' + name , token, payload, function(r) { console.debug("Submitted:", action, "got", r) })
    }
    */
    function toggleMonitor() {
        if (!token.length > 0) { console.warn("Toggle monitoring called without token!"); return}
        const action = monitored ? "unmonitor" : "monitor"
        control.cmd(action, name)
    }
    MenuItem {
        enabled: token.length > 0
        text: qsTr("%1 Monitoring").arg(!!monitored ? qsTr("Stop") : qsTr("Start"))
        onClicked: toggleMonitor()
    }
    MenuItem {
        visible: canControl
        text: qsTr("%1 Service").arg(!!root.running ? qsTr("Stop") : qsTr("Start"))
        onClicked: toggleService()
    }
    MenuItem {
        visible: canControl
        text: qsTr("Restart Service")
        enabled: !!root.running
        onClicked: restartService()
    }
}

// vim: expandtab ts=4 st=4 sw=4 filetype=javascript
