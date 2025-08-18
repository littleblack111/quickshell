import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.services
import qs.config

IComponent {
    id: root

    property list<DesktopEntry> entries: active ? AppSearch.query(inputCleaned) : []
    property int selectedIndex: -1
    property bool mouseTriggered: false

    name: "Applications"

    implicitHeight: valid ? layout.height : 0

    preview: Component {
        IconImage {
            source: Quickshell.iconPath(answer, "image-missing")
            implicitWidth: General.appIconSize
            implicitHeight: General.appIconSize
        }
    }

    property string predictiveCompletion: valid ? entries[selectedIndex].name.slice(input.length) : ""

    process: function () {
        const isValid = entries.length > 0;
        const selected = isValid ? entries[selectedIndex] : "";
        return {
            valid: isValid,
            priority: isValid,
            answer: selected ? selected.icon : ""
        };
    }

    exec: function () {
        SelectionState.selected.modelData.execute();
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

    home: function () {
        if (listView.count === 0)
            return true;
        mouseTriggered = false;
        selectedIndex = -1;
        selectedIndex = 0;
    }
    end: function () {
        if (listView.count === 0)
            return true;
        mouseTriggered = false;
        selectedIndex = listView.count;
        selectedIndex = listView.count - 1;
    }

    pgup: function () {
        if (listView.count === 0)
            return true;
        mouseTriggered = false;
        const pageSize = Math.floor(listView.height / (General.appIconSize + Launcher.innerMargin * 2));
        if (selectedIndex - pageSize < 0) {
            selectedIndex = 0;
        } else {
            selectedIndex -= pageSize;
        }
    }

    pgdn: function () {
        if (listView.count === 0)
            return true;
        mouseTriggered = false;
        const pageSize = Math.floor(listView.height / (General.appIconSize + Launcher.innerMargin * 2));
        if (selectedIndex + pageSize >= listView.count) {
            selectedIndex = listView.count - 1;
        } else {
            selectedIndex += pageSize;
        }
    }

    onEntriesChanged: {
        if (selectedIndex !== -1) {
            syncSelectionState();
            return;
        }
        selectedIndex = 0;
        listView.contentY = 0;
        syncSelectionState();
    }

    onSelectedIndexChanged: {
        syncSelectionState();
        if (selectedIndex < 0 || selectedIndex >= listView.count || mouseTriggered)
            return;
        Qt.callLater(() => {
            listView.positionViewAtIndex(selectedIndex, ListView.Contain);
        });
    }

    syncSelectionState: function () {
        Qt.callLater(() => state.selected = listView.itemAtIndex(selectedIndex));
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
            model: entries
            spacing: 0

            delegate: Item {
                required property DesktopEntry modelData
                required property int index
                width: item.implicitWidth + Launcher.innerMargin * 4
                height: item.height + Launcher.innerMargin * 4

                RowLayout {
                    id: item
                    scale: index === selectedIndex ? 1.01 : 0.99
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.margins: Launcher.innerMargin * 2
                    spacing: Launcher.innerMargin * 2

                    IconImage {
                        source: Quickshell.iconPath(modelData.icon, "image-missing")
                        implicitWidth: General.appIconSize
                        implicitHeight: General.appIconSize
                    }
                    IText {
                        text: modelData.name
                        renderType: Text.QtRendering
                        color: index === selectedIndex ? Colors.foreground1 : Colors.foreground2
                    }

                    Behavior on scale {
                        ISpringAnimation {}
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
                    }
                    onPressed: {
                        root._exec();
                    }
                }
            }
        }
    }
}
