pragma Singleton

import "../utils/fuzzysort.js" as Fuzzy
import "../utils/levendist.js" as Levendist
import Quickshell
import Quickshell.Io
import qs.config

Singleton {
    id: root

    property bool sloppySearch: General.sloopySearch
    property real scoreThreshold: 0.5

    property var substitutions: ({
            "code-url-handler": "visual-studio-code",
            "Code": "visual-studio-code",
            "gnome-tweaks": "org.gnome.tweaks",
            "pavucontrol-qt": "pavucontrol",
            "wps": "wps-office2019-kprometheus",
            "wpsoffice": "wps-office2019-kprometheus",
            "footclient": "foot",
            "zen": "zen-browser",
            "brave-browser": "brave-desktop"
        })

    property var regexSubstitutions: [
        {
            regex: /^steam_app_(\d+)$/,
            replace: "steam_icon_$1"
        },
        {
            regex: /Minecraft.*/,
            replace: "minecraft"
        },
        {
            regex: /.*polkit.*/,
            replace: "system-lock-screen"
        },
        {
            regex: /gcr.prompter/,
            replace: "system-lock-screen"
        }
    ]

    property var fuzzyQueryCache: ({})
    property var iconExistsCache: ({})
    property var guessIconCache: ({})

    readonly property list<DesktopEntry> list: Array.from(DesktopEntries.applications.values).sort((a, b) => a.name.localeCompare(b.name))

    readonly property var lowerEntries: list.map(e => ({
                name: e.name,
                lower: e.name.toLowerCase(),
                icon: e.icon
            }))

    readonly property var preppedNames: list.map(a => ({
                name: Fuzzy.prepare(`${a.name} `),
                entry: a
            }))

    function fuzzyQuery(search) {
        const key = search.toLowerCase();
        if (root.fuzzyQueryCache[key]) {
            return root.fuzzyQueryCache[key];
        }
        let results;
        if (root.sloppySearch) {
            results = lowerEntries.map(item => ({
                        entry: item,
                        score: Levendist.computeScoreFast(item.lower, key, root.scoreThreshold)
                    })).filter(x => x.score >= root.scoreThreshold).sort((a, b) => b.score - a.score).map(x => x.entry);
        } else {
            // original fast Fuzzysort path
            results = Fuzzy.go(search, preppedNames, {
                all: true,
                key: "name",
                threshold: -Math.floor(search.length * (1 - root.scoreThreshold))
            }).map(r => r.obj.entry);
        }
        root.fuzzyQueryCache[key] = results;
        return results;
    }

    function iconExists(iconName) {
        if (!iconName || iconName.length === 0)
            return false;
        if (root.iconExistsCache.hasOwnProperty(iconName)) {
            return root.iconExistsCache[iconName];
        }
        const exists = Quickshell.iconPath(iconName, true).length > 0 && !iconName.includes("image-missing");
        root.iconExistsCache[iconName] = exists;
        return exists;
    }

    function guessIcon(str) {
        if (!str || str.length === 0)
            return "image-missing";
        if (root.guessIconCache[str]) {
            return root.guessIconCache[str];
        }
        let result = substitutions[str] || null;
        if (!result) {
            for (let i = 0; i < regexSubstitutions.length; i++) {
                const {
                    regex,
                    replace
                } = regexSubstitutions[i];
                const replaced = str.replace(regex, replace);
                if (replaced !== str) {
                    result = replaced;
                    break;
                }
            }
        }
        if (!result && root.iconExists(str)) {
            result = str;
        }
        if (!result) {
            const guessStr = str.split(".").slice(-1)[0].toLowerCase();
            if (root.iconExists(guessStr)) {
                result = guessStr;
            }
        }
        if (!result) {
            const guessStr = str.toLowerCase().replace(/\s+/g, "-");
            if (root.iconExists(guessStr)) {
                result = guessStr;
            }
        }
        if (!result) {
            const matches = root.fuzzyQuery(str);
            if (matches.length > 0) {
                const candidate = matches[0].icon;
                if (root.iconExists(candidate)) {
                    result = candidate;
                }
            }
        }
        if (!result) {
            result = str;
        }
        root.guessIconCache[str] = result;
        return result;
    }
}
