import Quickshell
import QtQuick
import QtQuick.Layouts

import "widgets"
import qs.components
import qs.config

ILauncher {
    id: launcher
    required property var parentLoader
    name: "quickshell::launcher::launcher"
    IRect {
        // TODO: move to IInnerLauncher for other launchers
        anchors.fill: parent

        border {
            width: Launcher.borderWidth
            color: Colors.e2
        }
        color: Qt.rgba(Colors.background3.r, Colors.background3.g, Colors.background3.b, Bar.bgTransparency)
        width: parent.width
        radius: Launcher.borderRadius

        IRect {
            id: root
            property string input

            anchors {
                fill: parent
                topMargin: Launcher.innerMargin * 1.5
                leftMargin: Launcher.innerMargin * 2.5
                rightMargin: Launcher.innerMargin * 2.5
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
                        pixelSize: Style.font.size.large
                        family: Style.font.family.sans
                        wordSpacing: 5
                    }
                    onActiveFocusChanged: {
                        parentLoader.active = activeFocus;
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

            Calc {
                anchors.verticalCenter: parent.verticalCenter

                input: parent.input
            }
            // ColumnLayout {
            //     property list<IWidget> widgets: Launcher.widgets
            //
            //     function updateAndFilter() {
            //         // Update input for all widgets
            //         for (let i = 0; i < widgets.length; i++) {
            //             widgets[i].input = root.input;
            //         }
            //
            //         // Filter and sort
            //         let filtered = [];
            //         for (let i = 0; i < widgets.length; i++) {
            //             if (widgets[i].valid) {
            //                 filtered.push({
            //                     widget: widgets[i],
            //                     priority: widgets[i].priority,
            //                     index: i
            //                 });
            //             }
            //         }
            //
            //         filtered.sort((a, b) => {
            //             if (a.priority !== b.priority)
            //                 return b.priority - a.priority;
            //             return a.index - b.index;
            //         });
            //
            //         return filtered.map(item => item.widget);
            //     }
            //
            //     Repeater {
            //         model: parent.updateAndFilter()
            //         delegate: modelData // Direct widget reference
            //     }
            // }
        }
        Keys.onPressed: event => {
            if (event.key === Qt.Key_Escape)
                parentLoader.active = false;
        }
    }
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onExited: {
            parentLoader.active = false;
        }
    }
    implicitWidth: Launcher.width
    implicitHeight: Launcher.height
}
