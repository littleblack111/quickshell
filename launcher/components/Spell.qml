import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.config

IComponent {
    id: root
    property int cursorPosition: SelectionState.cursorPosition
    property list<string> aspell
    property string word: inputCleaned.slice(prefix.length)
    name: "Spell"
    prefix: name.toLowerCase() + ' '

    onInputCleanedChanged: {
        if (!inputCleaned.startsWith(prefix) || !inputCleaned.slice(prefix.length)) {
            aspell = [];
            return;
        }
        Qt.callLater(() => {
            proc.running = true;
        });
    }

    process: function () {
        const answer = aspell[0];
        const isValid = answer && answer.length > 0;
        return {
            valid: isValid,
            priority: isValid,
            answer: isValid && answer !== '*' ? answer : '',
            predictiveCompletion: isValid && answer !== '*' ? answer.slice(word.length) : ''
        };
    }
    // todo: exec = clip.copy(answer)

    IInnerComponent {
        Loader {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: parent.height
            sourceComponent: aspell[0] === '*' ? correct : show
            readonly property Component show: Component {
                Flow {
                    Repeater {
                        Layout.fillWidth: true
                        model: aspell

                        // Display each aspell suggestion
                        IRect {
                            implicitWidth: item.width + Launcher.innerMargin * 2
                            implicitHeight: item.height + Launcher.innerMargin * 2
                            color: Qt.rgba(Colors.background2.r, Colors.background2.g, Colors.background2.b, Launcher.widgetBgTransparency)
                            radius: Launcher.widgetRadius
                            IText {
                                id: item
                                anchors.centerIn: parent
                                text: modelData
                                font.pixelSize: Launcher.widgetFontSize
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                }
            }
            readonly property Component correct: Component {
                IRect {
                    Layout.fillWidth: true
                    color: Qt.rgba(Colors.background1.r, Colors.background1.g, Colors.background1.b, Launcher.widgetBgTransparency / 4)
                    radius: Launcher.widgetRadius
                    IText {
                        anchors.centerIn: parent
                        text: "Correct"
                        font.pixelSize: Launcher.widgetFontSize
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        }
    }

    // TODO move to services/ if we need this in other places
    Process {
        id: proc
        command: ["sh", "-c", "echo " + word + " | aspell -a"]
        onStarted: {
            aspell = [];
        }
        stdout: SplitParser {
            onRead: data => {
                if (data.startsWith('&'))
                    aspell = data.split(/\W+/).filter(word => /^[A-Za-z]+$/.test(word)).slice(1);
                else if (data.startsWith('*'))
                    aspell = ['*'];
            }
        }
    }
}
