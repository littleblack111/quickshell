pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import qs.components

Searchable {
    id: root

    key: "data"
    algorithm: Searchable.SearchAlgorithm.Include

    property list<string> _clipHist: []
    property list<string> _clipImg: []
    property list<string> _clipImgIds: _clipImg.map(p => p.split("/").pop().split(".").shift())

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

            const idStr = idNum >= 0 ? "" + idNum : "";
            const imgPath = idStr ? imgMap[idStr] || "" : "";
            const isImg = !!imgPath;

            return {
                index: idNum,
                isImage: isImg,
                data: isImg ? imgPath : payload,
                raw: raw
            };
        });
    }

    function transformSearch(search) {
        return search.toLowerCase();
    }

    function decodeAndCopy(text) {
        Quickshell.execDetached(["sh", "-c", `cliphist decode ${text} | wl-copy`]);
    }

    function copy(text) {
        Quickshell.execDetached(["wl-copy", text]);
    }

    function _update() {
        clipProc.running = true;
        imgProc.running = true;
    }

    Process {
        id: clipProc
        running: true
        command: ["cliphist", "-preview-width", 9 ** 9, "-max-items", 9 ** 9, "list"]
        stdout: StdioCollector {
            property bool pending: false
            onStreamFinished: () => {
                pending = true;
                Qt.callLater(() => {
                    if (pending) {
                        pending = false;
                        _clipHist = this.text.split(/\r?\n/);
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
                _update();
            }
        }
    }
}
