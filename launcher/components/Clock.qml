import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.services
import qs.config
import "../../utils/TimeDate.js" as TimeDateJS

IComponent {
    property int offset
    property string abbr
    name: "Clock"

    preview: Component {
        Icon {
            text: ""
        }
    }

    process: function () {
        console.log(TimeDateJS.time);
        if (!inputCleaned.endsWith('time') && !inputCleaned.endsWith('t'))
            return;

        const query = TimeDate.tzData.find(e => e.names.some(n => n.endsWith('Time') || n.endsWith('T') ? n.toLowerCase() === input.toLowerCase() : n.toLowerCase() + ' time' === input.toLowerCase() || n.toLowerCase() + 't' === input.toLowerCase()));
        const isValid = query !== undefined;

        if (!isValid)
            return;

        const now = new Date();

        const remoteTime = now.toLocaleTimeString(undefined, {
            timeZone: query.zone,
            hour12: true,
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit'
        });

        offset = (new Date(now.toLocaleString(undefined, {
                timeZone: query.zone,
                year: 'numeric',
                month: '2-digit',
                day: '2-digit',
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit'
            })).getTime() - now.getTime()) / 3600000;

        abbr = now.toLocaleTimeString('en-US', {
            timeZone: query.zone,
            timeZoneName: 'short'
        }).split(' ').pop();

        return {
            valid: isValid,
            priority: isValid,
            answer: remoteTime,
            predictiveCompletion: isValid ? ' is currently ' + remoteTime : ''
        };
    }
    // todo: exec = clip.copy(answer)

    IInnerComponent {
        RowLayout {
            spacing: 0
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: parent.height

            Item {
                Layout.fillWidth: true
                ColumnLayout {
                    anchors.centerIn: parent
                    IText {
                        Layout.alignment: Qt.AlignHCenter
                        elide: cursorPosition > input.length / 2 ? Text.ElideLeft : Text.ElideRight
                        width: Math.min(implicitWidth, parent.width - Launcher.innerMargin * 2)
                        clip: true
                        renderType: Text.CurveRendering
                        visible: valid
                        text: input.replace(/ /g, "").replace(/\+/g, " + ").replace(/-/g, " - ").replace(/\*/g, " × ").replace(/\//g, " ÷ ").replace(/%/g, " % ").replace(/\(/g, " ( ").replace(/\)/g, " ) ")
                        font {
                            pixelSize: Launcher.widgetFontSize
                            bold: true
                        }
                    }
                    IText {
                        Layout.alignment: Qt.AlignHCenter
                        elide: cursorPosition > input.length / 2 ? Text.ElideLeft : Text.ElideRight
                        width: Math.min(implicitWidth, parent.width - Launcher.innerMargin * 2)
                        clip: true
                        renderType: Text.CurveRendering
                        visible: valid
                        text: root.abbr
                        font {
                            pixelSize: Launcher.widgetFontSize
                            bold: true
                        }
                    }
                }
            }

            IText {
                visible: valid
                text: "→"
                font.pixelSize: Launcher.widgetFontSize
                font.bold: true
            }

            Item {
                Layout.fillWidth: true
                IText {
                    animate: true
                    anchors.centerIn: parent
                    width: Math.min(implicitWidth, parent.width - Launcher.innerMargin * 2)
                    renderType: Text.CurveRendering
                    visible: valid
                    text: valid ? answer : ''
                    font {
                        pixelSize: Launcher.widgetFontSize
                        bold: true
                    }
                }
            }
        }
    }
}
