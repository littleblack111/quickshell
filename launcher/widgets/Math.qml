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
    IRect {
        height: childrenRect.height
        width: parent.width
        topLeftRadius: Launcher.widgetRadius
        topRightRadius: Launcher.widgetRadius
        color: Qt.rgba(Colors.background3.r, Colors.background3.g, Colors.background3.b, Launcher.bgTransparency) // TODO when prioritized, highlight
        opacity: Launcher.widgetTitleBgTransparency
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
    ColumnLayout {
        anchors {
            fill: parent
            topMargin: Launcher.innerMargin
            bottomMargin: Launcher.innerMargin
            leftMargin: Launcher.innerMargin
            rightMargin: Launcher.innerMargin
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
