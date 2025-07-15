function defaultInterface(route) {
	var lines = route.split(/\r?\n/)
	for (var i = 0; i < lines.length; i++) {
		var l = lines[i]
		if (l.indexOf("default via") === 0) return l.split(/\s+/)[4]
	}
	throw "No default interface"
}
function getRxTxBytes(dev, iface) {
	var lines = dev.split(/\r?\n/)
	for (var i = 0; i < lines.length; i++) {
		var l = lines[i].trim()
		if (!l.startsWith(iface + ":")) continue
		var p = l.split(/\s+/)
		return { rx: parseInt(p[1]), tx: parseInt(p[9]) }
	}
	throw "Interface not found"
}
function formatSize(size, unit) {
	const labels = ["B", "K", "M", "G", "T"]
	let power = 0, kilo = 2 ** 10
	while (size > kilo && power < labels.length - 1) {
		size /= kilo; power++
	}
	if (unit) {
		return labels[power]
	} else {
		return size.toFixed(0)
	}
}
