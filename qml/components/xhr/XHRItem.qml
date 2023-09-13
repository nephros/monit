/*

 Copyright (c) 2023 Peter G. (nephros)

*/
// SPDX-License-Identifier: Apache-2.0

//pragma Singleton
import QtQuick 2.6
import Sailfish.Silica 1.0

QtObject { id: obj

    readonly property string userAgent: "Mozilla/5.0 (Sailfish OS; Linux; aarch64; rv:92.0) Gecko/20100101 Firefox/92.0 " + Qt.application.name + "/" + Qt.application.version
    readonly property string apiHost:   "https://api.example.org"
    readonly property string apiUrl:    apiHost + "/v1"

    property string token: ""

    readonly property string dlRoot: StandardPaths.download
    readonly property string dlPath: dlRoot + "/" + Qt.application.name

    property string lastError

    signal unauthorized

    function xhr(url, type, partial, callback) {
        //if (token === "") return false;   // not without token!
        var query = Qt.resolvedUrl(url);
        var r = new XMLHttpRequest();
        r.open(type, query);
        r.setRequestHeader('User-Agent', userAgent)
        r.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
        //r.setRequestHeader('X-Auth-Token', token);
        //r.setRequestHeader('X-App-Client', Qt.application.name);
        //r.setRequestHeader('X-App-Version', Qt.application.version);
        //r.setRequestHeader('Accept', 'application/json');
        r.setRequestHeader('Origin', '');

        r.send();
        r.onreadystatechange = function(event) {
            if (r.readyState == XMLHttpRequest.DONE) {
                if (partial && r.status === 206) {
                    //var rdata = JSON.parse(r.response);
                    //callback(rdata)
                    callback(r.response)
                } else if (r.status === 200 || r.status == 0) {
                    //var rdata = JSON.parse(r.response);
                    //callback(rdata)
                    callback(r.response)
                } else {
                    console.debug("error in processing request.", query, r.status, r.statusText);
                    obj.lastError = r.statusText;
                }
            busy = false;
            }
        }
    }

    function xhrpost(url, token, payload, callback) {
        var query = Qt.resolvedUrl(url);
        var r = new XMLHttpRequest();
        r.open("POST", query);
        r.setRequestHeader('User-Agent', userAgent)
        r.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
        //r.setRequestHeader('X-Auth-Token', token);
        //r.setRequestHeader('X-App-Client', Qt.application.name);
        //r.setRequestHeader('X-App-Version', Qt.application.version);
        //r.setRequestHeader('Accept', 'application/json');
        //r.setRequestHeader('Content-Type', 'application/json;charset=UTF-8');
        r.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        r.setRequestHeader('Cookie', 'securitytoken=' + token); //+';');
        //r.setRequestHeader('Content-Length', payload.length);

        r.withCredentials = true;
        console.debug("posting:", payload, "to", url);

        r.send(payload);

        r.onreadystatechange = function(event) {
            if (r.readyState == XMLHttpRequest.DONE) {
                if (r.status === 200 || r.status == 0) {
                    var rdata = JSON.parse(r.response);
                    callback(rdata)
                } else {
                    console.debug("error in processing request.", r.status, r.statusText, r.responseText);
                    obj.lastError = r.statusText;
                }
            busy = false;
            }
        }
    }
}
// vim: ft=javascript expandtab ts=4 sw=4 st=4
