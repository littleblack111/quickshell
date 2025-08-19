import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.services
import qs.config

IComponent {
    id: root

    property list<string> aspell
    property int selectedIndex: -1

    name: "Spell"
    prefix: name.toLowerCase() + ' '

    onValidChanged: {
        if (valid)
            return;

        aspell = [];
        proc.running = false;
        selectedIndex = -1;
        return;
    }

    onAspellChanged: {
        Qt.callLater(() => {
            if (selectedIndex !== -1) {
                syncSelectionState();
                return;
            }
            selectedIndex = aspell.length > 0 ? 0 : -1;
            if (loader.item && loader.item.flickable)
                loader.item.flickable.contentY = 0;
        });
    }

    onSelectedIndexChanged: {
        Qt.callLater(() => {
            if (!loader.view || selectedIndex < 0 || selectedIndex >= loader.view.count)
                return;

            syncSelectionState();
            loader.view.currentIndex = selectedIndex;
            loader.view.positionViewAtIndex(selectedIndex, GridView.Contain);
        });
    }

    process: function () {
        Qt.callLater(() => {
            proc.running = true;
        });

        const isValid = selectedIndex >= 0 && aspell.length > 0;
        const selected = isValid ? aspell[selectedIndex] : "";
        const answer = selected === "*" ? input : selected;

        return {
            valid: isValid,
            priority: isValid,
            answer: answer || "",
            predictiveCompletion: answer?.slice(input.length) || ""
        };
    }

    home: function () {
        if (loader.view.count === 0)
            return true;
        selectedIndex = -1;
        selectedIndex = 0;
    }
    end: function () {
        if (loader.view.count === 0)
            return true;
        selectedIndex = loader.view.count;
        selectedIndex = loader.view.count - 1;
    }

    prev: function () {
        if (selectedIndex <= 0)
            return true;
        selectedIndex--;
    }

    next: function () {
        if (selectedIndex + 1 >= aspell.length)
            return true;
        selectedIndex++;
    }

    up: function () {
        const cols = Math.max(1, Math.floor(innerLoader.width / Math.max(1, Math.round(Launcher.widgetFontSize * 6))));
        if (selectedIndex - cols < 0)
            return true;
        selectedIndex -= cols;
    }

    down: function () {
        const cols = Math.max(1, Math.floor(innerLoader.width / Math.max(1, Math.round(Launcher.widgetFontSize * 6))));
        if (selectedIndex + cols >= aspell.length)
            return true;
        selectedIndex += cols;
    }

    exec: function () {
        if (selectedIndex >= 0)
            if (aspell[selectedIndex] !== "*")
                Clip.copy(aspell[selectedIndex]);
            else
                Clip.copy(input);
    }

    syncSelectionState: function () {
        Qt.callLater(() => {
            if (!loader.view || selectedIndex < 0 || selectedIndex >= loader.view.count)
                return;

            state.selected = loader.view.itemAtIndex(selectedIndex);
        });
    }

    IInnerComponent {
        id: innerLoader
        Loader {
            id: loader
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: parent.height
            sourceComponent: aspell[0] === "*" ? correct : show
            property var view: null

            readonly property Component show: Component {
                Item {
                    property alias flickable: grid

                    GridView {
                        id: grid
                        anchors.fill: parent
                        clip: true
                        boundsBehavior: Flickable.StopAtBounds
                        cacheBuffer: 0
                        model: aspell
                        interactive: true
                        flow: GridView.FlowLeftToRight
                        snapMode: GridView.NoSnap

                        cellWidth: Math.floor(width / Math.max(1, Math.floor(width / Math.max(1, Math.round(Launcher.widgetFontSize * 6)))))
                        cellHeight: Math.ceil(Launcher.widgetFontSize * 1.6) + Launcher.innerMargin * 2

                        delegate: Item {
                            required property var modelData
                            required property int index

                            width: grid.cellWidth
                            height: chipContent.implicitHeight + Launcher.innerMargin * 2
                            scale: index === selectedIndex ? 1.03 : 0.97

                            IRect {
                                anchors.fill: parent
                                color: Qt.rgba(Colors.background2.r, Colors.background2.g, Colors.background2.b, Launcher.widgetBgTransparency)
                                radius: Launcher.widgetRadius

                                IText {
                                    id: chipContent
                                    anchors.centerIn: parent
                                    text: modelData
                                    font.pixelSize: Launcher.widgetFontSize
                                    elide: Text.ElideRight
                                    color: index === selectedIndex ? Colors.foreground1 : Colors.foreground2
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onPositionChanged: {
                                        root.selectedIndex = index;
                                    }
                                    onPressed: {
                                        root._exec();
                                    }
                                }
                            }

                            Behavior on scale {
                                ISpringAnimation {}
                            }
                        }

                        Component.onCompleted: {
                            loader.view = grid;
                        }
                    }
                }
            }

            readonly property Component correct: Component {
                IRect {
                    Layout.fillWidth: true
                    color: Qt.rgba(Colors.background1.r, Colors.background1.g, Colors.background1.b, Launcher.widgetBgTransparency / 4)
                    radius: Launcher.widgetRadius
                    IText {
                        anchors.centerIn: parent
                        text: "Correct"
                        font.pixelSize: Launcher.widgetFontSize
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        }
    }

    Process {
        id: proc
        command: ["sh", "-c", "echo " + input + " | aspell -a"]
        property bool found: false
        stdout: SplitParser {
            onRead: data => {
                if (data.startsWith("&")) {
                    proc.found = true;
                    aspell = data.split(/\W+/).filter(input => /^[A-Za-z]+$/.test(input)).slice(1);
                } else if (data.startsWith("*")) {
                    proc.found = true;
                    aspell = ["*"];
                }
            }
        }
        onStarted: {
            found = false;
        }
        onExited: {
            if (!found)
                aspell = [];
        }
    }
}
