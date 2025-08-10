import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.services
import qs.config

IComponent {
    id: root

    property var clipHist: active ? Clip.query(inputCleaned) : []
    property int selectedIndex: -1

    name: "Clipboard"

    prefix: "clip"

    implicitHeight: valid ? layout.height : 0

    process: function () {
        const isValid = clipHist.length > 0;
        const selected = isValid && clipHist[selectedIndex];
        return {
            valid: isValid,
            priority: isValid,
            answer: selected.data || ""
        };
    }

    exec: function () {
        Clip.decodeAndCopy(clipHist[selectedIndex].raw);
    }

    up: function () {
        if (selectedIndex <= 0)
            return true;
        selectedIndex--;
    }
    down: function () {
        if (selectedIndex + 1 > repeater.count - 1)
            return true;
        selectedIndex++;
    }

    onClipHistChanged: {
        selectedIndex = 0;
        flickable.contentY = 0;
        // selectedIndexChanged dont get called somehow
        syncSelectionState();
    }

    onSelectedIndexChanged: {
        syncSelectionState();
        if (selectedIndex < 0 || selectedIndex >= repeater.count)
            return;
        Qt.callLater(() => {
            const i = repeater.itemAt(selectedIndex), t = i.y, b = i.y + i.height, v = flickable.contentY, vb = v + flickable.height, maxY = Math.max(0, flickable.contentHeight - flickable.height);
            const y = t < v ? t : b > vb ? b - flickable.height : v;
            flickable.contentY = Math.max(0, Math.min(maxY, y));
        });
    }

    function syncSelectionState() {
        Qt.callLater(() => {
            // fucking Qt why tf is repeater not ready when this is called
            SelectionState.selected = repeater.itemAt(selectedIndex);
            SelectionState.exec = root.exec;
        });
    }

    IInnerComponent {
        id: layout
        fromParent: false
        width: parent.width
        height: Math.min(innerLayout.height + titleBar.height, Launcher.widgetHeight * 1.5)

        Flickable {
            id: flickable
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            contentWidth: innerLayout.width
            contentHeight: innerLayout.height

            ColumnLayout {
                id: innerLayout
                spacing: 0

                Repeater {
                    id: repeater
                    model: clipHist

                    Item {
                        required property var modelData
                        required property int index
                        Layout.margins: Launcher.innerMargin * 2
                        implicitWidth: item.width
                        implicitHeight: item.height

                        RowLayout {
                            id: item
                            spacing: Launcher.innerMargin * 2

                            IText {
                                text: modelData?.isImage ? "Image" : "Text" || ""
                            }
                            IText {
                                text: modelData?.data || ""
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onPositionChanged: {
                                root.selectedIndex = index;
                            }
                            onExited: {
                                root.selectedIndex = 0;
                            }
                            onPressed: {
                                root.exec();
                            }
                        }
                    }
                }
            }
        }
    }
}
