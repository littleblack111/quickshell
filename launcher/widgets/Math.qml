import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.config

IWidget {
    name: "Math"
    anchors.verticalCenter: parent.verticalCenter
    valid: processed.valid
    priority: processed.priority

    process: function () {
        var isValid = /^[0-9+\-*/()%.\s]+$/.test(input);
        return {
            valid: isValid,
            priority: isValid
        };
    }

    // TODO: move to IInnerWidget
    ColumnLayout {
        anchors {
            fill: parent
            margins: Launcher.innerMargin
        }
        IText {
            Layout.fillHeight: false
            visible: valid
            text: name
        }
        RowLayout {
            spacing: 0
            Layout.fillWidth: true
            Layout.fillHeight: true

            Item {
                Layout.fillWidth: true
                IText {
                    anchors.centerIn: parent
                    renderType: Text.CurveRendering // it's not static and is rapidly updated
                    visible: valid
                    text: input
                }
            }

            IText {
                visible: valid
                text: "→"
            }

            Item {
                Layout.fillWidth: true
                IText {
                    anchors.centerIn: parent
                    renderType: Text.CurveRendering
                    visible: valid
                    text: valid ? eval(input.replace('(', '*(')) : "" // replace for () to work properly in math
                }
            }
        }
    }
}
