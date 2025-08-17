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
    property bool mouseTriggered: false

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
        mouseTriggered = false;
        selectedIndex--;
    }
    down: function () {
        if (selectedIndex + 1 > listView.count - 1)
            return true;
        mouseTriggered = false;
        selectedIndex++;
    }

    onClipHistChanged: {
        mouseTriggered = false;
        selectedIndex = 0;
        listView.positionViewAtBeginning();
        syncSelectionState();
    }

    onSelectedIndexChanged: {
        if (!mouseTriggered && selectedIndex >= 0 && selectedIndex < listView.count) {
            Qt.callLater(() => {
                listView.positionViewAtIndex(selectedIndex, ListView.Contain);
            });
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

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

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
                    width: item.implicitWidth + Launcher.innerMargin * 4
                    height: item.height + Launcher.innerMargin * 4

                    Row {
                        id: item
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.margins: Launcher.innerMargin * 2
                        spacing: Launcher.innerMargin * 2

                        IconImage {
                            scale: index === root.selectedIndex ? 1.01 : 0.9
                            source: modelData?.appIcon
                            implicitSize: parent.height

                            Behavior on scale {
                                ISpringAnimation {}
                            }
                        }

                        Column {
                            Loader {
                                sourceComponent: modelData?.type === "image" ? img : text
                                readonly property Component text: IText {
                                    text: modelData?.data || ""
                                    color: index === root.selectedIndex ? Colors.foreground1 : Colors.foreground2
                                    font.pixelSize: Launcher.widgetFontSize
                                }
                                readonly property Component img: Image {
                                    source: modelData?.data || ""
                                }
                            }
                            Row {
                                spacing: Launcher.innerMargin
                                property string sinceWhen: TimeDate.sinceWhen(modelData?.timestamp) || ""
                                IText {
                                    text: modelData.type
                                    color: index === root.selectedIndex ? Colors.foreground2 : Colors.foreground3
                                    font.pixelSize: Launcher.widgetFontSize / 1.35
                                }
                                IText {
                                    visible: parent.sinceWhen
                                    text: '·'
                                    color: index === root.selectedIndex ? Colors.foreground2 : Colors.foreground3
                                    font.pixelSize: Launcher.widgetFontSize / 1.35
                                }
                                IText {
                                    text: parent.sinceWhen || ""
                                    color: index === root.selectedIndex ? Colors.foreground2 : Colors.foreground3
                                    font.pixelSize: Launcher.widgetFontSize / 1.35
                                }
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onPositionChanged: {
                            root.mouseTriggered = true;
                            root.selectedIndex = index;
                        }
                        onExited: {
                            root.mouseTriggered = true;
                            root.selectedIndex = 0;
                        }
                        onPressed: {
                            root.exec();
                        }
                    }
                }
            }

            Flickable {
                id: preview
                clip: true
                Layout.fillWidth: true
                Layout.fillHeight: true

                contentWidth: loader.item.width
                contentHeight: loader.item.height
                flickableDirection: Flickable.VerticalFlick
                boundsBehavior: Flickable.StopAtBounds

                Loader {
                    id: loader
                    sourceComponent: clipHist[selectedIndex]?.type === "image" ? img : text
                    property Component text: TextEdit {
                        id: textEdit
                        width: preview.width
                        color: Colors.foreground1
                        selectionColor: Colors.background3
                        text: clipHist[selectedIndex]?.decoded.trim() || ""
                    }
                    property Component img: Image {
                        id: image
                        width: preview.width
                        height: preview.height
                        source: clipHist[selectedIndex]?.image || ""
                        fillMode: Image.PreserveAspectFit
                    }
                }
            }
        }
    }
}
