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
        Fuzzysort
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

    readonly property list<var> fuzzyPrepped: algorithm === Searchable.SearchAlgorithm.Fuzzysort ? list.map(e => {
        const obj = {
            _item: e
        };
        for (const k of keys)
            obj[k] = Fuzzy.prepare(e[k]);
        return obj;
    }) : []

    function transformSearch(search: string): string {
        return search;
    }

    function selector(item: var): string {
        return item[key];
    }

    function levendistQuery(search: string): list<var> {
        // console.log(list);
        if (queryCache[search])
            return queryCache[search];

        let source = list;
        let previousLists = Object.keys(queryCache).filter(key => key && search.startsWith(key));
        if (previousLists.length > 0) {
            var longest = previousLists.reduce((a, b) => a.length >= b.length ? a : b);
            source = queryCache[longest];
        }

        const p = [], f = [];
        for (const s of source) {
            const t = s[key].toLowerCase();
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
        const results = p.concat(f.filter(item => item.score <= scoreThreshold).sort((a, b) => a.score - b.score).map(({
                s
            }) => s));

        queryCache[search] = results;
        return results;
    }

    function query(search: string): list<var> {
        search = transformSearch(search);
        if (!search)
            return [...list];

        if (algorithm === Searchable.SearchAlgorithm.Levendist)
            return levendistQuery(search.toLowerCase());

        if (algorithm === Searchable.SearchAlgorithm.Fuzzysort)
            return Fuzzy.go(search, fuzzyPrepped, Object.assign({
                all: true,
                keys,
                scoreFn: r => weights.reduce((a, w, i) => a + r[i].score * w, 0)
            }, extraOpts)).map(r => r.obj._item);

        return fzf.find(search).sort((a, b) => {
            if (a.score === b.score)
                return selector(a.item).trim().length - selector(b.item).trim().length;
            return b.score - a.score;
        }).map(r => r.item);
    }
}
