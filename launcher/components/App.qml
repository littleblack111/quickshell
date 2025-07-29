import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.services
import qs.config

IComponent {
    name: "Applications"
    process: function () {
        return {
            valid: false,
            priority: false
        };
        // if (!input)
        //     return {
        //         valid: false,
        //         priority: false
        //     };
        // const query = AppSearch.fuzzyQuery(input);
        // if (query.length < 1)
        //     return {
        //         valid: false,
        //         priority: false
        //     };
        //
        // return {
        //     valid: true,
        //     priority: query[0].name === input ? true : false // TODO: maybe generic name as well, maybe 1 char fuzzy, also maybe case insensitive?
        // };
    }

    RowLayout {
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
                text: valid ? String(eval(input.replace(/([\d)])\(/g, '$1*(').replace(/\)([\d])/g, ')*$1'))) : ""
                font {
                    pixelSize: Launcher.widgetFontSize
                    bold: true
                }
            }
        }
    }
}
