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
    property var historyData: active ? History.getRecentHistory("Applications", 10) : []
    property var enhancedEntries: active ? enhanceWithHistory() : []
    property int selectedIndex: -1

    name: "Applications"

    implicitHeight: valid ? layout.height : 0

    function enhanceWithHistory() {
        const apps = entries || [];
        const history = historyData || [];
        
        const historyMap = new Map();
        history.forEach(item => {
            if (item.data && item.data.name) {
                historyMap.set(item.data.name, item.count || 1);
            }
        });

        const enhanced = apps.map(app => {
            const count = historyMap.get(app.name) || 0;
            const result = {};
            for (const key in app) {
                if (app.hasOwnProperty(key)) {
                    result[key] = app[key];
                }
            }
            result.historyCount = count;
            result.isFromHistory = count > 0;
            return result;
        });

        return enhanced.sort((a, b) => {
            if (b.historyCount !== a.historyCount) {
                return b.historyCount - a.historyCount;
            }
            return 0;
        });
    }

    getSelectedData: function() {
        return selectedIndex >= 0 && enhancedEntries[selectedIndex] ? enhancedEntries[selectedIndex] : null;
    }

    preview: Component {
        IconImage {
            source: Quickshell.iconPath(answer, "image-missing")
            implicitWidth: General.appIconSize
            implicitHeight: General.appIconSize
        }
    }

    property string predictiveCompletion: valid ? enhancedEntries[selectedIndex]?.name.slice(input.length) || "" : ""

    process: function () {
        const isValid = enhancedEntries.length > 0;
        const selected = isValid ? enhancedEntries[selectedIndex] : "";
        return {
            valid: isValid,
            priority: isValid,
            answer: selected?.icon || ""
        };
    }

    exec: function () {
        const app = enhancedEntries[selectedIndex];
        if (app && app.execute) {
            app.execute();
        }
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
        selectedIndex = -1;
        selectedIndex = 0;
    }
    end: function () {
        if (selectedIndex + 1 > listView.count - 1)
            return true;
        selectedIndex = listView.count;
        selectedIndex = listView.count - 1;
    }

    pgup: function () {
        if (listView.count === 0)
            return true;
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
        const pageSize = Math.floor(listView.height / (General.appIconSize + Launcher.innerMargin * 2));
        if (selectedIndex + pageSize >= listView.count) {
            selectedIndex = listView.count - 1;
        } else {
            selectedIndex += pageSize;
        }
    }

    onEnhancedEntriesChanged: {
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
        Qt.callLater(() => {
            listView.positionViewAtIndex(selectedIndex, ListView.Contain);
        });
    }

    syncSelectionState: function () {
        Qt.callLater(() => {
            if (selectedIndex < 0 || selectedIndex >= listView.count || !root.visible)
                return;

            state.selected = listView.itemAtIndex(selectedIndex);
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
            model: enhancedEntries
            spacing: 0

            delegate: Item {
                required property var modelData
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

                    IRect {
                        visible: modelData?.isFromHistory || false
                        color: Colors.accent
                        width: 3
                        height: parent.height
                        radius: 1
                    }

                    IconImage {
                        source: Quickshell.iconPath(modelData.icon, "image-missing")
                        implicitWidth: General.appIconSize
                        implicitHeight: General.appIconSize
                    }
                    Column {
                        IText {
                            text: modelData.name
                            renderType: Text.QtRendering
                            color: index === selectedIndex ? Colors.foreground1 : Colors.foreground2
                        }
                        IText {
                            visible: modelData?.historyCount > 0
                            text: `Used ${modelData.historyCount} times`
                            color: Colors.accent
                            font.pixelSize: Launcher.widgetFontSize / 1.5
                        }
                    }

                    Behavior on scale {
                        ISpringAnimation {}
                    }
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
        }
    }
}
