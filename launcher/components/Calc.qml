import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.config

IComponent {
    name: "Calculator"
    process: function () {
        const isValid = /^(?=.*\d)(?=.*[+\-*\/\^])[0-9+\-*\/\^().\s]+$/.test(input);
        return {
            valid: isValid,
            priority: isValid
        };
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
