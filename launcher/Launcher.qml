import Quickshell
import QtQuick
import QtQuick.Layouts

import "components"
import qs.components
import qs.config

ILauncher {
    id: launcher
    name: "quickshell::launcher::launcher"

    IRect {
        id: container
        color: Qt.rgba(Colors.background3.r, Colors.background3.g, Colors.background3.b, Bar.bgTransparency)
        radius: Launcher.borderRadius

        width: Math.max(root.width, Launcher.defaultWidth) + Launcher.innerMargin
        height: root.height

        IRect {
            id: root
            property alias input: textInput.text

            height: searchBar.height + widgets.height + textInput.height / 2 // * 1.5
            width: Math.max(widgets.implicitWidth, Launcher.defaultWidth)

            anchors.centerIn: parent

            color: "transparent"

            RowLayout {
                id: searchBar
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    leftMargin: Launcher.innerMargin
                    rightMargin: Launcher.innerMargin
                    // try to center it when no widgets are present
                    topMargin: widgets.height === 0 ? parent.height / 2 - textInput.height / 2 : Launcher.innerMargin // textInput or Icon is the height of this

                    Behavior on topMargin {
                        NumberAnimation {
                            duration: General.animationDuration / 2
                        }
                    }
                }

                spacing: Launcher.innerMargin * 2

                Icon {
                    text: ""
                }

                TextInput {
                    id: textInput
                    opacity: 1
                    // move to different file if we have more textinput
                    cursorDelegate: IRect {
                        id: cursor
                        color: Colors.cursor
                        width: 1.5
                        height: 1
                        // blinking animation
                        SequentialAnimation {
                            running: true
                            loops: Animation.Infinite
                            PauseAnimation {
                                duration: 500
                            }
                            ParallelAnimation {
                                PropertyAnimation {
                                    target: cursor
                                    property: "opacity"
                                    to: 0
                                    duration: General.animationDuration / 5
                                }
                                PropertyAnimation {
                                    target: cursor
                                    property: "scale"
                                    to: 0
                                    duration: General.animationDuration / 5
                                }
                            }
                            PauseAnimation {
                                duration: 500
                            }
                            ParallelAnimation {
                                PropertyAnimation {
                                    target: cursor
                                    property: "opacity"
                                    to: 1
                                    duration: General.animationDuration / 5
                                }
                                PropertyAnimation {
                                    target: cursor
                                    property: "scale"
                                    to: 1
                                    duration: General.animationDuration / 5
                                }
                            }
                        }
                    }
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
                    // onActiveFocusChanged: {
                    //     parentLoader.active = activeFocus;
                    // }
                    onTextChanged: {
                        root.input = text;
                    }
                }
                Loader {
                    active: app.priority
                    sourceComponent: app.preview
                }
            }

            ColumnLayout {
                id: widgets
                anchors {
                    top: searchBar.bottom
                    left: parent.left
                    right: parent.right
                    topMargin: Launcher.innerMargin * 1.5 // gap in between, maybe seperator FIXME
                }

                Calc {
                    id: calc
                    cursorPosition: textInput.cursorPosition
                    Layout.rightMargin: Launcher.innerMargin
                    Layout.leftMargin: Launcher.innerMargin
                    input: root.input
                }
                App {
                    id: app
                    Layout.rightMargin: Launcher.innerMargin
                    Layout.leftMargin: Launcher.innerMargin
                    input: root.input
                }
            }
        }

        Keys.onPressed: event => {
            if (event.key === Qt.Key_Escape)
                parentLoader.active = false;
        }
    }

    // MouseArea {
    //     z: -1 // otherwise children mouseareas won't work
    //     anchors.fill: parent
    //     hoverEnabled: true
    //     // onExited: {
    //     //     parentLoader.active = false;
    //     // }
    // }

    implicitWidth: container.width
    implicitHeight: container.height
}
