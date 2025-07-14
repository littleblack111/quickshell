import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import qs.components
import qs.config

Loader {
    id: activeWindowLoader
    anchors.centerIn: parent
    active: ToplevelManager.activeToplevel?.activated ? 1 : 0
    sourceComponent: Component {
        Rectangle {
            id: root
            property var toplevel: Hyprland.activeToplevel
            property var icon: Quickshell.iconPath(AppSearch.guessIcon(toplevel?.wayland?.appId), "image-missing")

            // use IRect
            implicitWidth: rowLayout.implicitWidth + General.rectMargin * 4
            implicitHeight: rowLayout.implicitHeight + General.rectMargin * 2
            anchors.centerIn: parent

            color: Colors.alt
            // according to docs, null could happen but doesn't seem to happen in practice so..
            // hypr toplevel.activated is always true and doesn't change either so..
            // opacity: ToplevelManager.activeToplevel?.activated ? 1 : 0

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
                    font.pixelSize: General.fontSize
                    text: root?.toplevel?.wayland?.title || ""
                }
            }
        }
    }
}
