import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import qs.components
import qs.config

Item {
    id: root
    property var toplevel: Hyprland.activeToplevel
    property var icon: Quickshell.iconPath(AppSearch.guessIcon(toplevel?.wayland.appId), "image-missing")

    // use IRect
    implicitWidth: rowLayout.implicitWidth + General.rectMargin * 2
    implicitHeight: rowLayout.implicitHeight + General.rectMargin * 2
    anchors.centerIn: parent

    RowLayout {
        id: rowLayout
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
            // TODO: use IText
            font.pixelSize: General.fontSize
            text: root.toplevel?.title
        }
    }
}
