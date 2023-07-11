/*

Copyright (c) 2023 Peter G. (nephros)
*/

// SPDX-License-Identifier: Apache-2.0


import QtQuick 2.6
import QtQuick.XmlListModel 2.0

XmlListModel {
    //common/service
    XmlRole { name: "type";        query: "@type/number()" }
    XmlRole { name: "name";        query: "name/string()" }
    XmlRole { name: "status";      query: "status/number()"; isKey: true}
    XmlRole { name: "monitor";     query: "monitor/number()"; isKey: true}
    XmlRole { name: "monitormode"; query: "monitormode/number()"; isKey: true}
    //XmlRole { name: "collected";   query: "collected_sec/number()"; isKey: true }
    /*
    onStatusChanged: {
        if (status === XmlListModel.Ready) {
            console.info("ServiceModel %2 loaded. %1 elements.".arg(count).arg(objectName))
            console.debug("First Element.", JSON.stringify(get(0)));
        }
    }
    */

}

// vim: ft=javascript expandtab ts=4 sw=4 st=4

