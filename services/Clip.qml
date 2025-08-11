pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import qs.components

Searchable {
    id: root

    key: "data"
    algorithm: Searchable.SearchAlgorithm.Levendist

    property list<string> _clipHist: []
    property list<string> _clipImg: []
    property list<string> _clipImgIds: _clipImg.map(p => p.split("/").pop().split(".").shift())

    property var toDecode: ""
    property string toCopy: ""

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
        toDecode = text;
        decodeAndCopyProc.running = true;
    }

    function copy(text) {
        toCopy = text;
        copyProc.running = true;
    }

    function _update() {
        clipProc.running = true;
        imgProc.running = true;
    }

    Process {
        id: decodeAndCopyProc
        running: false
        command: ["sh", "-c", "cliphist decode " + toDecode + " | wl-copy"]
        onExited: {
            toDecode = "";
        }
    }

    Process {
        id: clipProc
        running: true
        command: ["cliphist", "-preview-width", 9 ** 9, "-max-items", 9 ** 9, "list"]
        stdout: StdioCollector {
            onStreamFinished: () => {
                _clipHist = this.text.split(/\r?\n/);
            }
        }
    }

    Process {
        id: imgProc
        running: true
        command: ["sh", Quickshell.shellDir + "/utils/cliphist-img.sh"]
        stdout: StdioCollector {
            onStreamFinished: () => {
                _clipImg = this.text.split(/\r?\n/);
            }
        }
    }

    Process {
        id: copyProc
        running: false
        command: ["wl-copy", toCopy]
        onExited: {
            toCopy = "";
        }
    }

    Process {
        id: watchProc
        running: true
        command: ["wl-paste", "-w", "echo"]
        stdout: SplitParser {
            onRead: line => {
                _update();
            }
        }
    }
}
