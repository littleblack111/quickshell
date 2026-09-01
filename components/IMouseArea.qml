/// NOTE: This is not zero cost, there's performance penalty, only use this instead of mousearea if hover is strictly required to be still
/// Such as when the component may appear where the mouse is already is

import QtQuick

MouseArea {
    hoverEnabled: true

    property real gx: Number.MAX_VALUE
    property real gy: Number.MAX_VALUE

    property bool hovered: false

    signal entered_
    signal positionChanged_(var mouse)

    onPositionChanged: mouse => {
        let gpos = mapToItem(null, mouse.x, mouse.y);

        if (gx === Number.MAX_VALUE && gy === Number.MAX_VALUE) {
            gx = gpos.x;
            gy = gpos.y;
            return;
        }

        if (gpos.x === gx && gpos.y === gy)
            return;

        gx = gpos.x;
        gy = gpos.y;

        if (!hovered) {
            hovered = true;
            entered_();
        }

        positionChanged_(mouse);
    }

    onExited: {
        hovered = false;
        gx = Number.MAX_VALUE;
        gy = Number.MAX_VALUE;
    }
}
