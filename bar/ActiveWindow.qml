import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import qs.components
import qs.config

Rectangle {
    id: root
    property var toplevel: Hyprland.activeToplevel
    property var icon: Quickshell.iconPath(AppSearch.guessIcon(toplevel?.wayland?.appId), "image-missing")

    // use IRect
    implicitWidth: rowLayout.implicitWidth + General.rectMargin * 4
    implicitHeight: rowLayout.implicitHeight + General.rectMargin * 2
    anchors.centerIn: parent

    color: Colors.alt
    radius: Style.rounding.smaller

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent
        spacing: Bar.resourceIconTextSpacing

        IconImage {
            source: root.icon
            implicitWidth: Bar.appIconSize
            implicitHeight: Bar.appIconSize
            Layout.fillHeight: true
            Layout.fillWidth: false
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        }
        IText {
            // TOOD: if not exist, use lazyloader or something hide this
            font.pixelSize: General.fontSize
            text: root?.toplevel?.title || ""
        }
    }
}
