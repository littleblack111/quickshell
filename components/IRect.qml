import QtQuick
import qs.config

Rectangle {
	Behavior on color {
		ColorAnimation {
			duration: General.animationDuration
			easing.type: Easing.InOutQuad
		}
	}
}
