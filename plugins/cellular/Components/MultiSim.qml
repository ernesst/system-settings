/*
 * Copyright (C) 2014 Canonical Ltd
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authors:
 * Jonas G. Drange <jonas.drange@canonical.com>
 *
*/
import QtQuick 2.0
import GSettings 1.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem

Column {

    objectName: "multiSim"

    property var sims
    property var modems

    // make settings available to all children of root
    property var settings: phoneSettings

    CellularMultiSim {
        anchors { left: parent.left; right: parent.right }
    }

    ListItem.Divider {}

    ListItem.SingleValue {
        text : i18n.tr("Hotspot disabled because Wi-Fi is off.")
        visible: showAllUI && !hotspotItem.visible
    }

    ListItem.SingleValue {
        id: hotspotItem
        text: i18n.tr("Wi-Fi hotspot")
        progression: true
        onClicked: {
            pageStack.push(Qt.resolvedUrl("Hotspot.qml"))
        }
        visible: showAllUI && (actionGroup.actionObject.valid ? actionGroup.actionObject.state : false)
    }

    ListItem.Standard {
        id: dataUsage
        text: i18n.tr("Data usage statistics")
        progression: true
        visible: showAllUI
    }

    ListItem.Divider {
        visible: hotspotItem.visible || dataUsage.visible
    }

    ListItem.SingleValue {
        text: i18n.tr("Carriers")
        id: chooseCarrier
        objectName: "chooseCarrier"
        progression: enabled
        onClicked: {
            pageStack.push(Qt.resolvedUrl("../PageChooseCarriers.qml"), {
                sims: sims
            });
        }
    }

    ListItem.Divider {}

    SimEditor {
        anchors { left: parent.left; right: parent.right }
    }

    ListItem.Divider {}

    DefaultSim {
        anchors { left: parent.left; right: parent.right }
    }

    GSettings {
        id: phoneSettings
        schema.id: "com.ubuntu.phone"
        Component.onCompleted: {
            // set default names
            var simNames = phoneSettings.simNames;
            var m0 = modems[0];
            var m1 = modems[1];
            if (!simNames[m0]) {
                simNames[m0] = "SIM 1";
            }
            if (!simNames[m1]) {
                simNames[m1] = "SIM 2";
            }
            phoneSettings.simNames = simNames;
        }
    }

    Binding {
        target: sims[0]
        property: "name"
        value: phoneSettings.simNames[modems[0]]
    }

    Binding {
        target: sims[1]
        property: "name"
        value: phoneSettings.simNames[modems[1]]
    }
}