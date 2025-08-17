import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.services
import qs.config

IComponent {
    id: root

    property var emojis: Emoji.query(input)
    property int selectedIndex: -1

    property int cols: Math.max(1, Math.floor(innerLoader.width / Math.max(1, Math.round(Launcher.widgetFontSize * 4))))
    property int cellWidth: Math.floor(innerLoader.width / cols)
    property int cellHeight: Math.ceil(Launcher.widgetFontSize * 2) + Launcher.innerMargin * 2

    name: "Emoji"
    prefix: name.toLowerCase() + " "

    onInputChanged: {
        Qt.callLater(() => {
            selectedIndex = emojis.length > 0 ? 0 : -1;
            syncSelectionState();
            if (loader.item && loader.item.flickable)
                loader.item.flickable.contentY = 0;
        });
    }

    onSelectedIndexChanged: {
        if (!loader.view || !loader.item || !loader.item.flickable)
            return;
        if (selectedIndex < 0 || selectedIndex >= loader.view.count)
            return;
        Qt.callLater(() => {
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
        if (!loader.view)
            return;
        Qt.callLater(() => state.selected = loader.view.currentItem);
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

                            IRect {
                                anchors.fill: parent
                                color: Qt.rgba(Colors.background2.r, Colors.background2.g, Colors.background2.b, Launcher.widgetBgTransparency)
                                radius: Launcher.widgetRadius

                                Column {
                                    id: chipContent
                                    anchors.centerIn: parent
                                    spacing: 2

                                    IText {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: modelData.emoji
                                        font.pixelSize: Launcher.widgetFontSize * 1.2
                                    }
                                    IText {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: modelData.name
                                        font.pixelSize: Launcher.widgetFontSize * 0.7
                                        color: Qt.rgba(Colors.foreground3.r, Colors.foreground3.g, Colors.foreground3.b, 0.7)
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
                        }

                        Component.onCompleted: loader.view = grid
                    }
                }
            }
        }
    }
}
