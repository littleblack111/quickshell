import QtQuick
import qs.config

SpringAnimation {
	property real speed: 1.0

	spring: General.springAnimationSpring * (speed * speed)
	damping: General.springAnimationDamping * (speed)
}
