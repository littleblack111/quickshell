import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.services
import qs.config

IComponent {

    // TODO: presist how much times per app is opened on disk, routinely check if the app is still there
    property list<DesktopEntry> entries
    name: "Applications"
    implicitHeight: valid ? Math.min(layout.height, Launcher.widgetHeight) : 0
    preview: Component {
        IconImage {
            source: Quickshell.iconPath(answer, "image-missing")
            implicitWidth: Bar.appIconSize
            implicitHeight: Bar.appIconSize
        }
    }
    process: function () {
        const search = input.toLowerCase();
        if (!search)
            return;
        let query = [...AppSearch.fuzzyQuery(search)].reverse();
        console.log(query[0].name);
        entries = query;
        const first = query.length > 0 && query[0];
        const isValid = query.length > 0;
        const isPriority = first?.name?.toLowerCase() === search;
        return {
            valid: isValid,
            priority: isPriority // TODO: maybe generic name as well, maybe 1 char fuzzy, also maybe case insensitive?
            ,
            answer: isPriority ? first.icon : null // would still work because if nothing else match, we defaultly promote APp
            ,
            preview: preview
        };
    }

    IInnerComponent {
        id: layout
        fromParent: false
        width: parent.width
        height: Math.min(innerLayout.implicitHeight, Launcher.widgetHeight)
        Flickable {
            id: flickable
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            interactive: true
            contentWidth: innerLayout.implicitWidth
            contentHeight: innerLayout.implicitHeight

            ColumnLayout {
                id: innerLayout
                spacing: 0

                Repeater {
                    model: entries

                    RowLayout {
                        IconImage {
                            source: Quickshell.iconPath(modelData.icon, "image-missing")
                            implicitWidth: Bar.appIconSize
                            implicitHeight: Bar.appIconSize
                        }
                        IText {
                            text: modelData.name
                        }
                    }
                }
            }
        }
    }
}
