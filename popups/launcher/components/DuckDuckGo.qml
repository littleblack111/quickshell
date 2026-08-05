import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.services
import qs.config

import core

IComponent {
    property int cursorPosition: SelectionState.cursorPosition
    property bool expand: false

    height: valid ? expand ? layout.implicitHeight + (Launcher.duckduckgoSpacing * 2) : Launcher.widgetHeight : 0

    name: "DuckDuckGo" // subclass of WebSearch in the future
    preview: Component {
        Icon {
            text: "🌐"
        }
    }

    onInputChanged: {
        // TODO: think of this should be part of rs backend .query fn
        DuckDuckGo.reset();
    }

    // TODO: decouple all query logic from process -> onInputCleanedChanged and resetting / temp state on speciifc input -> onInputChanged
    onInputCleanedChanged: {
        if (inputCleaned)
            DuckDuckGo.query(inputCleaned);
    }

    process: function () {
        const valid = DuckDuckGo.ok;
        const answer = DuckDuckGo.title || DuckDuckGo.description_html;
        return {
            valid,
            priority: valid,
            answer,
            predictiveCompletion: valid ? ' is ' + answer : ''
        };
    }
    exec: function () {
    // FIXME: doesn't work as enter closes the launcher
    if (!expand)
		expand = true;
    else
       	Clip.copy(`{DuckDuckGo.title}\n{DuckDuckGo.description_html}`);
    }

    IInnerComponent {
        anchors.margins: Launcher.duckduckgoSpacing
        RowLayout {
		    id: layout
            spacing: Launcher.duckduckgoSpacing
            Layout.fillWidth: true
            Layout.fillHeight: true

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 0
                Layout.maximumWidth: image.maxWidth
                Layout.minimumWidth: 0

                visible: image.status === Image.Ready

                Image {
                    property real maxWidth: status === Image.Ready ? implicitWidth : 0

                    id: image
                    anchors.fill: parent

                    fillMode: Image.PreserveAspectCrop

                    opacity: status === Image.Ready ? 1 : 0

                    source: DuckDuckGo.image
                    asynchronous: true

                    Behavior on opacity {
                        NumberAnimation {
                            duration: General.animationDuration / 4
                        }
                    }

                    Behavior on maxWidth {
                        ISpringAnimation {}
                    }
                }
            }

            ColumnLayout {
                Layout.preferredWidth: 3
                Layout.minimumWidth: 0
                Layout.fillHeight: true
                Layout.fillWidth: true

                spacing: Launcher.duckduckgoImageSpacing / 4

                ITextEdit {
                    animate: true

                    Layout.alignment: Qt.AlignTop
                    Layout.fillWidth: true

                    readOnly: true
                    renderType: Text.CurveRendering
                    visible: valid
                    text: answer
                    font {
                        pixelSize: Launcher.widgetFontSize * 1.1
                        bold: true
                    }
                }

                ITextEdit {
                    animate: true

                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    readOnly: true
                    renderType: Text.CurveRendering
                    visible: valid && DuckDuckGo.title
                    text: DuckDuckGo.title ? DuckDuckGo.description_html : ''
                    font {
                        pixelSize: Launcher.widgetFontSize
                    }

                    TapHandler {
                    	gesturePolicy: TapHandler.DragThreshold
                     	onTapped: expand = !expand
                    }
                }
            }
        }
    }
}
