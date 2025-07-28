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
            topMargin: Launcher.innerMargin
            bottomMargin: Launcher.innerMargin
            leftMargin: Launcher.innerMargin
            rightMargin: Launcher.innerMargin
        }
        IRect {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.minimumHeight: childrenRect.height
            Layout.alignment: Qt.AlignTop | Qt.AlignLeft
            Layout.topMargin: Launcher.innerMargin * -1
            Layout.leftMargin: Launcher.innerMargin * -1
            Layout.rightMargin: Launcher.innerMargin * -1
            topLeftRadius: Launcher.widgetRadius
            topRightRadius: Launcher.widgetRadius
            color: Qt.rgba(Colors.background3.r, Colors.background3.g, Colors.background3.b, Launcher.bgTransparency) // TODO when prioritized, highlight
            IText {
                anchors {
                    top: parent.top
                    left: parent.left
                    leftMargin: Launcher.innerMargin
                }
                font.pixelSize: Launcher.widgetFontSize
                visible: valid
                text: name
            }
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
                    text: valid ? eval(input.replace(/([\d)])\(/g, '$1*(').replace(/\)([\d])/g, ')*$1')) : "" // replace for () to work properly in math
                }
            }
        }
    }
}
