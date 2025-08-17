pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Wayland

import qs.components
import qs.utils
import qs.services
import "../utils/string_utils.js" as StringUtils

Searchable {
    id: root

    key: "data"
    algorithm: Searchable.SearchAlgorithm.Include

    property list<string> _clipHist: []
    property list<string> _clipImg: []
    property list<string> _clipImgIds: _clipImg.map(p => p.split("/").pop().split(".").shift())

    property var _clipMetadata: ({})

    function getType(text: string): string {
        if (!text)
            return;
        if (text.startsWith("http://") || text.startsWith("https://"))
            return "web";
        if (text.startsWith("file://"))
            return "file";

        return "text";
    }

    list: {
        if (!_clipHist?.length)
            return [];

        const imgMap = _clipImgIds.slice(0, Math.min(_clipImg.length, _clipImgIds.length)).reduce((map, id, i) => {
            if (id)
                map[id] = _clipImg[i];
            return map;
        }, {});

        return _clipHist.filter(raw => raw).map(raw => {
            const tab = raw.indexOf("\t");
            let idNum = -1;
            let payload = raw;

            if (tab > 0) {
                const n = parseInt(raw.slice(0, tab), 10);
                if (!Number.isNaN(n)) {
                    idNum = n;
                    payload = raw.slice(tab + 1);
                }
            }

            const imgPath = idNum >= 0 ? imgMap[idNum] || "" : "";
            const isImg = !!imgPath;
            const metadata = _clipMetadata[idNum] || {};

            return {
                index: idNum,
                type: isImg ? "image" : root.getType(payload),
                data: isImg ? imgPath : payload,
                raw: raw,
                timestamp: metadata.timestamp || "",
                appId: metadata.appId || "",
                appTitle: metadata.appTitle || "",
                appIcon: Quickshell.iconPath(AppSearch.guessIcon(metadata.appId), "image-missing"),
                image: imgPath // explicitly include the image path
            };
        });
    }

    Persistent {
        id: clipMetaStore
        filePath: Directories.clipHistMetaDataPath
        adapter: JsonAdapter {
            property var metadata: ({})
        }
        fileView.onLoaded: {
            const meta = adapter.metadata;
            for (const k in meta) {
                if (meta[k].timestamp && typeof meta[k].timestamp === "string") {
                    meta[k].timestamp = new Date(meta[k].timestamp);
                }
            }
            root._clipMetadata = meta;
        }
        // fileView.onAdapterUpdated: {
        //     root._clipMetadata = adapter.metadata;
        // }
    }

    on_ClipMetadataChanged: {
        clipMetaStore.adapter.metadata = _clipMetadata;
    }

    function transformSearch(search) {
        return search.toLowerCase();
    }

    function decodeAndCopy(text) {
        Quickshell.execDetached(["sh", "-c", `cliphist decode '${StringUtils.shellSingleQuoteEscape(text)}' | wl-copy`]);
    }

    function copy(text) {
        Quickshell.execDetached(["wl-copy", text]);
    }

    function _update() {
        clipProc.running = true;
        imgProc.running = true;
    }

    function _captureMetadata() {
        const now = new Date();
        const activeToplevel = ToplevelManager.activeToplevel;

        Qt.callLater(() => {
            clipProc.running = true;
            clipProc.stdout.onceFinished = () => {
                const lines = clipProc.stdout.text.split(/\r?\n/);
                const firstLine = lines[0] || "";
                const tab = firstLine.indexOf("\t");

                if (tab > 0) {
                    const idStr = firstLine.slice(0, tab);
                    const n = parseInt(idStr, 10);
                    if (!Number.isNaN(n)) {
                        var newMetadata = {};
                        for (var k in _clipMetadata) {
                            if (_clipMetadata.hasOwnProperty(k))
                                newMetadata[k] = _clipMetadata[k];
                        }

                        newMetadata[idStr] = {
                            timestamp: now,
                            appId: activeToplevel ? activeToplevel.appId : "",
                            appTitle: activeToplevel ? activeToplevel.title : ""
                        };
                        _clipMetadata = newMetadata;
                    }
                }
            };
        });
    }

    Process {
        id: clipProc
        running: true
        command: ["cliphist", "-preview-width", 9 ** 9, "-max-items", 9 ** 9, "list"]
        stdout: StdioCollector {
            property bool pending: false
            property var onceFinished: null

            onStreamFinished: () => {
                pending = true;
                Qt.callLater(() => {
                    if (pending) {
                        pending = false;
                        _clipHist = this.text.split(/\r?\n/);
                        if (onceFinished) {
                            onceFinished();
                            onceFinished = null;
                        }
                    }
                });
            }
        }
    }

    Process {
        id: imgProc
        running: true
        command: ["sh", Quickshell.shellDir + "/utils/cliphist-img.sh"]
        stdout: StdioCollector {
            property bool pending: false
            onStreamFinished: () => {
                pending = true;
                Qt.callLater(() => {
                    if (pending) {
                        pending = false;
                        _clipImg = this.text.split(/\r?\n/);
                    }
                });
            }
        }
    }

    Process {
        id: watchProc
        running: true
        command: ["wl-paste", "-w", "echo"]
        onRunningChanged: if (!running)
            running = true

        stdout: SplitParser {
            onRead: line => {
                _captureMetadata();
                _update();
            }
        }
    }
}
