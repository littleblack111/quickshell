import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.services
import qs.config

IComponent {
    id: root

    property list<DesktopEntry> entries: inputCleaned ? AppSearch.fuzzyQuery(inputCleaned) : []
    property int selectedIndex: -1

    name: "Applications"

    implicitHeight: valid ? Math.min(layout.height, Launcher.widgetHeight * 1.5) : 0

    preview: Component {
        IconImage {
            source: Quickshell.iconPath(answer, "image-missing")
            implicitWidth: General.appIconSize
            implicitHeight: General.appIconSize
        }
    }

    property string predictiveCompletion: (processed.valid && entries.length > selectedIndex) ? entries[selectedIndex].name.slice(inputCleaned.length) : ""

    process: function () {
        const isValid = entries.length > 0;
        const first = isValid && entries[0];
        return {
            valid: isValid,
            priority: isValid,
            answer: first ? first.icon : ""
        };
    }

    exec: function () {
        SelectionState.selected.modelData.execute();
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

    onEntriesChanged: {
        selectedIndex = 0;
        // selectedIndexChanged dont get called somehow
        syncSelectionState();
    }

    onSelectedIndexChanged: {
        syncSelectionState();
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
        height: innerLayout.height + titleBar.height

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
                    model: entries

                    Item {
                        required property DesktopEntry modelData
                        required property int index
                        Layout.margins: Launcher.innerMargin * 2
                        implicitWidth: root.width
                        implicitHeight: item.height

                        RowLayout {
                            id: item
                            spacing: Launcher.innerMargin * 2

                            IconImage {
                                source: Quickshell.iconPath(modelData.icon, "image-missing")
                                implicitWidth: General.appIconSize
                                implicitHeight: General.appIconSize
                            }
                            IText {
                                text: modelData.name
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: {
                                root.selectedIndex = index;
                            }
                        }
                    }
                }
            }
        }
    }
}
