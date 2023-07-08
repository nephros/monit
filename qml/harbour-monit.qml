/*

Copyright (c) 2023 Peter G. (nephros)

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this file except in compliance with the License.  
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

*/

// SPDX-License-Identifier: Apache-2.0


import QtQuick 2.6
import QtQuick.XmlListModel 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0
//import Nemo.Mce 1.0      // power saving mode
import Nemo.DBus 2.0
import "pages"
import "cover"
import "components/xhr"

ApplicationWindow {
    id: app

    allowedOrientations: Orientation.All

    //property alias powersaving: powerSaveMode.active

    readonly property var monit: {
        "proto": "http://",
        "host": "127.0.0.1",
        "port": "2812",
        "auth": "admin:monit",
        "xmluri": "/_status?format=xml"
    }
    readonly property string moniturl: monit.proto + monit.host + ":" + monit.port
    readonly property string xmlurl: monit.proto + monit.auth + '@' + monit.host + ":" + monit.port + monit.xmluri

    // see monit.h
    readonly property var types: [
        "filesystem",
        "dir",
        "file",
        "process",
        "host",
        "system",
        "fifo",
        "program",
        "net",
    ]
    readonly property var monitors: [
        "active",
        "passive"
    ]
    readonly property var monitormodes: [
        "not monitored",
        "monitored",
        "initializing",
        "",
        "waiting",
    ]
    readonly property var statuses: [
        "ok",
        "down",
        // TODO: unverified:
        "initializing",
        "waiting",
        "not monitored"
    ]

    XHRItem { id: x ; property bool busy: false }
    function getData() {
        x.xhr(xmlurl, "GET", false, function(ret) {
            //console.debug("got:", ret)
            servicemodel.xml = ret;
            processmodel.xml = ret;
            programmodel.xml = ret;
            netmodel.xml = ret;
        })
    }
    // FIXME: several.requests for the same data...
    property var platformdata
    XmlListModel { id: platformmodel
        //source: "http://app:secret@127.0.0.1:2812/_status?format=xml"
        source: xmlurl
        query: '/monit/platform'
        XmlRole { name: "name"; query: "name/string()" }
        XmlRole { name: "release"; query: "release/string()" }
        //XmlRole { name: "version"; query: "version/string()" }
        XmlRole { name: "machine"; query: "machine/string()" }
        XmlRole { name: "cpu"; query: "cpu/number()" }
        XmlRole { name: "memory"; query: "memory/number()" }
        XmlRole { name: "swap"; query: "swap/number()" }
        onStatusChanged: {
            console.debug("status:", status, errorString(), count)
            if (status === XmlListModel.Ready) {
                platformdata = platformmodel.get(0);
            }
        }
    }
    XmlListModel { id: monitmodel
        //source: "http://app:secret@127.0.0.1:2812/_status?format=xml"
        source: xmlurl
        query: '/monit/server'
        //onStatusChanged: console.debug("status:", status, errorString(), count)
    }
    XmlListModel { id: servicemodel
        //source: "http://app:secret@127.0.0.1:2812/_status?format=xml"
        //source: xmlurl
        query: '/monit/service'
        XmlRole { name: "type"; query: "@type/number()" }
        XmlRole { name: "name"; query: "name/string()" }
        XmlRole { name: "status"; query: "status/number()"; isKey: true}
        XmlRole { name: "monitor"; query: "monitor/number()"; isKey: true}
        XmlRole { name: "monitormode"; query: "monitormode/number()"; isKey: true}
        XmlRole { name: "collected"; query: "collected_sec/number()"; isKey: true }

        //process
        XmlRole { name: "procup"; query: "uptime/number()" }
        XmlRole { name: "proccpu"; query: "cpu/percenttotal/number()" }
        XmlRole { name: "procmem"; query: "memory/percenttotal/number()" }
        XmlRole { name: "procread"; query: "read/bytes/total/number()" }
        XmlRole { name: "procwrite"; query: "write/bytes/total/number()" }

        // program
        XmlRole { name: "progstatus"; query: "program/status/number()" }
        XmlRole { name: "proglast"; query: "program/started/number()" }
        XmlRole { name: "progout"; query: "program/output/string()" }

        // net
        XmlRole { name: "netlink"; query: "link/state/number()" }
        XmlRole { name: "netup"; query: "upload/bytes/total/number()" }
        XmlRole { name: "netdown"; query: "download/bytes/total/number()" }

        //onStatusChanged: console.debug("status:", status, errorString(), count)
    }
    XmlListModel { id: processmodel
        //source: "http://app:secret@127.0.0.1:2812/_status?format=xml"
        query: '/monit/service'
        XmlRole { name: "type"; query: "@type/number()" }
        XmlRole { name: "name"; query: "name/string()" }
        XmlRole { name: "status"; query: "status/number()"; isKey: true}
        XmlRole { name: "monitor"; query: "monitor/number()"; isKey: true}
        XmlRole { name: "monitormode"; query: "monitormode/number()"; isKey: true}
        XmlRole { name: "collected"; query: "collected_sec/number()"; isKey: true }

        //process
        XmlRole { name: "procup"; query: "uptime/number()" }
        XmlRole { name: "proccpu"; query: "cpu/percenttotal/number()" }
        XmlRole { name: "procmem"; query: "memory/percenttotal/number()" }
        XmlRole { name: "procread"; query: "read/bytes/total/number()" }
        XmlRole { name: "procwrite"; query: "write/bytes/total/number()" }
        //onStatusChanged: console.debug("status:", status, errorString(), count)
    }
    XmlListModel { id: programmodel
        //source: "http://app:secret@127.0.0.1:2812/_status?format=xml"
        query: '/monit/service'
        XmlRole { name: "type"; query: "@type/number()" }
        XmlRole { name: "name"; query: "name/string()" }
        XmlRole { name: "status"; query: "status/number()"; isKey: true}
        XmlRole { name: "monitor"; query: "monitor/number()"; isKey: true}
        XmlRole { name: "monitormode"; query: "monitormode/number()"; isKey: true}
        XmlRole { name: "collected"; query: "collected_sec/number()"; isKey: true }
        // program
        XmlRole { name: "progstatus"; query: "program/status/number()" }
        XmlRole { name: "proglast"; query: "program/started/number()" }
        XmlRole { name: "progout"; query: "program/output/string()" }
        //onStatusChanged: console.debug("status:", status, errorString(), count)
    }
    XmlListModel { id: netmodel
        //source: "http://app:secret@127.0.0.1:2812/_status?format=xml"
        query: '/monit/service'
        XmlRole { name: "type"; query: "@type/number()" }
        XmlRole { name: "name"; query: "name/string()" }
        XmlRole { name: "status"; query: "status/number()"; isKey: true}
        XmlRole { name: "monitor"; query: "monitor/number()"; isKey: true}
        XmlRole { name: "monitormode"; query: "monitormode/number()"; isKey: true}
        XmlRole { name: "collected"; query: "collected_sec/number()"; isKey: true }
        // net
        XmlRole { name: "netlink"; query: "link/state/number()" }
        XmlRole { name: "netup"; query: "upload/bytes/total/number()" }
        XmlRole { name: "netdown"; query: "download/bytes/total/number()" }

        onStatusChanged: console.debug("status:", status, errorString(), count)
    }

    /* detect closing of app*/
    signal willQuit()
    Connections { target: __quickWindow; onClosing: willQuit() }

    /*
    // Application goes into background or returns to active focus again
    onApplicationActiveChanged: {
        if (applicationActive) {
        } else {
        }
    }
    */

    /*
     McePowerSaveMode { id: powerSaveMode }
    */

    Component.onCompleted: {
        // for sailjail
        Qt.application.domain  = "sailfish.nephros.org";
        Qt.application.version = "unreleased";
        console.info("Intialized", Qt.application.name, "version", Qt.application.version, "by", Qt.application.organization );
        console.debug("Parameters: " + Qt.application.arguments.join(" "))
        getData();
    }

    // application settings:
    ConfigurationGroup  {
        id: settings
        path: "/org/nephros/" + Qt.application.name
    }
    ConfigurationGroup  {
        id: config
        scope: settings
        path:  "app"
        //property bool gravity: true // true: pull to bottom
        //property int ordering: 1 // 1: top to bottom
    }

    /*
     * Dbus interface to systemd unit
    */
    property bool serviceRunning: dbus.activeState === "active"
    DBusInterface {
        id: dbus
        bus: DBus.SystemBus
        service: "org.freedesktop.systemd1"
        path: "/org/freedesktop/systemd1/unit/monit_2eservice"
        iface: "org.freedesktop.systemd1.Unit"

        propertiesEnabled: true

        property string activeState
        property string subState
        property string unitFileState

        function start(u) {
            //console.debug("dbus start unit", u );
            call('Start',
                ["replace",],
                function(result) { console.debug("Job:", JSON.stringify(result)); },
                function(result) { console.warn("Start %1".arg(u), result) }
            );
        }
        function stop(u) {
            //console.debug("dbus stop unit", u );
            call('Stop',
                [ "replace",],
                function(result) { console.debug("Job:", JSON.stringify(result)); },
                function(result) { console.warn("Stop %1".arg(u), result) }
            );
        }
    }

    initialPage: Component { MainPage{} }
    //cover: CoverPage{}

    //PageBusyIndicator { running: app.status === Component.Loading }
}

// vim: ft=javascript expandtab ts=4 sw=4 st=4
