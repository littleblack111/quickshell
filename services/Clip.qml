pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import "../utils/levendist.js" as Levendist

Singleton {
    id: root

    property list<string> _clipHist: []
    property list<string> _clipImg: []
    property list<string> _clipImgIds: _clipImg.map(p => p.split("/").pop().split(".").shift())

    property string toDecode: ""
    property string toCopy: ""
    property string decoded: ""

    property var fuzzyQueryCache: ({});

    property var clipHist: {
        const arr = [];
        if (!_clipHist?.length)
            return arr;

        const imgMap = {};
        const nimg = Math.min(_clipImg.length, _clipImgIds.length);
        for (let i = 0; i < nimg; i++) {
            const id = _clipImgIds[i];
            if (id)
                imgMap[id] = _clipImg[i];
        }

        for (let i = 0; i < _clipHist.length; i++) {
            const raw = _clipHist[i];
            if (!raw)
                continue;
            const tab = raw.indexOf("\t");
            let idNum = -1;
            let payload = raw;
            if (tab > 0) {
                const n = parseInt(raw.slice(0, tab), 10);
                if (!Number.isNaN(n)) {
                    idNum = n;
                    payload = raw.slice(tab + 1); // strip "ID<TAB>"
                }
            }

            const idStr = idNum >= 0 ? "" + idNum : "";
            const imgPath = idStr ? imgMap[idStr] || "" : "";
            const isImg = !!imgPath;

            arr.push({
                index: idNum,
                isImage: isImg,
                data: isImg ? imgPath : payload,
                raw: raw
            });
        }
        return arr;
    }

    function fuzzyQuery(search) {
        if (!search)
            return root.clipHist;
        if (root.fuzzyQueryCache[search]) {
            return root.fuzzyQueryCache[search];
        }
        let source = root.clipHist;
        let previousLists = Object.keys(root.fuzzyQueryCache).filter(key => key && search.startsWith(key));
        if (previousLists.length > 0) {
            var longest = previousLists.reduce((a, b) => a.length >= b.length ? a : b);
            source = root.fuzzyQueryCache[longest];
        }
        const p = [], f = [];
        for (const s of source) {
            const t = (s.isImage ? "image" : (s.data || "")).toLowerCase();
            if (t.startsWith(search)) {
                p.push(s);
                continue;
            }
            let pos = 0;
            for (const c of search) {
                pos = t.indexOf(c, pos);
                if (pos < 0) {
                    pos = 0;
                    break;
                }
                pos++;
            }
            if (pos)
                f.push({
                    s,
                    score: Levendist.distance(search, t)
                });
        }
        const results = p.concat(f.sort((a, b) => a.score - b.score).map(({s}) => s));
        root.fuzzyQueryCache[search] = results;
        return results;
    }

    component SClip_t: QtObject {
        property int index
        property bool isImage
        property string data
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
        command: ["sh", "-c", "cliphist decode" + toDecode + " | wl-copy"]
        stdout: StdioCollector {
            onStreamFinished: () => {
                decoded = data;
            }
        }
        onStarted: {
            decoded = "";
        }
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
