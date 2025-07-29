import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.services
import qs.config

IComponent {
    // TODO: presist how much times per app is opened on disk, routinely check if the app is still there
    name: "Applications"
    process: function () {
        if (!input)
            return {
                valid: false,
                priority: false
            };
        const query = AppSearch.fuzzyQuery(input);
        query.forEach(app => {
            console.log(app.name);
        });
        if (query.length < 1)
            return {
                valid: false,
                priority: false
            };

        return {
            valid: true,
            priority: query[0].name.toLowerCase() === input.toLowerCase() ? true : false // TODO: maybe generic name as well, maybe 1 char fuzzy, also maybe case insensitive?
        };
    }

    ColumnLayout {
        spacing: 0
        anchors.fill: parent

        Item {
            Layout.fillWidth: true
            IText {
                anchors.centerIn: parent
                elide: Text.ElideLeft
                width: Math.min(implicitWidth, parent.width - Launcher.innerMargin * 2)
                clip: true
                renderType: Text.CurveRendering
                visible: valid
                text: input.replace(/ /g, "").replace(/\+/g, " + ").replace(/-/g, " - ").replace(/\*/g, " × ").replace(/\//g, " ÷ ").replace(/%/g, " % ").replace(/\(/g, " ( ").replace(/\)/g, " ) ")
                font {
                    pixelSize: Launcher.widgetFontSize
                    bold: true
                }
            }
        }

        IText {
            visible: valid
            text: "→"
            font.pixelSize: Launcher.widgetFontSize
            font.bold: true
        }

        Item {
            Layout.fillWidth: true
            IText {
                animate: true
                anchors.centerIn: parent
                elide: Text.ElideLeft
                width: Math.min(implicitWidth, parent.width - Launcher.innerMargin * 2)
                renderType: Text.CurveRendering
                visible: valid
                // text: valid ? String(eval(input.replace(/([\d)])\(/g, '$1*(').replace(/\)([\d])/g, ')*$1'))) : ""
                font {
                    pixelSize: Launcher.widgetFontSize
                    bold: true
                }
            }
        }
    }
}
