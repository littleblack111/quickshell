#!/usr/bin/env python3
import json, time
from lyrics.config import Config
from lyrics.player import Player

d = Config('OPTIONS')
name       = d['player'].strip()
autoswitch = d.getboolean('autoswitch')
align_str  = d['alignment']
align      = 0 if align_str=='center' else 2 if align_str=='right' else 1
source     = d['source']
mpd_conn   = [d['mpd_host'], d['mpd_port'], d['mpd_pass']]

player    = Player(name, source, autoswitch, mpd_conn, align=align)
last_track = None

def get_duration():
    try:
        md = player.player_interface.Get(
            "org.mpris.MediaPlayer2.Player", "Metadata")
        # mpris:length is in microseconds
        return md.get("mpris:length", 0) / 1_000_000
    except:
        return None

while True:
    player.update()
    track = player.track.track_name
    if track != last_track:
        last_track = track
        dur = get_duration()
        arr = []
        if player.track.timestamps:
            for ts, line in zip(player.track.timestamps,
                                player.track.lyrics):
                # position as fraction of total length
                pos = ts if dur is None else ts / dur
                arr.append({"line": line, "position": pos})
        # first notify QML of a new track
        print(json.dumps({
            "event": "track_change",
            "track": track
        }), flush=True)
        # then send the full lyrics array
        print(json.dumps({
            "event": "full_lyrics",
            "track": track,
            "lyrics": arr
        }), flush=True)
    time.sleep(1)
