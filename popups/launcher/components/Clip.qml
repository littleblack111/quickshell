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
    home: function () {
        if (selectedIndex <= 0)
            return true;
        selectedIndex = 0;
    }
    end: function () {
        if (selectedIndex + 1 > listView.count - 1)
            return true;
        selectedIndex = listView.count - 1;
    }

    onClipHistChanged: {
        if (selectedIndex !== -1) {
            syncSelectionState();
            return;
        }

        selectedIndex = 0;
        syncSelectionState();
    }

    onSelectedIndexChanged: {
        if (selectedIndex >= 0 && selectedIndex < listView.count)
            Qt.callLater(() => {
                listView.positionViewAtIndex(selectedIndex, ListView.Visible);
                syncSelectionState();
                listView.positionViewAtIndex(selectedIndex, ListView.Contain);
            });
    }

    syncSelectionState: function () {
        Qt.callLater(() => {
            if (!isSelectedPriority()) {
                // TODO: fix sometimes
                if (state.selected && state.selected === listView.itemAtIndex(selectedIndex))
                    state.selected = null;

                return;
            }

            if (!root.visible || selectedIndex < 0 || selectedIndex >= listView.count)
                return;

            trySetSelfPriority();
            state.selected = listView.itemAtIndex(selectedIndex);
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
                    width: Math.min(item.implicitWidth + Launcher.innerMargin * 4, listView.width)
                    height: item.height + Launcher.innerMargin * 4

                    Row {
                        id: item
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.margins: Launcher.innerMargin * 2
                        spacing: Launcher.innerMargin * 2
                        clip: true

                        IconImage {
                            scale: isSelectedPriority() && index === root.selectedIndex ? 1.01 : 0.9
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
                                    text: String(modelData?.data || "").substring(0, General.maxClipPreviewChar).replace(/\n/g, " ")
                                    color: isSelectedPriority() && index === selectedIndex ? Colors.foreground1 : Colors.foreground2
                                    font.pixelSize: Launcher.widgetFontSize
                                    font.bold: isSelectedPriority() && index === selectedIndex
                                }
                                readonly property Component img: Image {
                                    source: modelData?.data || ""
                                    height: Launcher.widgetFontSize * 1.3
                                    fillMode: Image.PreserveAspectFit
                                    scale: isSelectedPriority() && index === root.selectedIndex ? 1.01 : 0.9
                                    Behavior on scale {
                                        ISpringAnimation {}
                                    }
                                }
                            }
                            Row {
                                spacing: Launcher.innerMargin
                                property string sinceWhen: TimeDate.sinceWhen(modelData?.timestamp) || ""
                                IText {
                                    text: modelData.type
                                    color: isSelectedPriority() && index === root.selectedIndex ? Colors.foreground2 : Colors.foreground3
                                    font.pixelSize: Launcher.widgetFontSize / 1.35
                                }
                                IText {
                                    visible: parent.sinceWhen
                                    text: '·'
                                    color: isSelectedPriority() && index === root.selectedIndex ? Colors.foreground2 : Colors.foreground3
                                    font.pixelSize: Launcher.widgetFontSize / 1.35
                                }
                                IText {
                                    text: parent.sinceWhen || ""
                                    color: isSelectedPriority() && index === root.selectedIndex ? Colors.foreground2 : Colors.foreground3
                                    font.pixelSize: Launcher.widgetFontSize / 1.35
                                }
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            root.selectedIndex = index;
                        }
                        onPressed: {
                            root._exec();
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
                    asynchronous: true
                    sourceComponent: clipHist[selectedIndex]?.type === "image" ? img : text
                    property Component text: ITextEdit {
                        id: textEdit
                        animate: true
                        readOnly: true
                        wrapMode: TextEdit.Wrap
                        width: preview.width
                        color: Colors.foreground1
                        selectionColor: Colors.background3
                        text: clipHist[selectedIndex]?.decoded || ""
                    }
                    property Component img: Image {
                        id: image
                        asynchronous: true
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
