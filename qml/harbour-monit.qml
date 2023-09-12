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
import Nemo.Mce 1.0      // power saving mode
import Nemo.DBus 2.0;
import io.thp.pyotherside 1.5
import "pages"
import "cover"
import "components/xhr"
import "components/models"

ApplicationWindow {
    id: app

    allowedOrientations: Orientation.All

    property alias powersaving: powerSaveMode.active

    property string summary

    /* **** CONSTANTS ***** */

    // subpages, in reverse order:
    readonly property var pages: [
         //{ objectName: "syspage",  model: sysmodel,     title: qsTr("System") },
         { objectName: "dirpage",  model: dirmodel,     title: qsTr("Directories") },
         { objectName: "filepage", model: filemodel,    title: qsTr("Files") },
         { objectName: "fspage",   model: fsmodel,      title: qsTr("Filesystems") },
         { objectName: "hostpage", model: hostmodel,    title: qsTr("Remote Hosts") },
         { objectName: "netpage" , model: netmodel,     title: qsTr("Network") },
         { objectName: "progpage", model: programmodel, title: qsTr("Programs") },
         { objectName: "procpage", model: processmodel, title: qsTr("Processes") },
    ]

    readonly property var monit: {
        "proto": "http://",
        "host": "127.0.0.1",
        "port": "2812",
        "auth": "admin:monit",
        "xmluri": "/_status?format=xml",
        "summary": "/_report"
    }
    readonly property string moniturl: monit.proto + monit.host + ":" + monit.port
    readonly property string xmlurl: monit.proto + monit.auth + '@' + monit.host + ":" + monit.port + monit.xmluri
    readonly property string summaryurl: monit.proto + monit.auth + '@' + monit.host + ":" + monit.port + monit.summary
    readonly property string posturl: monit.proto + monit.auth + '@' + monit.host + ":" + monit.port

    // see monit.h: https://bitbucket.org/tildeslash/monit/src/master/src/monit.h 
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
    readonly property var monmodes: [
        "active",
        "passive"
    ]
    readonly property var monstatuses: [
        "not monitored",
        "monitored",
        "initializing",
        "waiting",
        "waiting"
    ]
    readonly property var connstates: [
        "failed",
        "ok",
        "initializing",
    ]
    readonly property var svcstatuses: [
        "succeeded",
        "failed",
        "changed",
        "not_changed",
        "initializing",
        "none"
    ]

    /* **** VARIABLES ***** */
    property var platformdata
    property var monitdata
    property var systemdata
    // seconds make cycle
    //property int polling: (!!monitdata && !!monitdata["poll"]) ? monitdata["poll"] : 0
    property int polling: 0
    Timer { id: refreshTimer
        interval: (!!polling && (polling > 0)) ? polling*1000 : 300*1000
        onTriggered: { console.info("Refrehed.") ; getData(); getSummary() }
    }
    property date refreshed
    XmlListModel { id: platformmodel
        //source: "http://app:secret@127.0.0.1:2812/_status?format=xml"
        //source: xmlurl
        xml: xmldata
        query: '/monit/platform'
        XmlRole { name: "name"; query: "name/string()" }
        XmlRole { name: "release"; query: "release/string()" }
        //XmlRole { name: "version"; query: "version/string()" }
        XmlRole { name: "machine"; query: "machine/string()" }
        XmlRole { name: "cpus"; query: "cpu/number()" }
        XmlRole { name: "memory"; query: "memory/number()" }
        XmlRole { name: "swap"; query: "swap/number()" }
        onStatusChanged: {
            if (status === XmlListModel.Ready) {
                //console.info("Platform model loaded.")
                platformdata = platformmodel.get(0);
            }
        }
    }
    XmlListModel { id: monitmodel
        query: '/monit/server'
        //source: xmlurl
        xml: xmldata
        XmlRole { name: "hostname"; query: "localhostname/string()" }
        XmlRole { name: "version"; query: "version/string()" }
        XmlRole { name: "config"; query: "controlfile/string()" }
        XmlRole { name: "uptime"; query: "uptime/number()" }
        XmlRole { name: "poll"; query: "poll/number()" }
        XmlRole { name: "delay"; query: "startdelay/number()" }
        XmlRole { name: "webserver"; query: "httpd/address/string()" }
        XmlRole { name: "webport"; query: "httpd/port/string()" }
        XmlRole { name: "webssl"; query: "httpd/ssl/number()" }
        onStatusChanged: {
            if (status === XmlListModel.Ready) {
                //console.info("Monit model loaded.")
                monitdata = monitmodel.get(0);
                polling = (!!monitdata["poll"] ) ? monitdata["poll"] : 0
            }
        }
    }

    ServiceModel { id: processmodel
        objectName: "processes"
        query: '/monit/service[@type=3]'
        xml: xmldata
        // shared: these are shared on process, filesystem:
        XmlRole { name: "read_total";  query: "read/bytes/total/number()" }
        XmlRole { name: "write_total"; query: "write/bytes/total/number()" }
        //process
        XmlRole { name: "pid";    query: "pid/number()" }
        XmlRole { name: "ppid";    query: "ppid/number()" }
        XmlRole { name: "uid";    query: "uid/number()" }
        XmlRole { name: "euid";    query: "euid/number()" }
        XmlRole { name: "procup";    query: "uptime/number()" }
        XmlRole { name: "proccpu";   query: "cpu/percenttotal/number()" }
        XmlRole { name: "procmem";   query: "memory/percenttotal/number()" }
    }
    ServiceModel { id: programmodel
        objectName: "programs"
        query: '/monit/service[@type=7]'
        xml: xmldata
        // program
        XmlRole { name: "progstatus"; query: "program/status/number()" }
        XmlRole { name: "proglast";   query: "program/started/number()" }
        XmlRole { name: "progout";    query: "program/output/string()" }
    }
    ServiceModel { id: netmodel
        objectName: "net"
        query: '/monit/service[@type=8]'
        xml: xmldata
        // net
        XmlRole { name: "netlink"; query: "link/state/number()" }
        XmlRole { name: "netup";   query: "upload/bytes/total/number()" }
        XmlRole { name: "netdown"; query: "download/bytes/total/number()" }
    }
    ServiceModel { id: hostmodel
        objectName: "host"
        query: '/monit/service[@type=4]'
        xml: xmldata
        // host
        XmlRole { name: "hostname"; query: "port/hostname/string()" }
        XmlRole { name: "hostport"; query: "port/portnumber/number()" }
        XmlRole { name: "hostreq";  query: " port/request/string()" }
        XmlRole { name: "hostproto";    query: "port/protocol/string()" }
        XmlRole { name: "hostnetproto"; query: "port/type/string()" }
    }
    ServiceModel { id: fsmodel
        objectName: "fs"
        query: '/monit/service[@type=0]'
        xml: xmldata
        // shared: these are shared on process, filesystem:
        XmlRole { name: "read_total";       query: "read/bytes/total/number()" }
        XmlRole { name: "write_total";      query: "write/bytes/total/number()" }
        XmlRole { name: "read_now";         query: "read/bytes/count/number()" }
        XmlRole { name: "write_now";        query: "write/bytes/count/number()" }
        // shared among dir, file, filesystem
        XmlRole { name: "mode";             query: "mode/number()" }
        XmlRole { name: "uid";              query: "uid/number()" }
        XmlRole { name: "gid";              query: "gid/number()" }
        // filesystem:
        XmlRole { name: "fstype";           query: "fstype/string()" }
        XmlRole { name: "fsflags";          query: "fsflags/string()" }
        XmlRole { name: "fs_bl_percent";    query: "block/percent/number()" }
        XmlRole { name: "fs_bl_usage";      query: "block/usage/number()" }
        XmlRole { name: "fs_bl_total";      query: "block/total/number()" }
        XmlRole { name: "fs_in_percent";    query: "inode/percent/number()" }
        XmlRole { name: "fs_in_usage";      query: "inode/usage/number()" }
        XmlRole { name: "fs_in_total";      query: "inode/total/number()" }
    }
    XmlListModel { id: sysmodel
        objectName: "sys"
        query: '/monit/service[@type=5]'
        xml: xmldata
        XmlRole { name: "name";        query: "name/string()" }
        //XmlRole { name: "FD alloc";   query: "filedescriptors/allocated/number()" }
        //XmlRole { name: "FD max";   query: "filedescriptors/maximum/number()" }
        XmlRole { name: "load 1";     query: "system/load/avg01/number()" }
        XmlRole { name: "load 5";     query: "system/load/avg05/number()" }
        XmlRole { name: "load 15";    query: "system/load/avg15/number()" }
        XmlRole { name: "CPU sys";    query: "system/cpu/system/number()" }
        XmlRole { name: "CPU user";   query: "system/cpu/user/number()" }
        XmlRole { name: "CPU nice";   query: "system/cpu/nice/number()" }
        XmlRole { name: "CPU wait";   query: "system/cpu/wait/number()" }
        XmlRole { name: "Mem %";      query: "system/memory/percent/number()" }
        XmlRole { name: "Mem kB";     query: "system/memory/kilobyte/number()" }
        XmlRole { name: "Swap %";     query: "system/swap/percent/number()" }
        XmlRole { name: "Swap kB";    query: "system/swap/kilobyte/number()" }
        onStatusChanged: {
            if (status === XmlListModel.Ready) {
                //console.info("System model loaded.")
                systemdata = sysmodel.get(0);
            }
        }
    }
    ServiceModel { id: dirmodel
        objectName: "dir"
        query: '/monit/service[@type=1]'
        xml: xmldata
        // shared among dir, file, filesystem
        XmlRole { name: "mode"; query: "mode/number()" }
        XmlRole { name: "uid";  query: "uid/number()" }
        XmlRole { name: "gid";  query: "gid/number()" }
    }
    ServiceModel { id: filemodel
        objectName: "file"
        query: '/monit/service[@type=2]'
        xml: xmldata
        XmlRole { name: "size"; query: "size/number()" }
        // shared among dir, file, filesystem
        XmlRole { name: "mode"; query: "mode/number()" }
        XmlRole { name: "uid";  query: "uid/number()" }
        XmlRole { name: "gid";  query: "gid/number()" }
    }

    /* detect closing of app*/
    //signal willQuit()
    //Connections { target: __quickWindow; onClosing: willQuit() }

    // Application goes into background or returns to active focus again
    onApplicationActiveChanged: {
        if (applicationActive) {
            if (!powersaving) { refreshTimer.start() }
        } else {
            if (!powersaving) { getSummary() }
            refreshTimer.stop()
        }
    }

     McePowerSaveMode { id: powerSaveMode }

    Component.onCompleted: {
        // for sailjail
        Qt.application.domain  = "sailfish.nephros.org";
        Qt.application.version = "unreleased";
        console.info("Intialized", Qt.application.name, "version", Qt.application.version, "by", Qt.application.organization );
        console.debug("Parameters: " + Qt.application.arguments.join(" "))
        getPasswd()
        getGroups()
        getData()
    }

    property string xmldata
    XHRItem { id: xhri; property bool busy
        onUnauthorized: {
            pageStack.push("NeedAuthPage.qml")
        }
    }
    function getGroup(gid) {
        if (groupInfo === null) { getGroups(); return '-' }
        //var gi = groupInfo.split('\n');
        for (var i=0; i<groupInfo.length; ++i) {
            var d = groupInfo[i].split(':');
            if (d[2] == gid) return d[0];
        }
        return 'unknown'
    }
    property var userInfo: null
    function getUser(uid) {
        if (userInfo === null) { getPasswd(); return '-' }
        for (var i=0; i<userInfo.length; ++i) {
            var d = userInfo[i].split(':');
            if (d[2] == uid) return d[0];
        }
        return 'unknown'
    }
    property var groupInfo: null
    function getPasswd() {
        xhri.xhr('file:///etc/passwd', "GET", false, function(r) {  userInfo = r.split('\n');})
    }
    function getGroups() {
        xhri.xhr('file:///etc/group', "GET", false, function(r) {  groupInfo = r.split('\n');})
    }
    function getData() {
        xhri.xhr(xmlurl, "GET", false, function(r) { refreshed = new Date(Date.now()); xmldata = r; })
    }
    function getSummary() {
        xhri.xhr(summaryurl, "GET", false, function(r) {
            var table = r.split('\n');
            var text = '<pre>\n'
            table.forEach(function(e){
                var tok = e.split(/[ ]+/);
                if (tok.length != 3) return
                text += tok[0].replace("up", "up   ").replace("down", "down ").replace("initialising", "init ").replace("unmonitored","unmon").replace("total","\ntotal")
                text += '\t\t' + ( (tok[1].length == 1) ? "0" + tok[1] : tok[1]);
                if (tok[2]) text += ' ' + tok[2];
                text += '\n';
            });
            text += '</pre>';
            app.summary = text;
        })
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

        function start() {
            //console.debug("dbus start unit", u );
            call('Start',
                ["replace",],
                function(result) { console.debug("Start Job created"); },
                function(result) { console.warn("Start", result) }
            );
        }
        function stop() {
            //console.debug("dbus stop unit", u );
            call('Stop',
                [ "replace",],
                function(result) { console.debug("Stop Job created"); },
                function(result) { console.warn("Stop", result) }
            );
        }
        function enable()   { console.debug("Trying to ensable"); manager.enable("monit.service") }
        function disable()  { console.debug("Trying to disable"); manager.disable("monit.service") }
    }
    DBusInterface {
        id: manager
        bus: DBus.SystemBus
        service: "org.freedesktop.systemd1"
        path: "/org/freedesktop/systemd1"
        iface: "org.freedesktop.systemd1.Manager"

        function enable(u) {
            typedCall('EnableUnitFiles', [
                { "type": "as", "value": [u] },
                { "type": "b", "value": false },
                { "type": "b", "value": false },
            ],
            function(result) { console.warn("Enable Job created.") },
            function(result) { console.warn("Enable", result[1]) }
            );
        }
        function disable(u) {
            typedCall('DisableUnitFiles', [
                { "type": "as", "value": [u] },
                { "type": "b", "value": false },
            ],
            function(result) { console.warn("Disable Job created.") },
            function(result) { console.warn("Disable", result) }
            );
        }
    }
    Python { id: control
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../py'));
            importModule("monitcontrol", [ ], function(){} )
        }
        function status() { call("monitcontrol.status")}
        function cmd(cmd,parms) { call("monitcontrol.status", [cmd,parms])}
    }
    initialPage: Component { SvcPageBase { } }
    cover: CoverPage{}

    //PageBusyIndicator { running: app.status === Component.Loading }
}

// vim: ft=javascript expandtab ts=4 sw=4 st=4
