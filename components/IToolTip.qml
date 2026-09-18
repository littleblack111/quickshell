import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

import qs.components
import qs.config

ToolTip {
	id: root

	property bool active

	visible: hover.hovered && active
	delay: General.toolTipDelay

	contentItem: IText {
		text: root.text
	}

	background: Rectangle {
		color: Qt.rgba(Colors.background3.r, Colors.background3.g, Colors.background3.b, General.toolTipBackgroundOpacity)
	}
}
