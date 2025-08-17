pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import qs.components

Searchable {
    id: root

    property list<QtObject> _emojis: []
    property var _emojiFile: FileView {
        path: "/usr/share/rofi-emoji/all_emojis.txt"
        blockLoading: true

        onTextChanged: {
            _parseEmojis();
        }
    }

    list: _emojis
    key: "searchText"

    function transformSearch(search) {
        return search.toLowerCase();
    }

    function _parseEmojis() {
        if (!_emojiFile.text())
            return;

        const lines = _emojiFile.text().split('\n').filter(line => line.trim());
        const emojis = [];

        for (const line of lines) {
            const parts = line.split('\t');
            if (parts.length >= 5) {
                const emoji = parts[0];
                const category = parts[1];
                const subcategory = parts[2];
                const name = parts[3];
                const keywords = parts[4];

                const emojiObj = Qt.createQmlObject(`
					import QtQuick
					QtObject {
						property string emoji: "${emoji.replace(/"/g, '\\"')}"
						property string category: "${category.replace(/"/g, '\\"')}"
						property string subcategory: "${subcategory.replace(/"/g, '\\"')}"
						property string name: "${name.replace(/"/g, '\\"')}"
						property string keywords: "${keywords.replace(/"/g, '\\"')}"
						property string searchText: "${(name + ' ' + keywords).toLowerCase().replace(/"/g, '\\"')}"
					}
				`, root);

                emojis.push(emojiObj);
            }
        }

        _emojis = emojis;
    }

    function copy(emoji) {
        Quickshell.execDetached(["wl-copy", emoji]);
    }
}
