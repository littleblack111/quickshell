import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.services
import qs.config

import core

IComponent {
    property string symbol
    required property bool category
    required property string predictiveText

    property int cursorPosition: SelectionState.cursorPosition

    preview: Component {
        Icon {
            text: symbol
        }
    }

    onInputChanged: {
        SmartCalc.reset_result();
    }

    process: function () {
        SmartCalc.query(input);
        const answer = SmartCalc.result;
        // TODO: use answer property rn its circular dependent since it has to be valid which is the line below
        const valid = SmartCalc.result && SmartCalc.result.length > 0 && category;
        return {
            valid,
            priority: valid,
            answer,
            predictiveCompletion: ` ${predictiveText} ` + answer
        };
    }
    exec: function () {
        Clip.copy(answer);
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
                    text: input
                    font {
                        pixelSize: Launcher.widgetFontSize
                        bold: isSelectedPriority()
                    }
                }
            }

            IText {
                visible: valid
                text: "→"
                font.pixelSize: Launcher.widgetFontSize
                font.bold: isSelectedPriority()
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
                        bold: isSelectedPriority()
                    }
                }
            }
        }
    }
}
