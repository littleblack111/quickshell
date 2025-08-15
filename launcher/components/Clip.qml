import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.services
import qs.config

IComponent {
    id: root

    property var clipHist: Clip.query(inputCleaned)
    property int selectedIndex: -1

    name: "Clipboard"

    prefix: "clip"

    implicitHeight: valid ? layout.height : 0

    process: function () {
        const isValid = clipHist.length > 0;
        return {
            valid: isValid,
            priority: isValid
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
        if (selectedIndex + 1 > listView.count - 1)
            return true;
        selectedIndex++;
    }

    onClipHistChanged: {
        selectedIndex = 0;
        listView.positionViewAtBeginning();
        syncSelectionState();
    }

    onSelectedIndexChanged: {
        if (selectedIndex >= 0 && selectedIndex < listView.count) {
            listView.positionViewAtIndex(selectedIndex, ListView.Contain);
        }
        syncSelectionState();
    }

    syncSelectionState: function () {
        Qt.callLater(() => {
            let selectedItem = listView.itemAtIndex(selectedIndex);
            if (!selectedItem && selectedIndex >= 0 && selectedIndex < listView.count) {
                // Item not visible, force it to be created
                listView.positionViewAtIndex(selectedIndex, ListView.Contain);
                selectedItem = listView.itemAtIndex(selectedIndex);
            }
            state.selected = selectedItem;
        });
    }

    IInnerComponent {
        id: layout
        fromParent: false
        width: parent.width
        height: Math.min(listView.contentHeight + titleBar.height, Launcher.widgetHeight * 1.5)

        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: clipHist
            spacing: 0

            delegate: Item {
                required property var modelData
                required property int index
                width: childrenRect.width + Launcher.innerMargin * 2
                height: item.height + Launcher.innerMargin * 4

                Row {
                    id: item
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.margins: Launcher.innerMargin * 2
                    spacing: Launcher.innerMargin * 2

                    IconImage {
                        source: modelData?.appIcon
                        implicitSize: parent.height
                    }

                    Column {
                        IText {
                            text: modelData?.data || ""
                            font.pixelSize: Style.font.size.largerr
                        }
                        Row {
                            spacing: Launcher.innerMargin
                            IText {
                                text: modelData.isImage ? "Image" : "Text"
                                color: Colors.foreground3
                                font.pixelSize: Style.font.size.normal
                            }
                            IText {
                                text: TimeDate.sinceWhen(modelData?.timestamp) || ""
                                color: Colors.foreground3
                                font.pixelSize: Style.font.size.normal
                            }
                        }
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
