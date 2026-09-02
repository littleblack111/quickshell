pragma ComponentBehavior: Bound

import QtQuick

import qs.config

Text {
	id: root

	property bool animate: false
	property real animateFrom: 0
	property real animateTo: 1
	property real multiplier: 1.0
	property real fontSize: Style.font.size.larger

	renderType: Text.NativeRendering // or Text.CurveRendering(much more expansive) or Text.QtRendering for faster
	textFormat: Text.PlainText
	elide: Text.ElideRight
	color: Colors.foreground1
	smooth: true

	wrapMode: TextEdit.Wrap

	font {
		family: Style.font.family.iosevka
		// pointSize: root.pixelSize
		pixelSize: fontSize
	}

	onTextChanged: {
		if (animate) {
			root.scale = animateFrom;
			root.opacity = animateFrom;
			scaleAnim.to = animateTo;
			opacityAnim.to = animateTo;
			scaleAnim.easing.bezierCurve = Style.anim.curves.standardAccel;
			opacityAnim.easing.bezierCurve = Style.anim.curves.standardAccel;
			scaleAnim.start();
			opacityAnim.start();
		}
	}

	onLinkActivated: link => {
		Qt.openUrlExternally(link);
	}

	Behavior on color {
		ColorAnimation {
			duration: Style.anim.durations.normal
			easing.type: Easing.BezierSpline
			easing.bezierCurve: Style.anim.curves.standard
		}
	}

	NumberAnimation {
		id: scaleAnim
		target: root
		property: "scale"
		duration: General.animationDuration / 4 / root.multiplier
		easing.type: Easing.BezierSpline
	}

	NumberAnimation {
		id: opacityAnim
		target: root
		property: "opacity"
		duration: General.animationDuration / 4 / root.multiplier
		easing.type: Easing.BezierSpline
	}
}
