/*
 Copyright (c) 2023 Peter G. (nephros)
*/
// SPDX-License-Identifier: Apache-2.0

import QtQuick 2.6
import Sailfish.Silica 1.0

GlassItem { id: indicator
    property bool checked
    property bool busy

    opacity: checked ? 1.0 : Theme.opacityLow
    color: highlighted ? palette.highlightColor
        : dimmed ? palette.primaryColor
        : Theme.lightPrimaryColor
    backgroundColor: checked || busy ? palette.backgroundGlowColor : "transparent"
    dimmed: !checked
    falloffRadius: checked ? defaultFalloffRadius : (palette.colorScheme === Theme.LightOnDark ? 0.075 : 0.1)
    Behavior on falloffRadius {
        NumberAnimation { duration: busy ? 450 : 50; easing.type: Easing.InOutQuad }
    }
    // KLUDGE: Behavior and State don't play well together
    // http://qt-project.org/doc/qt-5/qtquick-statesanimations-behaviors.html
    // force re-evaluation of brightness when returning to default state
    brightness: { return 1.0 }
    Behavior on brightness {
        NumberAnimation { duration: busy ? 450 : 50; easing.type: Easing.InOutQuad }
    }
}

// vim: expandtab ts=4 st=4 sw=4 filetype=javascript
