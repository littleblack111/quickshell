pragma Singleton

import "../utils/fuzzysort.js" as Fuzzy
import "../utils/levendist.js" as Levendist
import Quickshell
import Quickshell.Io
import qs.config

/**
 * - Eases fuzzy searching for applications by name
 * - Guesses icon name for window class name
 */
Singleton {
    id: root

    property int scoreThreshold: 3

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

    /**
   * Returns an Array<DesktopEntry> for a given search.
   * Results are cached by exact search string and, if the
   * search starts with a previously cached key, uses that
   * cached result as the source for filtering.
   */
    function fuzzyQuery(search) {
        search = search.trim().toLowerCase();
        if (root.fuzzyQueryCache[search]) {
            return root.fuzzyQueryCache[search];
        }

        let source = list;
        let previousLists = Object.keys(root.fuzzyQueryCache).filter(key => key && search.startsWith(key));
        if (previousLists.length > 0) {
            var longest = previousLists.reduce((a, b) => a.length >= b.length ? a : b);
            source = root.fuzzyQueryCache[longest];
        }

        let results = source.map(obj => ({
                    entry: obj,
                    score: Levendist.distance(obj.name, search),
                    lowered: obj.name.toLowerCase()
                })).filter(item => item.score < root.scoreThreshold || item.lowered.startsWith(search)).sort((a, b) => b.score - a.score).map(item => item.entry).filter((entry, idx, arr) => arr.indexOf(entry) === idx);

        root.fuzzyQueryCache[search] = results;
        return results;
    }

    function iconExists(iconName) {
        if (!iconName || iconName.length === 0) {
            return false;
        }
        if (root.iconExistsCache.hasOwnProperty(iconName)) {
            return root.iconExistsCache[iconName];
        }
        const exists = Quickshell.iconPath(iconName, true).length > 0 && !iconName.includes("image-missing");
        root.iconExistsCache[iconName] = exists;
        return exists;
    }

    function guessIcon(str) {
        if (!str || str.length === 0) {
            return "image-missing";
        }
        if (root.guessIconCache[str]) {
            return root.guessIconCache[str];
        }

        var result;

        if (substitutions[str]) {
            result = substitutions[str];
        } else {
            result = null;
            for (var i = 0; i < regexSubstitutions.length; i++) {
                var {
                    regex,
                    replace
                } = regexSubstitutions[i];
                var replaced = str.replace(regex, replace);
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
            var guessStr = str.split(".").slice(-1)[0].toLowerCase();
            if (root.iconExists(guessStr)) {
                result = guessStr;
            }
        }

        if (!result) {
            var kebab = str.toLowerCase().replace(/\s+/g, "-");
            if (root.iconExists(kebab)) {
                result = kebab;
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
