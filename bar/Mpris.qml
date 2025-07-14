import QtQuick 2.15
import QtQuick.Layouts 1.15
import Quickshell
import Quickshell.Services.Mpris
import qs.services as Services
import qs.config
import qs.components

Item {
    id: root
    readonly property MprisPlayer activePlayer: Services.Mpris.activePlayer
    readonly property real progress: (activePlayer.positionSupported && activePlayer.lengthSupported && activePlayer.length > 0) ? activePlayer.position / activePlayer.length : 0
    readonly property string cleanedTitle: cleanMusicTitle(activePlayer?.trackTitle)
    readonly property string state: activePlayer?.isPlaying ? Icons.media.pause : Icons.media.play

    function cleanMusicTitle(title) {
        if (!title)
            return "";
        title = title.replace(/\s*\([^)]*\)/g, " ");
        title = title.replace(/\s*\[[^\]]*\]/g, " ");
        title = title.replace(/\s*\{[^\}]*\}/g, " ");
        title = title.replace(/\s*【[^】]*】/g, " ");
        title = title.replace(/\s*《[^》]*》/g, " ");
        title = title.replace(/\s*「[^」]*」/g, " ");
        title = title.replace(/\s*『[^』]*』/g, " ");
        return title.trim();
    }

    implicitWidth: rect.width - General.rectMargin / 1.25
    height: Bar.height + General.rectMargin / 1.5

    Rectangle {
        id: rect
        anchors.verticalCenter: parent.verticalCenter
        implicitWidth: layout.width + General.rectMargin * 4
        height: parent.height - General.rectMargin
        color: Colors.alt
        radius: Style.rounding.smaller

        RowLayout {
            id: layout
            anchors.centerIn: parent
            spacing: Bar.resourceIconTextSpacing / 1.5
            Icon {
                text: root.state
            }
            IText {
                animate: true
                text: root.cleanedTitle
            }
        }

        Canvas {
            id: canvas
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);

                var t = Math.max(0, Math.min(root.progress, 1));
                var bw = 2;
                var r = rect.radius;
                var w = width, h = height;

                var leftHeight = h - 2 * r;
                var topWidth = w - 2 * r;
                var rightHeight = h - 2 * r;

                var seg1 = leftHeight;
                var seg2 = 2 * topWidth + 4 * (r * Math.PI / 2);
                var seg3 = rightHeight;
                var total = seg1 + seg2 + seg3;

                ctx.lineWidth = bw;
                ctx.strokeStyle = Colors.primary;
                ctx.lineCap = "butt";

                var rem = t * total;

                // left edge
                if (rem > 0) {
                    var len = Math.min(rem, seg1);
                    var centerY = h / 2;
                    var halfLen = len / 2;

                    ctx.beginPath();
                    ctx.moveTo(bw / 2, centerY - halfLen);
                    ctx.lineTo(bw / 2, centerY + halfLen);
                    ctx.stroke();

                    rem -= len;
                }

                // top/bottom edges with corners
                if (rem > 0) {
                    var len = Math.min(rem, seg2);
                    var progress = len / seg2;
                    var edgeLen = topWidth * progress;

                    if (progress > 0) {
                        // top-left corner
                        ctx.beginPath();
                        ctx.arc(r, r, r - bw / 2, Math.PI, 3 * Math.PI / 2);
                        ctx.stroke();

                        // bottom-left corner
                        ctx.beginPath();
                        ctx.arc(r, h - r, r - bw / 2, Math.PI / 2, Math.PI);
                        ctx.stroke();

                        // top edge
                        ctx.beginPath();
                        ctx.moveTo(r, bw / 2);
                        ctx.lineTo(r + edgeLen, bw / 2);
                        ctx.stroke();

                        // bottom edge
                        ctx.beginPath();
                        ctx.moveTo(r, h - bw / 2);
                        ctx.lineTo(r + edgeLen, h - bw / 2);
                        ctx.stroke();

                        // top-right and bottom-right corners if complete
                        if (progress >= 1) {
                            ctx.beginPath();
                            ctx.arc(w - r, r, r - bw / 2, 3 * Math.PI / 2, 2 * Math.PI);
                            ctx.stroke();

                            ctx.beginPath();
                            ctx.arc(w - r, h - r, r - bw / 2, 0, Math.PI / 2);
                            ctx.stroke();
                        }
                    }

                    rem -= len;
                }

                // right edge
                if (rem > 0) {
                    var len = Math.min(rem, seg3);
                    var centerY = h / 2;
                    var halfLen = len / 2;

                    // draw upward from center
                    ctx.beginPath();
                    ctx.moveTo(w - bw / 2, centerY);
                    ctx.lineTo(w - bw / 2, centerY - halfLen);
                    ctx.stroke();

                    // draw downward from center
                    ctx.beginPath();
                    ctx.moveTo(w - bw / 2, centerY);
                    ctx.lineTo(w - bw / 2, centerY + halfLen);
                    ctx.stroke();
                }
            }

            onWidthChanged: requestPaint()
            onHeightChanged: requestPaint()
            Connections {
                target: root
                function onProgressChanged() {
                    canvas.requestPaint();
                }
            }
            Connections {
                target: rect
                function onRadiusChanged() {
                    canvas.requestPaint();
                }
            }
        }
    }
}
