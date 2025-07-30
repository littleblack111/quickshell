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
    implicitHeight: valid ? Launcher.widgetHeight * 2 : 0 // more space for apps
    process: function () {
        const search = input.toLowerCase();
        if (!search)
            return {
                valid: false,
                priority: false
            };
        const query = AppSearch.fuzzyQuery(search);
        entries = query;
        const first = query.length > 0 && query[0].name.toLowerCase();
        return {
            valid: query.length > 0,
            priority: priority // TODO: maybe generic name as well, maybe 1 char fuzzy, also maybe case insensitive?
            ,
            answer: first === search ? first : null // would still work because if nothing else match, we defaultly promote APp
        };
    }

    IInnerComponent {
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: parent.height
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
            Item {
                Layout.fillHeight: true
                Layout.preferredHeight: parent.height
            }
        }
    }
}
