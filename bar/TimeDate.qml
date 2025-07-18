import QtQuick
import QtQuick.Layouts

import qs.services as Services
import qs.components
import qs.config

Item {
    id: root

    property bool isAlt: false
    property bool isCollapsed: false

    implicitWidth: container.implicitWidth
    implicitHeight: container.implicitHeight - General.rectMargin
    Rectangle {
        id: container
        anchors {
            fill: parent
            centerIn: parent
        }

        // implicitWidth: !isAlt ? nonAlt.implicitWidth + General.rectMargin * 2 : alt.implicitWidth + General.rectMargin * 2
        implicitWidth: layout.width + General.rectMargin * 2
        implicitHeight: Bar.height

        color: WallustColors.color4
        radius: Style.rounding.large

        RowLayout {
            id: layout
            anchors.centerIn: parent
            spacing: Bar.resourceIconTextSpacing
            Loader {
                sourceComponent: !root.isAlt ? main : alt
                readonly property Component main: Component {
                    RowLayout {
                        Item {
                            Layout.fillWidth: true
                        }
                        anchors.centerIn: parent
                        spacing: Bar.resourceIconTextSpacing

                        Icon {
                            text: Icons.resource.clock
                            font.pixelSize: Style.font.size.larger
                        }
                        RowLayout {
                            property int h: Services.TimeDate.hours
                            property int m: Services.TimeDate.minutes
                            property int s: Services.TimeDate.seconds
                            spacing: 0
                            IText {
                                animate: true
                                text: (parent.h >= 10 ? "" : "0") + parent.h
                            }
                            IText {
                                text: ":"
                            }
                            IText {
                                animate: true
                                text: (parent.m >= 10 ? "" : "0") + parent.m
                            }
                            IText {
                                text: ":"
                            }
                            IText {
                                animate: true
                                text: (parent.s >= 10 ? "" : "0") + parent.s
                            }
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                        SequentialAnimation {
                            running: true
                            NumberAnimation {
                                target: parent
                                property: "opacity"
                                from: 0
                                to: 1
                                duration: General.animateDuration / 2
                            }
                        }
                    }
                }
                readonly property Component alt: Component {
                    RowLayout {
                        Item {
                            Layout.fillWidth: true
                        }
                        anchors.centerIn: parent
                        spacing: Bar.resourceIconTextSpacing

                        Icon {
                            text: Icons.resource.calendar
                            font.pixelSize: Style.font.size.larger
                        }
                        IText {
                            animate: true
                            text: Services.TimeDate.date
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                        SequentialAnimation {
                            running: true
                            NumberAnimation {
                                target: parent
                                property: "opacity"
                                from: 0
                                to: 1
                                duration: General.animateDuration / 2
                            }
                        }
                    }
                }
            }
        }
    }
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onPressed: {
            root.isAlt = !root.isAlt;
        }
    }
}
