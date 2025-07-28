import Quickshell
import QtQuick
import QtQuick.Layouts

import "widgets"
import qs.components
import qs.config

ILauncher {
    name: "quickshell::launcher::launcher"
    IRect {
        // TODO: move to IInnerLauncher for other launchers
        anchors.fill: parent

        border {
            width: Launcher.borderWidth
        }
        color: Qt.rgba(Colors.background3.r, Colors.background3.g, Colors.background3.b, Bar.bgTransparency)
        width: parent.width
        radius: Launcher.borderRadius

        IRect {
            id: root
            property string input

            anchors {
                fill: parent
                topMargin: Launcher.innerMargin
                leftMargin: Launcher.innerMargin * 2
                rightMargin: Launcher.innerMargin * 2
            }

            color: "transparent"

            RowLayout {
                anchors {
                    top: parent.top
                    margins: Launcher.innerMargin
                }
                spacing: Launcher.innerMargin * 2
                Icon {
                    text: ""
                }
                TextInput {
                    id: textInput
                    Layout.fillWidth: true

                    color: Colors.foreground1

                    clip: true
                    focus: true
                    renderType: Text.CurveRendering
                    antialiasing: true
                    smooth: true
                    font {
                        pixelSize: Style.font.size.largerr
                        family: Style.font.family.sans
                    }

                    // onAccepted: {
                    //     // This signal is emitted when the user presses Enter/Return
                    //     console.log("Text accepted:", myTextInput.text);
                    // }
                    onTextChanged: {
                        root.input = text;
                    }
                }
            }

            Math {
                anchors.verticalCenter: parent.verticalCenter

                input: input
            }
        }
    }
    implicitWidth: Launcher.width
    implicitHeight: Launcher.height
}
