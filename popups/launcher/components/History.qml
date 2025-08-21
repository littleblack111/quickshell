import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.services
import qs.config

IComponent {
	id: root

	property var historyData: active ? History.getLauncherHistory() : []
	property var filteredHistory: active ? filterHistory() : []
	property int selectedIndex: -1

	name: "History"

	prefix: "history"

	implicitHeight: valid ? layout.height : 0

	function filterHistory() {
		const history = historyData || [];
		if (!inputCleaned) {
			return history.slice(0, 10);
		}
		
		return history.filter(item => {
			const searchText = inputCleaned.toLowerCase();
			return (item.input && item.input.toLowerCase().includes(searchText)) ||
				   (item.componentName && item.componentName.toLowerCase().includes(searchText));
		}).slice(0, 10);
	}

	getSelectedData: function() {
		return selectedIndex >= 0 && filteredHistory[selectedIndex] ? filteredHistory[selectedIndex] : null;
	}

	process: function () {
		const isValid = filteredHistory.length > 0;
		return {
			valid: isValid,
			priority: isValid && inputCleaned.length > 0
		};
	}

	exec: function () {
		const item = filteredHistory[selectedIndex];
		if (item && item.input) {
			state.input = item.input;
		}
	}

	up: function () {
		if (selectedIndex <= 0)
			return true;
		selectedIndex--;
	}
	down: function () {
		if (selectedIndex + 1 > listView.count - 1)
			return true;
		selectedIndex++;
	}
	home: function () {
		if (selectedIndex <= 0)
			return true;
		selectedIndex = -1;
		selectedIndex = 0;
	}
	end: function () {
		if (selectedIndex + 1 > listView.count - 1)
			return true;
		selectedIndex = listView.count - 1;
	}

	onFilteredHistoryChanged: {
		if (selectedIndex !== -1) {
			syncSelectionState();
			return;
		}

		selectedIndex = 0;
		listView.positionViewAtBeginning();
		syncSelectionState();
	}

	onSelectedIndexChanged: {
		if (selectedIndex >= 0 && selectedIndex < listView.count) {
			Qt.callLater(() => {
				listView.positionViewAtIndex(selectedIndex, ListView.Contain);
			});
		}
		syncSelectionState();
	}

	syncSelectionState: function () {
		Qt.callLater(() => {
			if (!root.visible || selectedIndex < 0 || selectedIndex >= listView.count)
				return;
			state.selected = listView.itemAtIndex(selectedIndex);
		});
	}

	IInnerComponent {
		id: layout
		fromParent: false
		width: parent.width
		height: Math.min(listView.contentHeight + titleBar.height, Launcher.widgetHeight)

		ListView {
			id: listView
			Layout.fillWidth: true
			Layout.fillHeight: true
			clip: true
			model: filteredHistory
			spacing: 0

			delegate: Item {
				required property var modelData
				required property int index
				width: Math.min(item.implicitWidth + Launcher.innerMargin * 4, listView.width)
				height: item.height + Launcher.innerMargin * 4

				Row {
					id: item
					anchors.left: parent.left
					anchors.top: parent.top
					anchors.margins: Launcher.innerMargin * 2
					spacing: Launcher.innerMargin * 2
					clip: true

					Icon {
						text: ""
						color: index === root.selectedIndex ? Colors.foreground1 : Colors.foreground2
					}

					Column {
						IText {
							text: modelData?.input || ""
							color: index === root.selectedIndex ? Colors.foreground1 : Colors.foreground2
							font.pixelSize: Launcher.widgetFontSize
						}
						Row {
							spacing: Launcher.innerMargin
							property string sinceWhen: TimeDate.sinceWhen(modelData?.timestamp) || ""
							IText {
								text: modelData?.componentName || ""
								color: index === root.selectedIndex ? Colors.foreground2 : Colors.foreground3
								font.pixelSize: Launcher.widgetFontSize / 1.35
							}
							IText {
								visible: modelData?.count > 1
								text: `×${modelData.count}`
								color: Colors.accent
								font.pixelSize: Launcher.widgetFontSize / 1.35
							}
							IText {
								visible: parent.sinceWhen
								text: '·'
								color: index === root.selectedIndex ? Colors.foreground2 : Colors.foreground3
								font.pixelSize: Launcher.widgetFontSize / 1.35
							}
							IText {
								text: parent.sinceWhen || ""
								color: index === root.selectedIndex ? Colors.foreground2 : Colors.foreground3
								font.pixelSize: Launcher.widgetFontSize / 1.35
							}
						}
					}
				}

				MouseArea {
					anchors.fill: parent
					hoverEnabled: true
					onPositionChanged: {
						root.selectedIndex = index;
					}
					onPressed: {
						root._exec();
					}
				}
			}
		}
	}
}