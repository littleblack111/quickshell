import "../services"
import QtQuick.Layouts
import QtQuick
import Quickshell

Item {
	Layout.preferredHeight: 50
	Layout.preferredWidth: parent.width / 3

	RowLayout {
		anchors.fill: parent
		spacing: 0
		Repeater {
			model: Hyprland.workspaces

			Text {
				text: modelData.active ? modelData.name + " (Active)" : modelData.name
			}
		}
	}
}
