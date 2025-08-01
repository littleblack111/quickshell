var name = 'America/New_York';
var now = new Date();

var time = now.toLocaleTimeString('en-US', {
	timeZone: name,
	hour12: true,
	hour: '2-digit',
	minute: '2-digit',
	second: '2-digit'
});

var remote = new Date(
	now.toLocaleString('sv-SE', {
		timeZone: name,
		year: 'numeric',
		month: '2-digit',
		day: '2-digit',
		hour: '2-digit',
		minute: '2-digit',
		second: '2-digit'
	})
);

var offset = (remote.getTime() - now.getTime()) / 3600000;

var abbr = now.toLocaleTimeString('en-US', {
	timeZone: name,
	timeZoneName: 'short'
}).split(' ').pop();

console.log(time, remote, offset, abbr);
