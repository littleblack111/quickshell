pragma Singleton

import Quickshell
import Quickshell.Io
import QtQml
import QtQuick

Singleton {
    id: root
    property var data: file.data()

    FileView {
        id: file
        path: Qt.resolvedUrl("/usr/share/rofi-emoji/all_emojis.txt")
    }
}
