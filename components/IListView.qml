import QtQuick

ListView {
	id: root

	property PropertyAnimation scrollAnim: ISpringAnimation {}

	function scrollToIndex(idx, alignment = ListView.Contain) {
		root.scrollAnim.stop();
		let y = root.contentY;

		root.positionViewAtIndex(idx, alignment);
		let dsty = root.contentY;

		root.contentY = y;

		if (root.scrollAnim) {
			root.scrollAnim.target = root;
			root.scrollAnim.property = "contentY";
			root.scrollAnim.from = y;
			root.scrollAnim.to = dsty;
			root.scrollAnim.start();
		} else
			root.contentY = dsty;
	}

	Connections {
		target: root.scrollAnim

		function onStopped() {
			// root.positionViewAtIndex(targetIndex, alignment);
		}
	}
}
