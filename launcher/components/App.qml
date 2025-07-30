import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.services
import qs.config

IComponent {
    // TODO: presist how much times per app is opened on disk, routinely check if the app is still there
    name: "Applications"
    property list<DesktopEntry> entries
    process: function () {
        if (!input)
            return {
                valid: false,
                priority: false
            };
        const query = AppSearch.fuzzyQuery(input);
        entries = query;
        const first = query.length > 0 && query[0].name.toLowerCase();
        return {
            valid: query.length > 0,
            priority: priority // TODO: maybe generic name as well, maybe 1 char fuzzy, also maybe case insensitive?
            ,
            answer: first === input.toLowerCase() // would still work because if nothing else match, we defaultly promote APp
        };
    }

    ColumnLayout {
        spacing: 0
        anchors.fill: parent
    }
}
