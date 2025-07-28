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
            visible: valid
            text: name
        }
        RowLayout {
            Layout.fillWidth: true
            IText {
                visible: valid
                text: input
            }
            IText {
                visible: valid
                text: "->"
            }
            IText {
                visible: valid
                text: valid ? eval(input) : ""
            }
        }
    }
}
