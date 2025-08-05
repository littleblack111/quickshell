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
    property string word: inputCleaned.slice(prefix.length)
    property int selectedIndex: -1

    name: "Spell"
    prefix: name.toLowerCase() + " "

    onInputCleanedChanged: {
        if (!inputCleaned.startsWith(prefix) || !inputCleaned.slice(prefix.length)) {
            aspell = [];
            proc.running = false;
            selectedIndex = -1;
            return;
        }
        Qt.callLater(() => {
            proc.running = true;
        });
    }

    onAspellChanged: {
        selectedIndex = aspell.length > 0 ? 0 : -1;
    }

    onSelectedIndexChanged: {
        syncSelectionState();
    }

    process: function () {
        const answer = selectedIndex >= 0 ? aspell[selectedIndex] : "";
        const isValid = answer && answer.length > 0;
        return {
            valid: isValid,
            priority: isValid,
            answer: isValid ? answer : "",
            predictiveCompletion: isValid ? answer.slice(word.length) : ""
        };
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
        if (selectedIndex >= 0 && aspell[selectedIndex] !== "*") {
            Clip.copy(aspell[selectedIndex]);
        }
    }

    function syncSelectionState() {
        if (!loader.repeater)
            return;
        Qt.callLater(() => {
            SelectionState.selected = loader.repeater.itemAt(selectedIndex);
            SelectionState.exec = root.exec;
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
            property var repeater: null
            readonly property Component show: Component {
                GridLayout {
                    id: grid
                    columns: Math.max(1, Math.floor(width / Math.max(1, Math.round(Launcher.widgetFontSize * 6))))
                    rowSpacing: Launcher.innerMargin
                    columnSpacing: Launcher.innerMargin
                    Layout.fillWidth: true

                    Repeater {
                        id: repeater
                        Layout.fillWidth: true
                        model: aspell

                        IRect {
                            Layout.fillWidth: true
                            Layout.preferredWidth: Math.max(chipContent.implicitWidth + Launcher.innerMargin * 2, Math.floor(grid.width / grid.columns) - grid.columnSpacing)
                            Layout.preferredHeight: chipContent.implicitHeight + Launcher.innerMargin * 2
                            color: Qt.rgba(Colors.background2.r, Colors.background2.g, Colors.background2.b, Launcher.widgetBgTransparency)
                            radius: Launcher.widgetRadius

                            IText {
                                id: chipContent
                                anchors.centerIn: parent
                                text: modelData
                                font.pixelSize: Launcher.widgetFontSize
                                anchors.horizontalCenter: parent.horizontalCenter
                                elide: Text.ElideRight
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onPositionChanged: {
                                    root.selectedIndex = index;
                                }
                                onPressed: {
                                    root.exec();
                                }
                            }
                        }
                        Component.onCompleted: {
                            loader.repeater = repeater;
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
        command: ["sh", "-c", "echo " + word + " | aspell -a"]
        onStarted: {
            aspell = [];
        }
        stdout: SplitParser {
            onRead: data => {
                if (data.startsWith("&"))
                    aspell = data.split(/\W+/).filter(word => /^[A-Za-z]+$/.test(word)).slice(1);
                else if (data.startsWith("*"))
                    aspell = ["*"];
            }
        }
    }
}
