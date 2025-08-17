pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import qs.components

Searchable {
    id: root

    property var _emojis: []
    property var _emojiFile: FileView {
        path: "/usr/share/rofi-emoji/all_emojis.txt"
        onTextChanged: _parseEmojis()
    }

    list: _emojis
    key: "searchText"
    algorithm: Searchable.SearchAlgorithm.Include

    function transformSearch(search) {
        return search.toLowerCase();
    }

    function _parseEmojis() {
        const text = _emojiFile.text();
        if (!text) {
            console.warn("Emoji service: failed to load", _emojiFile.path);
            _emojis = [];
            return;
        }

        const lines = text.split("\n").filter(l => l.trim());
        const out = [];
        for (let i = 0; i < lines.length; ++i) {
            const parts = lines[i].split("\t");
            if (parts.length < 5)
                continue;
            const [emoji, category, subcategory, name, keywords] = parts;
            out.push({
                emoji: emoji,
                category: category,
                subcategory: subcategory,
                name: name,
                keywords: keywords,
                searchText: (name + " " + keywords).toLowerCase()
            });
        }
        _emojis = out;
    }

    function copy(emoji) {
        Clip.copy(emoji);
    }
}
