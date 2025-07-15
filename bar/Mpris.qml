import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import qs.services as Services
import qs.config
import qs.components

Item {
    id: root
    readonly property MprisPlayer activePlayer: Services.Mpris.activePlayer
    readonly property real progress: (activePlayer?.positionSupported && activePlayer?.lengthSupported && activePlayer?.length > 0) ? activePlayer?.position / activePlayer?.length : 0
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

    implicitWidth: activePlayer ? rect.width - General.rectMargin / 1.25 : 0
    height: Bar.height + General.rectMargin / 1.5
    opacity: activePlayer ? 1 : 0

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
            Image {
                source: activePlayer.trackArtUrl
                fillMode: Image.PreserveAspectFit
                Layout.preferredWidth: Bar.appIconSize
                cache: true
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
                var arcLen = r * Math.PI / 2;

                var seg1 = leftHeight;
                var seg2 = 2 * topWidth + 4 * arcLen;
                var seg3 = leftHeight;
                var total = seg1 + seg2 + seg3;

                ctx.lineWidth = bw;
                ctx.strokeStyle = Colors.primary;
                ctx.lineCap = "butt";

                var rem = t * total;

                if (rem > 0) {
                    var len1 = Math.min(rem, seg1);
                    var up1 = Math.min(len1, leftHeight / 2);
                    var down1 = up1;

                    ctx.beginPath();
                    ctx.moveTo(bw / 2, h / 2 - up1);
                    ctx.lineTo(bw / 2, h / 2 + down1);
                    ctx.stroke();

                    rem -= len1;
                }

                if (rem > 0) {
                    var len2 = Math.min(rem, seg2);
                    var prog2 = len2 / seg2;
                    var edgeLen = topWidth * (prog2 * 2);

                    if (len2 > 0) {
                        ctx.beginPath();
                        ctx.arc(r, r, r - bw / 2, Math.PI, 1.5 * Math.PI);
                        ctx.stroke();

                        ctx.beginPath();
                        ctx.arc(r, h - r, r - bw / 2, 0.5 * Math.PI, Math.PI);
                        ctx.stroke();

                        var topDraw = Math.min(edgeLen, topWidth);
                        ctx.beginPath();
                        ctx.moveTo(r, bw / 2);
                        ctx.lineTo(r + topDraw, bw / 2);
                        ctx.stroke();

                        var botDraw = topDraw;
                        ctx.beginPath();
                        ctx.moveTo(r, h - bw / 2);
                        ctx.lineTo(r + botDraw, h - bw / 2);
                        ctx.stroke();

                        if (len2 >= seg2) {
                            ctx.beginPath();
                            ctx.arc(w - r, r, r - bw / 2, 1.5 * Math.PI, 2 * Math.PI);
                            ctx.stroke();

                            ctx.beginPath();
                            ctx.arc(w - r, h - r, r - bw / 2, 0, 0.5 * Math.PI);
                            ctx.stroke();
                        }
                    }

                    rem -= len2;
                }

                if (rem > 0) {
                    var len3 = Math.min(rem, seg3);
                    var up3 = Math.min(len3, leftHeight / 2);
                    var down3 = up3;

                    ctx.beginPath();
                    ctx.moveTo(w - bw / 2, h / 2 - up3);
                    ctx.lineTo(w - bw / 2, h / 2 + down3);
                    ctx.stroke();
                }
            }
            onWidthChanged: canvas.requestPaint()
            onHeightChanged: canvas.requestPaint()
            Connections {
                target: root
                onProgressChanged: canvas.requestPaint()
            }
            Connections {
                target: rect
                onRadiusChanged: canvas.requestPaint()
            }
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: General.animateDuration / 4
        }
    }
    Behavior on implicitWidth {
        ISpringAnimation {
            spring: General.springAnimationSpring * 2
            damping: General.springAnimationDamping * 1.3
        }
    }
}
