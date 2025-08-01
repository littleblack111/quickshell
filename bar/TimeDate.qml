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
    IRect {
        id: container
        anchors {
            fill: parent
            centerIn: parent
        }

        // implicitWidth: !isAlt ? nonAlt.implicitWidth + General.rectMargin * 2 : alt.implicitWidth + General.rectMargin * 2
        implicitWidth: layout.width + General.rectMargin * 2
        implicitHeight: Bar.height

        color: Colors.accent
        radius: Style.rounding.large

        RowLayout {
            id: layout
            anchors.centerIn: parent
            spacing: Bar.resourceIconTextSpacing
            Loader {
                sourceComponent: !root.isAlt ? main : alt
                readonly property Component main: Component {
                    RowLayout {
                        id: root
                        property int h: Services.TimeDate.hours
                        property int m: Services.TimeDate.minutes
                        property int s: Services.TimeDate.seconds

                        Item {
                            Layout.fillWidth: true
                        }
                        anchors.centerIn: parent
                        spacing: Bar.resourceIconTextSpacing

                        Icon {
                            text: Icons.resource.clock[root.h - 1]
                            font.pixelSize: Style.font.size.larger
                        }
                        RowLayout {
                            spacing: 0
                            IText {
                                animate: true
                                text: (root.h >= 10 ? "" : "0") + root.h
                            }
                            IText {
                                text: ":"
                            }
                            IText {
                                animate: true
                                text: (root.m >= 10 ? "" : "0") + root.m
                            }
                            IText {
                                text: ":"
                            }
                            IText {
                                animate: true
                                text: (root.s >= 10 ? "" : "0") + root.s
                                renderType: Text.CurveRendering // it's not static and is rapidly updated
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
                                duration: General.animationDuration / 2
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
                                duration: General.animationDuration / 2
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
