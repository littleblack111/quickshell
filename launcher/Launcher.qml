import Quickshell
import QtQuick
import QtQuick.Layouts

import "components"
import qs.components
import qs.config

// TODO: currently, we're relying on the compositor to provide the animation which ig is fine, but we should use our own in the future, however it might look weird combined with the compositors's
ILauncher {
    id: launcher
    name: "quickshell::launcher::launcher"

    anchors.top: true
    margins.top: Launcher.topMargin
    aboveWindows: true
    exclusionMode: ExclusionMode.Ignore

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
                        ISpringAnimation {}
                        // NumberAnimation {
                        //     duration: General.animationDuration / 2
                        // }
                    }
                }

                spacing: Launcher.innerMargin * 2

                Icon {
                    text: ""
                }

                RowLayout {
                    spacing: 0
                    TextInput {
                        id: textInput
                        Layout.fillHeight: true
                        // Layout.fillWidth: true
                        color: Colors.foreground1
                        text: ActiveComponent?.input || ""
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
                        // move to different file if we have more textinput
                        cursorDelegate: IRect {
                            id: cursor
                            color: Colors.cursor
                            // width: 1.5
                            width: 2
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
                        onTextChanged: {
                            ActiveComponent.input = textInput.text; // TODO: find ways to optimize this, like how i was using an alias
                        }
                        onCursorPositionChanged: {
                            ActiveComponent.cursorPosition = textInput.cursorPosition;
                        }
                        // onActiveFocusChanged: {
                        //     parentLoader.active = activeFocus;
                        // }
                        onAccepted: {
                            ActiveComponent?.exec(); // TODO: kde like waiting animation for app to launch
                            parentLoader.active = false;
                            textInput.text = "";
                        }
                    }
                    IRect {
                        Layout.fillHeight: true
                        Layout.preferredWidth: text.width
                        radius: Launcher.predictiveCompletionRadius
                        color: Qt.rgba(Colors.background2.r, Colors.background2.g, Colors.background2.b, Launcher.widgetBgTransparency)
                        IText {
                            id: text
                            // animate: true // too jumpy
                            visible: ActiveComponent?.priorities[0] || false
                            color: Colors.foreground3
                            renderType: Text.CurveRendering
                            antialiasing: true
                            smooth: true
                            font {
                                pixelSize: Style.font.size.large
                                family: Style.font.family.sans
                                wordSpacing: 5
                            }
                            text: ActiveComponent?.priorities[0]?.predictiveCompletion || ""
                        }
                        Behavior on Layout.preferredWidth {
                            ISpringAnimation {}
                            // NumberAnimation {
                            //     duration: General.animationDuration / 5
                            // }
                        }
                    }
                    Item {
                        Layout.fillWidth: true
                    }
                    Loader {
                        active: ActiveComponent?.priorities[0]?.priority || false // .priority should always be true if it's in priorities
                        sourceComponent: ActiveComponent?.priorities[0]?.preview
                    }
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

                Repeater {
                    model: Launcher.widgets
                    delegate: Loader {
                        active: true
                        sourceComponent: modelData
                        Component.onCompleted: {
                            ActiveComponent.widgets[index] = item;
                            // FIXME: prev predictiveCompletion still exists here
                            // workaround atm: just clear it or preserve the text manually
                        }
                    }
                }
            }
        }

        // not Keys.onPressed because textinput will steal it
        Shortcut {
            sequence: "Ctrl+H"
            context: Qt.ApplicationShortcut
            onActivated: {
                const item = ActiveComponent?.priorities[0];
                if (!item)
                    return;
                item.left();
            }
        }

        Shortcut {
            sequence: "Ctrl+J"
            context: Qt.ApplicationShortcut
            onActivated: {
                const item = ActiveComponent?.priorities[0];
                if (!item)
                    return;
                item.down();
            }
        }

        Shortcut {
            sequence: "Ctrl+K"
            context: Qt.ApplicationShortcut
            onActivated: {
                const item = ActiveComponent?.priorities[0];
                if (!item)
                    return;
                item.up();
            }
        }

        Shortcut {
            sequence: "Ctrl+L"
            context: Qt.ApplicationShortcut
            onActivated: {
                const item = ActiveComponent?.priorities[0];
                if (!item)
                    return;
                item.right();
            }
        }

        Shortcut {
            sequence: "Escape"
            context: Qt.ApplicationShortcut
            onActivated: parentLoader.active = false
        }

        Shortcut {
            sequence: "Down"
            context: Qt.ApplicationShortcut
            onActivated: {
                const item = ActiveComponent?.priorities[0];
                item?.down();
            }
        }

        Shortcut {
            sequence: "Up"
            context: Qt.ApplicationShortcut
            onActivated: {
                const item = ActiveComponent?.priorities[0];
                item?.up();
            }
        }

        Shortcut {
            sequence: "PageDown"
            context: Qt.ApplicationShortcut
            onActivated: {
                const item = ActiveComponent?.priorities[0];
                item?.pageDown();
            }
        }

        Shortcut {
            sequence: "PageUp"
            context: Qt.ApplicationShortcut
            onActivated: {
                const item = ActiveComponent?.priorities[0];
                item?.pageUp();
            }
        }

        Shortcut {
            sequence: "Home"
            context: Qt.ApplicationShortcut
            onActivated: {
                const item = ActiveComponent?.priorities[0];
                item?.home();
            }
        }

        Shortcut {
            sequence: "End"
            context: Qt.ApplicationShortcut
            onActivated: {
                const item = ActiveComponent?.priorities[0];
                item?.end();
            }
        }
    }

    implicitWidth: container.width
    implicitHeight: container.height
}
