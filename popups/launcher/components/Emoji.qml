import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.services
import qs.config

IComponent {
    id: root

    property var emojis: active ? Emoji.query(input) : []
    property int selectedIndex: -1

    property int cols: Math.max(1, Math.floor(innerLoader.width / Math.max(1, Math.round(Launcher.widgetFontSize * 4))))
    property int cellWidth: Math.floor(innerLoader.width / cols)
    property int cellHeight: Math.ceil(Launcher.widgetFontSize * 2) + Launcher.innerMargin * 2

    name: "Emoji"
    prefix: name.toLowerCase() + " "

    onEmojisChanged: {
        Qt.callLater(() => {
            if (selectedIndex !== -1) {
                syncSelectionState();
                return;
            }

            selectedIndex = 0;
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
        const isValid = selectedIndex >= 0 && emojis.length > 0;
        const select = isValid ? emojis[selectedIndex] : null;
        return {
            valid: isValid,
            priority: isValid,
            answer: isValid ? select.emoji : ""
        };
    }

    home: function () {
        if (!loader.view.count)
            return true;
        selectedIndex = 0;
    }
    end: function () {
        if (!loader.view.count)
            return true;
        selectedIndex = loader.view.count - 1;
    }
    prev: function () {
        if (selectedIndex <= 0)
            return true;
        selectedIndex--;
    }
    next: function () {
        if (selectedIndex + 1 >= emojis.length)
            return true;
        selectedIndex++;
    }
    up: function () {
        if (selectedIndex - cols < 0)
            return true;
        selectedIndex -= cols;
    }
    down: function () {
        if (selectedIndex + cols >= emojis.length)
            return true;
        selectedIndex += cols;
    }

    exec: function () {
        if (selectedIndex >= 0 && emojis.length > 0)
            Emoji.copy(emojis[selectedIndex].emoji);
    }

    syncSelectionState: function () {
        Qt.callLater(() => {
            if (!loader.view || selectedIndex < 0 || selectedIndex >= loader.view.count || !root.visible)
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
            sourceComponent: show
            property var view: null

            readonly property Component show: Component {
                Item {
                    property alias flickable: grid

                    GridView {
                        id: grid
                        anchors.fill: parent
                        clip: true
                        boundsBehavior: Flickable.StopAtBounds
                        cacheBuffer: cellHeight * 2
                        model: emojis
                        interactive: true
                        flow: GridView.FlowLeftToRight
                        snapMode: GridView.NoSnap

                        cellWidth: root.cellWidth
                        cellHeight: root.cellHeight

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

                                Column {
                                    id: chipContent
                                    anchors.centerIn: parent
                                    spacing: 2

                                    Icon {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: modelData.emoji
                                        font.pixelSize: Launcher.widgetFontSize * 1.2
                                    }
                                    IText {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: modelData.name
                                        font.pixelSize: Launcher.widgetFontSize * 0.7
                                        color: index === selectedIndex ? Colors.foreground1 : Colors.foreground2
                                        elide: Text.ElideRight
                                        width: parent.parent.width - Launcher.innerMargin * 2
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onPositionChanged: root.selectedIndex = index
                                    onPressed: root._exec()
                                }
                            }

                            Behavior on scale {
                                ISpringAnimation {}
                            }
                        }

                        Component.onCompleted: loader.view = grid
                    }
                }
            }
        }
    }
}
