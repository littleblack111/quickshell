import Quickshell
import QtQuick

import "../utils/fzf.js" as Fzf
import "../utils/fuzzysort.js" as Fuzzy
import "../utils/levendist.js" as Levendist

Singleton {
    required property var list
    property string key: "name"

    enum SearchAlgorithm {
        Levendist,
        Fzf,
        Fuzzysort,
        Include
    }
    property int algorithm: Searchable.SearchAlgorithm.Levendist
    property int scoreThreshold: 50
    property var extraOpts: ({})
    property list<string> keys: [key]
    property list<real> weights: [1]
    property var queryCache: ({})

    readonly property var fzf: algorithm === Searchable.SearchAlgorithm.Fzf ? new Fzf.Finder(list, Object.assign({
        selector
    }, extraOpts)) : null

    readonly property list<var> fzfFinders: algorithm === Searchable.SearchAlgorithm.Fzf ? keys.map(k => {
        return new Fzf.Finder(list, Object.assign({
            selector: item => fieldString(item, k)
        }, extraOpts));
    }) : []

    readonly property list<var> fuzzyPrepped: algorithm === Searchable.SearchAlgorithm.Fuzzysort ? list.map(e => {
        const obj = {
            _item: e
        };
        for (const k of keys)
            obj[k] = Fuzzy.prepare(String(e[k] ?? ""));
        return obj;
    }) : []

    function transformSearch(search: string): string {
        return search;
    }

    function fieldString(item: var, k: string): string {
        const v = item[k];
        return v == null ? "" : String(v);
    }

    function selector(item: var): string {
        return fieldString(item, keys[0]);
    }

    function levendistQuery(search: string): list<var> {
        if (queryCache[search])
            return queryCache[search];

        let source = list;
        let previousLists = Object.keys(queryCache).filter(key => key && search.startsWith(key));
        if (previousLists.length > 0) {
            var longest = previousLists.reduce((a, b) => a.length >= b.length ? a : b);
            source = queryCache[longest];
        }

        const prefixGroups = keys.map(() => []);
        const fuzzyGroups = keys.map(() => []);

        for (const s of source) {
            let best = null;
            for (let i = 0; i < keys.length; i++) {
                const t = fieldString(s, keys[i]).toLowerCase();
                if (!t)
                    continue;

                if (t.startsWith(search)) {
                    if (!best || i < best.index || best.type !== "prefix") {
                        best = {
                            type: "prefix",
                            index: i,
                            score: 0
                        };
                        if (best.index === 0)
                            break;
                    }
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
                if (pos) {
                    const d = Levendist.distance(search, t);
                    if (d <= scoreThreshold) {
                        if (!best || i < best.index || (best.type === "fuzzy" && i === best.index && d < best.score) || best.type === "prefix") {
                            if (!best || i < best.index || d < best.score) {
                                best = {
                                    type: "fuzzy",
                                    index: i,
                                    score: d
                                };
                            }
                        }
                    }
                }
            }

            if (best) {
                if (best.type === "prefix")
                    prefixGroups[best.index].push(s);
                else
                    fuzzyGroups[best.index].push({
                        s,
                        score: best.score
                    });
            }
        }

        const results = [];
        const seen = new Set();
        for (let i = 0; i < keys.length; i++) {
            for (const item of prefixGroups[i]) {
                if (!seen.has(item)) {
                    results.push(item);
                    seen.add(item);
                }
            }
            fuzzyGroups[i].sort((a, b) => a.score - b.score).forEach(({
                    s
                }) => {
                if (!seen.has(s)) {
                    results.push(s);
                    seen.add(s);
                }
            });
        }

        queryCache[search] = results;
        return results;
    }

    function query(search: string): list<var> {
        search = transformSearch(search);
        if (!search)
            return [...list];

        if (algorithm === Searchable.SearchAlgorithm.Levendist)
            return levendistQuery(search.toLowerCase());

        if (algorithm === Searchable.SearchAlgorithm.Fuzzysort) {
            const res = Fuzzy.go(search, fuzzyPrepped, Object.assign({
                all: true,
                keys,
                scoreFn: r => weights.reduce((a, w, i) => a + r[i].score * w, 0)
            }, extraOpts));

            const groups = keys.map(() => []);
            const noMatch = [];
            for (const r of res) {
                let idx = -1;
                for (let i = 0; i < keys.length; i++) {
                    const kr = r[i];
                    if (kr && kr.score !== -Infinity) {
                        idx = i;
                        break;
                    }
                }
                if (idx === -1)
                    noMatch.push(r);
                else
                    groups[idx].push(r);
            }

            const ordered = [];
            for (let i = 0; i < groups.length; i++) {
                for (const r of groups[i])
                    ordered.push(r.obj._item);
            }
            for (const r of noMatch)
                ordered.push(r.obj._item);
            return ordered;
        }

        if (algorithm === Searchable.SearchAlgorithm.Fzf) {
            if (keys.length <= 1) {
                return fzf.find(search).sort((a, b) => {
                    if (a.score === b.score)
                        return (selector(a.item).trim().length - selector(b.item).trim().length);
                    return b.score - a.score;
                }).map(r => r.item);
            }

            const groups = keys.map((_, i) => {
                const arr = fzfFinders[i].find(search);
                arr.sort((a, b) => {
                    if (a.score === b.score) {
                        const la = fieldString(a.item, keys[i]).trim().length;
                        const lb = fieldString(b.item, keys[i]).trim().length;
                        return la - lb;
                    }
                    return b.score - a.score;
                });
                return arr;
            });

            const seen = new Set();
            const out = [];
            for (let i = 0; i < groups.length; i++) {
                for (const r of groups[i]) {
                    const it = r.item;
                    if (!seen.has(it)) {
                        out.push(it);
                        seen.add(it);
                    }
                }
            }
            return out;
        }

        if (algorithm === Searchable.SearchAlgorithm.Include) {
            return list.filter(item => keys.some(k => fieldString(item, k).toLowerCase().includes(search)));
        }

        return [];
    }
}
