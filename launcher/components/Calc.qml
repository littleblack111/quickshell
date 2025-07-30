import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.config

IComponent {
    required property int cursorPosition
    name: "Calculator"
    preview: Component {
        Icon {
            text: ""
        }
    }

    process: function () {
        const isValid = /^(?=.*\d)(?=.*[+\-*\/\^])[0-9+\-*\/\^().\s]+$/.test(input);
        const answer = isValid ? String(eval(input.replace(/\^/g, '**').replace(/([\d)])\(/g, '$1*(').replace(/\)([\d])/g, ')*$1'))) : null;
        return {
            valid: isValid,
            priority: isValid,
            answer: answer,
            predictiveCompletion: isValid ? ' = ' + answer : ''
        };
    }

    IInnerComponent {
        RowLayout {
            spacing: 0
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: parent.height

            Item {
                Layout.fillWidth: true
                IText {
                    anchors.centerIn: parent
                    elide: cursorPosition > input.length / 2 ? Text.ElideLeft : Text.ElideRight
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
                    width: Math.min(implicitWidth, parent.width - Launcher.innerMargin * 2)
                    renderType: Text.CurveRendering
                    visible: valid
                    text: valid ? answer : ''
                    font {
                        pixelSize: Launcher.widgetFontSize
                        bold: true
                    }
                }
            }
        }
    }
}
