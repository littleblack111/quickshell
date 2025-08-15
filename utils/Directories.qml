pragma Singleton
// pragma ComponentBehavior: Bound

import Qt.labs.platform
import QtQuick
import Quickshell
import Quickshell.Hyprland

Singleton {
    /**
 * Trims the File protocol off the input string
 * @param {string} str
 * @returns {string}
 */
    function trimFileProtocol(str) {
        return str.startsWith("file://") ? str.slice(7) : str;
    }

    /**
 * Extracts the file name from a file path
 * @param {string} str
 * @returns {string}
 */
    function fileNameForPath(str) {
        if (typeof str !== "string")
            return "";
        const trimmed = trimFileProtocol(str);
        return trimmed.split(/[\\/]/).pop();
    }

    /**
 * Removes the file extension from a file path or name
 * @param {string} str
 * @returns {string}
 */
    function trimFileExt(str) {
        if (typeof str !== "string")
            return "";
        const trimmed = trimFileProtocol(str);
        const lastDot = trimmed.lastIndexOf(".");
        if (lastDot > -1 && lastDot > trimmed.lastIndexOf("/")) {
            return trimmed.slice(0, lastDot);
        }
        return trimmed;
    }

    // XDG Dirs, with "file://"
    readonly property string config: StandardPaths.standardLocations(StandardPaths.ConfigLocation)[0]
    readonly property string state: StandardPaths.standardLocations(StandardPaths.StateLocation)[0]
    readonly property string cache: StandardPaths.standardLocations(StandardPaths.CacheLocation)[0]
    readonly property string pictures: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
    readonly property string downloads: StandardPaths.standardLocations(StandardPaths.DownloadLocation)[0]

    property string clipHistMetaDataPath: `${state}/cliphist.json`

    // Cleanup on init
    Component.onCompleted: {
        Quickshell.execDetached(["touch", trimFileProtocol(clipHistMetaDataPath)]);
    }
}
