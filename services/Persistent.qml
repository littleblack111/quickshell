import QtQuick
import Quickshell
import Quickshell.Io
import qs.utils

Scope {
    id: root
    property alias adapter: fileView.adapter
    property alias fileView: fileView
    property string fileDir: Directories.state
    property string fileName: "states.json"
    property string filePath: `${root.fileDir}/${root.fileName}`

    FileView {
        id: fileView
        path: root.filePath
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()
        onLoadFailed: error => {
            console.log("Failed to load persistent states file:", error);
            if (error == FileViewError.FileNotFound) {
                writeAdapter();
            }
        }
    }
}
