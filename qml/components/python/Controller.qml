// Copyright (c) 2023 Peter G. (nephros)
// SPDX-License-Identifier: Apache-2.0

import QtQuick 2.6
import QtQuick.XmlListModel 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.5

Python { id: control
    property string script
    property url path

    Component.onCompleted: {
        console.debug("Loading script %1 from %2".arg(script).arg(path))
        addImportPath(path);
        importModule(script, [ ], function(){} )
    }
    function status() { call("monitcontrol.status")}
    // call `monit cmd parms[]` and refresh afterwards
    function cmd(cmd,parms) { call("monitcontrol.custom", [cmd,parms], function(res){ app.getData() })}
}

// vim: ft=javascript expandtab ts=4 sw=4 st=4
