import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.services
import qs.config

IComponent {
    id: root
    // TODO: presist how much times per app is opened on disk, routinely check if the app is still there
    property list<DesktopEntry> entries
    property int selectedIndex: -1
    name: "Applications"
    implicitHeight: valid ? Math.min(layout.height, Launcher.widgetHeight) : 0
    preview: Component {
        IconImage {
            source: Quickshell.iconPath(answer, "image-missing")
            implicitWidth: General.appIconSize
            implicitHeight: General.appIconSize
        }
    }
    process: function () {
        const search = input.toLowerCase();
        if (!search)
            return;
        let query = [...AppSearch.fuzzyQuery(search)].reverse();
        entries = query;
        const first = query.length > 0 && query[0];
        const isValid = query.length > 0;
        const isPriority = first?.name?.toLowerCase() === search;
        const predictiveCompletion = isValid ? first.name.slice(search.length) : "";
        isValid ? selectedIndex = 0 : null;
        updateActiveComponent();
        return {
            valid: isValid,
            priority: isPriority // TODO: maybe generic name as well, maybe 1 char fuzzy, also maybe case insensitive?
            ,
            answer: first.icon  // would still work because if nothing else match, we defaultly promote APp
            ,
            // no need preview cuz it's already defined
            predictiveCompletion: predictiveCompletion
        };
    }
    exec: function () {
        ActiveComponent.selected.modelData.execute();
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

    function updateActiveComponent() {
        ActiveComponent.selected = repeater.itemAt(selectedIndex);
        ActiveComponent.exec = root.exec;
    }

    onSelectedIndexChanged: {
        updateActiveComponent();
    }

    IInnerComponent {
        id: layout
        fromParent: false
        width: parent.width
        height: Math.min(innerLayout.height + titleBar.height, Launcher.widgetHeight) // childrenRect doesnt work...
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
                        Layout.margins: Launcher.innerMargin
                        implicitWidth: root.width
                        implicitHeight: item.height
                        RowLayout {
                            id: item
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
                            onPositionChanged: {
                                root.selectedIndex = index;
                            }
                        }
                    }
                }
            }
        }
    }
}
