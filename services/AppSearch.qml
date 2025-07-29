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
   * Results are cached by exact search string.
   */
    function fuzzyQuery(search) {
        if (root.fuzzyQueryCache[search]) {
            return root.fuzzyQueryCache[search];
        }

        search = search.trim().toLowerCase();

        let results = list.map(obj => ({
                    entry: obj,
                    score: Levendist.distance(obj.name, search),
                    lowered: obj.name.toLowerCase()
                })).filter(item => item.score < root.scoreThreshold || item.lowered.startsWith(search)).sort((a, b) => b.score - a.score).map(item => item.entry).filter((entry, idx, arr) => arr.indexOf(entry) === idx);

        root.fuzzyQueryCache[search] = results;
        return results;
    }

    /**
   * Caches whether an icon actually exists on disk.
   */
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

    /**
   * Heavy logic to guess an icon name.  We memoize results by the
   * exact input string.
   */
    function guessIcon(str) {
        if (!str || str.length === 0) {
            return "image-missing";
        }
        if (root.guessIconCache[str]) {
            return root.guessIconCache[str];
        }

        let result;

        // 1) direct substitution table
        if (substitutions[str]) {
            result = substitutions[str];
        } else
        // 2) regex rules
        {
            result = null;
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

        // 3) if still not found, see if the original exists
        if (!result) {
            if (root.iconExists(str)) {
                result = str;
            }
        }

        // 4) try domain-reverse name
        if (!result) {
            let guessStr = str.split(".").slice(-1)[0].toLowerCase();
            if (root.iconExists(guessStr)) {
                result = guessStr;
            }
        }

        // 5) kebab-case
        if (!result) {
            let guessStr = str.toLowerCase().replace(/\s+/g, "-");
            if (root.iconExists(guessStr)) {
                result = guessStr;
            }
        }

        // 6) fallback to first fuzzy match’s icon
        if (!result) {
            const matches = root.fuzzyQuery(str);
            if (matches.length > 0) {
                const candidate = matches[0].icon;
                if (root.iconExists(candidate)) {
                    result = candidate;
                }
            }
        }

        // 7) give up
        if (!result) {
            result = str;
        }

        root.guessIconCache[str] = result;
        return result;
    }
}
