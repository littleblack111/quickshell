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

    onValidChanged: {
        if (valid)
            return;

        aspell = [];
        proc.running = false;
        selectedIndex = -1;
        return;
    }

    onAspellChanged: {
        selectedIndex = aspell.length > 0 ? 0 : -1;
        // selectedIndexChanged dont get called somehow
        syncSelectionState();
        if (loader.item && loader.item.flickable) {
            loader.item.flickable.contentY = 0;
        }
    }

    onSelectedIndexChanged: {
        syncSelectionState();
        if (!loader.repeater || !loader.item || !loader.item.flickable)
            return;
        if (selectedIndex < 0 || selectedIndex >= loader.repeater.count)
            return;
        Qt.callLater(() => {
            const flickable = loader.item.flickable;
            const i = loader.repeater.itemAt(selectedIndex);
            if (!i)
                return;
            const t = i.y;
            const b = i.y + i.height;
            const v = flickable.contentY;
            const vb = v + flickable.height;
            const maxY = Math.max(0, flickable.contentHeight - flickable.height);
            const y = t < v ? t : b > vb ? b - flickable.height : v;
            flickable.contentY = Math.max(0, Math.min(maxY, y));
        });
    }

    process: function () {
        proc.running = true;

        const isValid = selectedIndex >= 0 && aspell.length > 0;
        const selected = isValid ? aspell[selectedIndex] : "n";
        const answer = selected === "*" ? word : selected;

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
        if (selectedIndex >= 0)
            if (aspell[selectedIndex] !== "*")
                Clip.copy(aspell[selectedIndex]);
            else
                Clip.copy(word);
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
                Item {
                    property alias flickable: flickable

                    Flickable {
                        id: flickable
                        anchors.fill: parent
                        clip: true
                        contentWidth: grid.width
                        contentHeight: grid.height

                        GridLayout {
                            id: grid
                            width: flickable.width
                            columns: Math.max(1, Math.floor(width / Math.max(1, Math.round(Launcher.widgetFontSize * 6))))
                            rowSpacing: Launcher.innerMargin
                            columnSpacing: Launcher.innerMargin

                            Repeater {
                                id: repeater
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
                                        elide: Text.ElideRight
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

                                Component.onCompleted: {
                                    loader.repeater = repeater;
                                }
                            }
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
        property bool found: false
        stdout: SplitParser {
            onRead: data => {
                if (data.startsWith("&")) {
                    proc.found = true;
                    aspell = data.split(/\W+/).filter(word => /^[A-Za-z]+$/.test(word)).slice(1);
                } else if (data.startsWith("*"))
                    aspell = ["*"];
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
