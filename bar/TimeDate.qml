import QtQuick
import QtQuick.Layouts

import qs.services as Services
import qs.components
import qs.config

Item {
    implicitWidth: container.implicitWidth
    implicitHeight: container.implicitHeight - General.rectMargin
    Rectangle {
        id: container
        anchors {
            fill: parent
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }

        implicitWidth: layout.implicitWidth + General.rectMargin * 2
        implicitHeight: Bar.height

        color: WallustColors.color4
        radius: Style.rounding.large

        RowLayout {
            id: layout
            Item {
                Layout.fillWidth: true
            }
            anchors.fill: parent
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
        }
    }
}
