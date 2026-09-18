import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects

import qs.components
import qs.config

Item {
	id: root

	property bool active
	property bool hasImportant: false

	implicitWidth: layout.implicitWidth
	implicitHeight: layout.implicitHeight

	visible: active || hasImportant

	RowLayout {
		id: layout
		anchors.fill: parent

		Repeater {
			Layout.fillHeight: true
			model: SystemTray.items

			delegate: IRect {
				required property SystemTrayItem modelData

				color: "transparent"

				Layout.fillHeight: true
				implicitWidth: childrenRect.width
				implicitHeight: childrenRect.height

				IconImage {
					source: parent.modelData.icon
					implicitSize: parent.height
				}

				IToolTip {
					active: (modelData.tooltipTitle || modelData.tooltipDescription)
					text: (modelData.tooltipTitle || '') + (modelData.tooltipTitle && modelData.tooltipDescription ? '\n' : '') + (modelData.tooltipDescription || '')
				}

				function syncImportance() {
					if (modelData?.status === Status.Active || modelData?.status === Status.NeedsAttention)
						root.hasImportant = true;
					else if (SystemTray.items.values.every(item => item.status === Status.Passive))
						root.hasImportant = false;
				}

				Component.onCompleted: {
					syncImportance();
				}

				Connections {
					target: modelData

					function onStatusChanged() {
						syncImportance();
					}
				}

				TapHandler {
					acceptedButtons: Qt.LeftButton
					onTapped: parent.modelData.activate()
				}
				TapHandler {
					acceptedButtons: Qt.MiddleButton
					onTapped: parent.modelData.secondaryActivate()
				}
				TapHandler {
					acceptedButtons: Qt.RightButton
					onTapped: (eventPoint, button) => parent.modelData.display(barWindow, eventPoint.scenePosition.x, eventPoint.scenePosition.y)
				}
				WheelHandler {
					onWheel: event => parent.modelData.scroll(event.angleDelta.y)
				}
				HoverHandler {
					id: hover
				}
			}
		}
	}
}
