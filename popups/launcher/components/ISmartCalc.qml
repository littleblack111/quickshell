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
	property string answer: active && valid ? SmartCalc.result : ""

    preview: Component {
        Icon {
            text: symbol
        }
    }

    process: function () {
    	SmartCalc.query(input);
	    const isValid = active && SmartCalc.result && SmartCalc.result.length > 0 && category;
        const answer = isValid ? SmartCalc.result : "";
        return {
            valid: isValid,
            priority: isValid,
            answer: answer,
            predictiveCompletion: isValid ? ` ${predictiveText} ` + answer : ''
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
