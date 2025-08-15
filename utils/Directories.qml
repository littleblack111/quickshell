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

    // Other dirs used by the shell, without "file://"
    property string scriptPath: trimFileProtocol(`${Directories.config}/quickshell/scripts`)
    property string favicons: trimFileProtocol(`${Directories.cache}/media/favicons`)
    property string coverArt: trimFileProtocol(`${Directories.cache}/media/coverart`)
    property string booruPreviews: trimFileProtocol(`${Directories.cache}/media/boorus`)
    property string booruDownloads: trimFileProtocol(Directories.pictures + "/homework")
    property string booruDownloadsNsfw: trimFileProtocol(Directories.pictures + "/homework/🌶️")
    property string latexOutput: trimFileProtocol(`${Directories.cache}/media/latex`)
    property string shellConfig: trimFileProtocol(`${Directories.config}/illogical-impulse`)
    property string shellConfigName: "config.json"
    property string shellConfigPath: `${Directories.shellConfig}/${Directories.shellConfigName}`
    property string todoPath: trimFileProtocol(`${Directories.state}/user/todo.json`)
    property string notificationsPath: trimFileProtocol(`${Directories.cache}/notifications/notifications.json`)
    property string generatedMaterialThemePath: trimFileProtocol(`${Directories.state}/user/generated/colors.json`)
    property string cliphistDecode: trimFileProtocol(`/tmp/quickshell/media/cliphist`)
    property string wallpaperSwitchScriptPath: trimFileProtocol(`${Directories.scriptPath}/colors/switchwall.sh`)
    property string defaultAiPrompts: trimFileProtocol(`${Directories.config}/quickshell/defaults/ai/prompts`)
    property string userAiPrompts: trimFileProtocol(`${Directories.shellConfig}/ai/prompts`)
    // Cleanup on init
    Component.onCompleted: {
        Quickshell.execDetached(["bash", "-c", `mkdir -p '${shellConfig}'`]);
        Quickshell.execDetached(["bash", "-c", `mkdir -p '${favicons}'`]);
        Quickshell.execDetached(["bash", "-c", `rm -rf '${cliphistDecode}'; mkdir -p '${cliphistDecode}'`]);
    }
}
