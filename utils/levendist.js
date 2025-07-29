// utils/fastlev.js
function levenshteinThreshold(s1, s2, maxDist) {
	const len1 = s1.length;
	const len2 = s2.length;
	if (Math.abs(len1 - len2) > maxDist) {
		return maxDist + 1;
	}
	let prev = new Array(len2 + 1);
	for (let j = 0; j <= len2; j++) {
		prev[j] = j;
	}
	for (let i = 1; i <= len1; i++) {
		const curr = new Array(len2 + 1);
		curr[0] = i;
		let rowMin = curr[0];
		for (let j = 1; j <= len2; j++) {
			const cost = s1[i - 1] === s2[j - 1] ? 0 : 1;
			const v1 = prev[j] + 1;
			const v2 = curr[j - 1] + 1;
			const v3 = prev[j - 1] + cost;
			curr[j] = v1 < v2 ? (v1 < v3 ? v1 : v3) : (v2 < v3 ? v2 : v3);
			if (curr[j] < rowMin) rowMin = curr[j];
		}
		if (rowMin > maxDist) {
			return maxDist + 1;  // early exit
		}
		prev = curr;
	}
	return prev[len2];
}

function computeScoreFast(s1, s2, scoreThreshold) {
	// cheap length check: allow at most d edits where
	// d = floor(maxLen*(1 - scoreThreshold))
	const maxLen = Math.max(s1.length, s2.length);
	const maxDist = Math.floor(maxLen * (1 - scoreThreshold));
	const dist = levenshteinThreshold(s1, s2, maxDist);
	if (dist > maxDist) {
		return 0.0;
	}
	// now fall back to your full computeScore only
	// if needed, or just accept full = 1 - dist/maxLen
	return 1.0 - dist / maxLen;
}
