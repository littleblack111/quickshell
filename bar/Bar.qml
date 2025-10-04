import QtQuick
import Quickshell
import QtQuick.Layouts
import qs.components
import qs.config

import ".."

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        IWindow {
            id: barWindow
            name: "quickshell::bar"

            anchors {
                top: true
                left: true
                right: true
            }
            implicitHeight: child.implicitHeight + Bar.topMargin * 2

            IRect {
                id: child
                radius: Bar.borderRadius
                implicitHeight: Bar.height
                implicitWidth: parent.width

                anchors {
                    left: parent.left
                    right: parent.mid
                    fill: parent
                    top: parent.top
                    topMargin: Bar.topMargin
                    leftMargin: Bar.leftMargin
                    rightMargin: Bar.rightMargin
                }

                color: "transparent"

                IRect {
                    id: leftRow
                    anchors {
                        left: parent.left
                    }
                    width: leftInnerRow.width + leftInnerRow.anchors.leftMargin - leftSpacer.width
                    height: leftInnerRow.height
                    color: Qt.rgba(Colors.background3.r, Colors.background3.g, Colors.background3.b, Bar.bgTransparency)
                    radius: Bar.moduleRadius

                    Behavior on color {
                        ColorAnimation {
                            duration: General.animationDuration
                            easing.type: Easing.InOutQuad
                        }
                    }
                    RowLayout {
                        id: leftInnerRow
                        height: child.height
                        spacing: Bar.leftModuleSpacing
                        anchors {
                            left: parent.left
                            leftMargin: Bar.moduleLeftMargin
                        }

                        Workspace {
                            id: workspace
                            // screen: barWindow.screen // multi monitor
                            // Layout.minimumWidth: 400 // FIXME
                        }
                        Mpris {
                            id: mpris
                        }
                        Item {
                            id: leftSpacer
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }
                    }
                }

                Item {
                    id: centerRow
                    anchors.centerIn: parent

                    ActiveWindow {
                        id: activeWindow
                        width: Math.min(implicitWidth, child.width - Math.max(leftRow.width, rightRow.width) * 2 - Bar.leftMargin - Bar.rightMargin) // we don't do child.width - leftRow.width - rightRow.width because left and right width isn't symetric, and we're centered meaning we will colide into the larger width side
                    }
                }

                IRect {
                    id: rightRow
                    anchors.right: parent.right
                    width: rightInnerRow.width + rightInnerRow.anchors.rightMargin - rightSpacer.width
                    height: rightInnerRow.height
                    color: Qt.rgba(Colors.background3.r, Colors.background3.g, Colors.background3.b, Bar.bgTransparency)
                    radius: Bar.moduleRadius

                    RowLayout {
                        id: rightInnerRow
                        anchors {
                            right: parent.right
                            rightMargin: Bar.moduleRightMargin
                        }
                        layoutDirection: Qt.RightToLeft
                        height: child.height
                        spacing: Bar.rightModuleSpacing

                        Power {
                            id: power
                        }
                        // Tray {
                        //     id: tray
                        // }
                        Item {
                            Layout.preferredWidth: timeDateCCWrapper.implicitWidth
                            Layout.preferredHeight: timeDateCCWrapper.implicitHeight
                            IRect {
                                id: timeDateCCWrapper
                                color: Colors.accent
                                radius: Style.rounding.large

                                anchors.fill: parent

                                implicitHeight: Bar.height - General.rectMargin
                                implicitWidth: timeDateCC.width + General.rectMargin * 2
                                RowLayout {
                                    id: timeDateCC
                                    property bool showcc: false
                                    // width: childrenRect.width
                                    // height: childrenRect.height
                                    anchors.centerIn: parent

                                    TimeDate {}
                                    Item {
                                        implicitWidth: timeDateCC.showcc ? ccLoader.width : 0
                                        implicitHeight: timeDateCC.showcc ? ccLoader.height : 0
                                        Loader {
                                            id: ccLoader
                                            active: timeDateCC.showcc
                                            sourceComponent: Component {
                                                Icon {
                                                    text: ""
                                                    SequentialAnimation {
                                                        running: true
                                                        NumberAnimation {
                                                            target: parent
                                                            property: "opacity"
                                                            from: 0
                                                            to: 1
                                                            duration: General.animationDuration / 2
                                                            easing.type: Easing.InOutQuad
                                                        }
                                                    }
                                                    MouseArea {
                                                        anchors.fill: parent
                                                        onPressed: {
                                                            Global.ccProp.active = !Global.ccProp.active;
                                                            let pos = parent.mapToGlobal(0, 0);
                                                            Global.ccProp.x = pos.x;
                                                            Global.ccProp.y = pos.y;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        Behavior on implicitWidth {
                                            NumberAnimation {
                                                duration: General.animationDuration / 4
                                                easing.type: Easing.InOutQuad
                                            }
                                        }
                                    }
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                acceptedButtons: Qt.NoButton // propagate to timedate
                                onEntered: {
                                    timeDateCC.showcc = true;
                                }
                                onExited: {
                                    timeDateCC.showcc = false;
                                }
                            }
                        }
                        Network {}
                        // Temp {
                        //     id: temp
                        // }
                        // Gpu {
                        //     id: gpu
                        // }
                        // Memory {
                        //     id: memory
                        // }
                        // Cpu {
                        //     id: cpu
                        // }
                        Resources {}

                        Item {
                            id: rightSpacer
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: General.animationDuration
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
            }
        }
    }
}
