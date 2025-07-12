import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import qs.utils
import qs.config

Item {
    id: root
    property var toplevel: ToplevelManager.activeToplevel
    property var icon: Quickshell.iconPath(AppSearch.guessIcon(toplevel?.appId), "image-missing")

    RowLayout {
        anchors.centerIn: parent
        spacing: Bar.resourceIconTextSpacing

        anchors.verticalCenter: parent.verticalCenter
        IconImage {
            source: root.icon
            implicitWidth: Bar.appIconSize
            implicitHeight: Bar.appIconSize
            Layout.fillHeight: true
            Layout.fillWidth: false
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        }
        Text {
            // TOOD: if not exist, use lazyloader or something hide this
            text: root.toplevel?.title
        }
    }
}
