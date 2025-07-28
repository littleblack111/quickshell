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
        color: Qt.rgba(Colors.background3.r, Colors.background3.g, Colors.background3.b, Launcher.widgetTitleBgTransparency) // TODO when prioritized, highlight
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
                    elide: Text.ElideLeft
                    width: Math.min(implicitWidth, parent.width - Launcher.innerMargin * 2)
                    clip: true
                    renderType: Text.CurveRendering // it's not static and is rapidly updated
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
                font {
                    pixelSize: Launcher.widgetFontSize
                    bold: true
                }
            }

            Item {
                Layout.fillWidth: true
                IText {
                    anchors.centerIn: parent
                    elide: Text.ElideLeft
                    width: Math.min(implicitWidth, parent.width - Launcher.innerMargin * 2)
                    renderType: Text.CurveRendering
                    visible: valid
                    text: valid ? String(eval(input.replace(/([\d)])\(/g, '$1*(').replace(/\)([\d])/g, ')*$1'))) : "" // replace for () to work properly in math
                    font {
                        pixelSize: Launcher.widgetFontSize
                        bold: true
                    }
                }
            }
        }
    }
}
