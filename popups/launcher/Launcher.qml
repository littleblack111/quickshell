import Quickshell
import QtQuick
import QtQuick.Layouts

import "components"
import qs.components
import qs.config
import qs.services

// TODO: currently, we're relying on the compositor to provide the animation which ig is fine, but we should use our own in the future, however it might look weird combined with the compositors's
ILauncher {
    id: launcher

    property list<Component> widgetItems: Launcher.widgets
    property var state: SelectionState

    name: "quickshell::launcher::launcher"

    Connections {
        target: parentLoader
        function onActiveChanged() {
            if (!parentLoader.active && launcher.state) {
                launcher.state.selected = null;
            }
        }
    }

    anchors.top: true
    margins.top: Launcher.topMargin
    aboveWindows: true
    exclusionMode: ExclusionMode.Ignore

    IRect {
        id: container
        property var selection: launcher.state?.selected || null
        property var mappedSelection: selection?.mapToItem(null, 0, 0)
        onMappedSelectionChanged: {
            // launcher.state?.selected may be slow.. smh qt
            // my guess is mapToItem is called when its not finished doing whatever it needs to do,
            // so it doesnt get the right vars, but it doesn't update after since it already triggered it
            selectionSync.running = true;
        }
        Timer {
            id: selectionSync
            running: false
            repeat: false
            // sync w/ IComponent y animation duration
            interval: General.animationDuration / 4
            onTriggered: {
                parent.mappedSelection = launcher.state?.selected?.mapToItem(null, 0, 0);
            }
        }

        IRect {
            id: activeRect
            visible: parent.mappedSelection || false
            y: parent.mappedSelection?.y || 0
            x: parent.mappedSelection?.x || 0
            implicitWidth: launcher.state?.selected?.width || 0
            implicitHeight: launcher.state?.selected?.height || 0
            radius: Launcher.borderRadius
            color: Qt.rgba(Colors.background1.r, Colors.background1.g, Colors.background1.b, Launcher.bgTransparency)
            Behavior on x {
                ISpringAnimation {}
            }
            Behavior on y {
                ISpringAnimation {}
            }
            Behavior on implicitWidth {
                ISpringAnimation {}
            }
            Behavior on height {
                ISpringAnimation {}
            }
        }
        color: Qt.rgba(Colors.background3.r, Colors.background3.g, Colors.background3.b, Launcher.bgTransparency)
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
                    topMargin: widgets.height === Launcher.widgets.length * 5 - 5 ? parent.height / 2 - textInput.height / 2 : Launcher.innerMargin // textInput or Icon is the height of this

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
                        property bool pendingUpdate: false
                        Keys.onPressed: event => {
                            if (event.key === Qt.Key_End || event.key === Qt.Key_Home) {
                                if (event.key === Qt.Key_End) {
                                    endShortcut.activated();
                                } else if (event.key === Qt.Key_Home) {
                                    homeShortcut.activated();
                                }
                                event.accepted = true;
                            }
                        }

                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.maximumWidth: implicitWidth

                        color: Colors.foreground1
                        selectionColor: Colors.background3

                        text: launcher.state?.input || ""
                        clip: true
                        focus: true

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
                            if (launcher.state.input !== textInput.text)
                                pendingUpdate = true;
                            Qt.callLater(() => {
                                if (pendingUpdate) {
                                    pendingUpdate = false;
                                    launcher.state.input = textInput.text; // TODO: find ways to optimize this, like how i was using an alias
                                }
                            });
                        }
                        onCursorPositionChanged: {
                            launcher.state.cursorPosition = textInput.cursorPosition;
                        }
                        // onActiveFocusChanged: {
                        //     parentLoader.active = activeFocus;
                        // }
                        onAccepted: {
                            const selectedComponent = launcher.state?.priorities[launcher.state.selectedPriority];
                            const selectedData = selectedComponent?.getSelectedData ? selectedComponent.getSelectedData() : null;
                            
                            History.trackLauncherAction(textInput.text, selectedComponent?.name || "", selectedData);
                            
                            selectedComponent?._exec();
                            parentLoader.active = false;
                            textInput.text = "";
                        }
                        Component.onCompleted: {
                            selectAll();
                        }
                    }
                    IRect {
                        opacity: launcher.state?.priorities[0]?.predictiveCompletion ? 1 : 0
                        Layout.fillHeight: true
                        Layout.preferredWidth: text.width
                        radius: Launcher.predictiveCompletionRadius
                        color: Qt.rgba(Colors.background2.r, Colors.background2.g, Colors.background2.b, Launcher.widgetBgTransparency)
                        IText {
                            id: text
                            // animate: true // too jumpy
                            color: Colors.foreground3
                            renderType: Text.CurveRendering
                            antialiasing: true
                            smooth: true
                            font {
                                pixelSize: Style.font.size.large
                                family: Style.font.family.sans
                                wordSpacing: 5
                            }
                            text: launcher.state?.priorities[0]?.predictiveCompletion || ""
                        }
                        Behavior on Layout.preferredWidth {
                            ISpringAnimation {}
                            // NumberAnimation {
                            //     duration: General.animationDuration / 5
                            // }
                        }
                        Behavior on opacity {
                            NumberAnimation {
                                duration: General.animationDuration / 2
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }
                    Item {
                        Layout.fillWidth: true
                    }
                    Loader {
                        active: launcher.state?.priorities[0]?.priority || false // .priority should always be true if it's in priorities
                        sourceComponent: launcher.state?.priorities[0]?.preview
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
                    model: launcher.widgetItems
                    delegate: Loader {
                        active: true
                        sourceComponent: modelData
                        asynchronous: true
                        onLoaded: {
                            launcher.state.widgets[index] = item;
                            // FIXME: prev predictiveCompletion still exists here
                            // workaround atm: just clear it or preserve the text manually
                        }
                        Connections {
                            target: item
                            ignoreUnknownSignals: true
                            function onClose() {
                                parentLoader.active = false;
                            }
                        }
                    }
                }
            }
        }

        // not Keys.onPressed because textinput will steal it
        Shortcut {
            sequence: "Escape"
            context: Qt.ApplicationShortcut
            onActivated: parentLoader.active = false
        }

        Shortcut {
            sequence: "Ctrl+H"
            context: Qt.ApplicationShortcut
            onActivated: changePos(1)
        }

        Shortcut {
            sequence: "Ctrl+J"
            context: Qt.ApplicationShortcut
            onActivated: changePos(-2)
        }

        Shortcut {
            sequence: "Ctrl+K"
            context: Qt.ApplicationShortcut
            onActivated: changePos(2)
        }

        Shortcut {
            sequence: "Ctrl+L"
            context: Qt.ApplicationShortcut
            onActivated: changePos(-1)
        }

        Shortcut {
            sequence: "Down"
            context: Qt.ApplicationShortcut
            onActivated: changePos(-2)
        }

        Shortcut {
            sequence: "Up"
            context: Qt.ApplicationShortcut
            onActivated: changePos(2)
        }

        Shortcut {
            sequence: "PgDown"
            context: Qt.ApplicationShortcut
            onActivated: changePos(-20)
        }

        Shortcut {
            sequence: "PgUp"
            context: Qt.ApplicationShortcut
            onActivated: changePos(20)
        }

        Shortcut {
            id: homeShortcut
            sequence: "Home"
            context: Qt.ApplicationShortcut
            onActivated: changePos(200)
        }

        Shortcut {
            id: endShortcut
            sequence: StandardKey.MoveToEndOfDocument
            context: Qt.ApplicationShortcut
            onActivated: changePos(-200)
        }
    }
    // 1 = left
    // -1 = right
    // 2 = up
    // -2 = down
    function changePos(direction: int) {
        const item = launcher.state?.priorities[launcher.state.selectedPriority] || null;
        if (!item)
            return;

        let set = 0;

        switch (direction) {
        case 1:
            if (item.prev())
                set = -1;
            break;
        case -1:
            if (item.next())
                set = 1;
            break;
        case 2:
            if (item.up())
                set = -1;
            break;
        case -2:
            if (item.down())
                set = 1;
            break;
        case 20:
            if (item.pgup())
                set = -1;
            break;
        case -20:
            if (item.pgdn())
                set = 1;
            break;
        case 200:
            if (item.home())
                set = -1;
            break;
        case -200:
            if (item.end())
                set = 1;
            break;
        }

        switch (set) {
        case 1:
            if (launcher.state.selectedPriority < launcher.state.priorities.length - 1)
                launcher.state.selectedPriority++;
            break;
        case -1:
            if (launcher.state.selectedPriority > 0)
                launcher.state.selectedPriority--;
            break;
        }

        selectionSync.running = true;
    }

    implicitWidth: container.width
    implicitHeight: container.height
}
