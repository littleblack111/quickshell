pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

import qs.utils

Singleton {
	id: root

	property var _componentHistory: ({})
	property var _launcherHistory: []
	readonly property int maxHistoryItems: 50

	function trackComponentAction(componentName, input, data) {
		if (!componentName || !input)
			return;

		const timestamp = new Date();
		const historyItem = {
			input: input,
			data: data,
			timestamp: timestamp,
			count: 1
		};

		if (!_componentHistory[componentName])
			_componentHistory[componentName] = [];

		const existingIndex = _componentHistory[componentName].findIndex(
			item => item.input === input && JSON.stringify(item.data) === JSON.stringify(data)
		);

		let newHistory = _componentHistory[componentName].slice();

		if (existingIndex >= 0) {
			const existingItem = newHistory[existingIndex];
			existingItem.count++;
			existingItem.timestamp = timestamp;
			newHistory.splice(existingIndex, 1);
			newHistory.unshift(existingItem);
		} else {
			newHistory.unshift(historyItem);
		}

		if (newHistory.length > maxHistoryItems) {
			newHistory = newHistory.slice(0, maxHistoryItems);
		}

		const updated = {};
		for (const key in _componentHistory) {
			if (_componentHistory.hasOwnProperty(key)) {
				updated[key] = _componentHistory[key];
			}
		}
		updated[componentName] = newHistory;
		_componentHistory = updated;
	}

	function getComponentHistory(componentName) {
		return _componentHistory[componentName] || [];
	}

	function trackLauncherAction(input, componentName, selectedData) {
		if (!input && !componentName)
			return;

		const timestamp = new Date();
		const historyItem = {
			input: input,
			componentName: componentName,
			selectedData: selectedData,
			timestamp: timestamp,
			count: 1
		};

		const existingIndex = _launcherHistory.findIndex(
			item => item.input === input && item.componentName === componentName
		);

		let newHistory = _launcherHistory.slice();

		if (existingIndex >= 0) {
			const existingItem = newHistory[existingIndex];
			existingItem.count++;
			existingItem.timestamp = timestamp;
			existingItem.selectedData = selectedData;
			newHistory.splice(existingIndex, 1);
			newHistory.unshift(existingItem);
		} else {
			newHistory.unshift(historyItem);
		}

		if (newHistory.length > maxHistoryItems) {
			newHistory = newHistory.slice(0, maxHistoryItems);
		}

		_launcherHistory = newHistory;
	}

	function getLauncherHistory() {
		return _launcherHistory;
	}

	function getSortedHistoryByFrequency(componentName) {
		const history = getComponentHistory(componentName);
		return history.slice().sort((a, b) => {
			if (b.count !== a.count) {
				return b.count - a.count;
			}
			return new Date(b.timestamp) - new Date(a.timestamp);
		});
	}

	function getRecentHistory(componentName, limit) {
		if (limit === undefined) limit = 10;
		const history = getComponentHistory(componentName);
		return history.slice(0, limit);
	}

	Persistent {
		id: componentHistoryStore
		filePath: `${Directories.state}/launcher-component-history.json`
		adapter: JsonAdapter {
			property var componentHistory: ({})
		}
		fileView.onLoaded: {
			const history = adapter.componentHistory;
			for (const componentName in history) {
				if (history[componentName] && Array.isArray(history[componentName])) {
					history[componentName].forEach(item => {
						if (item.timestamp && typeof item.timestamp === "string") {
							item.timestamp = new Date(item.timestamp);
						}
					});
				}
			}
			root._componentHistory = history;
		}
	}

	Persistent {
		id: launcherHistoryStore
		filePath: `${Directories.state}/launcher-history.json`
		adapter: JsonAdapter {
			property var launcherHistory: []
		}
		fileView.onLoaded: {
			const history = adapter.launcherHistory;
			if (Array.isArray(history)) {
				history.forEach(item => {
					if (item.timestamp && typeof item.timestamp === "string") {
						item.timestamp = new Date(item.timestamp);
					}
				});
			}
			root._launcherHistory = history;
		}
	}

	on_ComponentHistoryChanged: {
		componentHistoryStore.adapter.componentHistory = _componentHistory;
	}

	on_LauncherHistoryChanged: {
		launcherHistoryStore.adapter.launcherHistory = _launcherHistory;
	}
}