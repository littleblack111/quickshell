import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.services
import qs.config

IComponent {
    property list<DesktopEntry> entries
    // TODO: presist how much times per app is opened on disk, routinely check if the app is still there
    name: "Applications"
    implicitHeight: valid ? Math.min(layout.height, Launcher.widgetWidth) : 0 // more space for apps
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
            return {
                valid: false,
                priority: false
            };
        const query = AppSearch.fuzzyQuery(search);
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
        ColumnLayout {
            id: innerLayout
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0
            Repeater {
                id: repeater
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
            // Item {
            //     Layout.fillHeight: true
            //     Layout.preferredHeight: 100
            // }
        }
    }
}
