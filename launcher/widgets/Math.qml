import Quickshell
import QtQuick

import qs.components

IWidget {
    name: "Math"
    anchors.verticalCenter: parent.verticalCenter
    valid: processed.valid
    priority: processed.priority

    process: function () {
        var isValid = /^[0-9+\-*/()%.\s]+$/.test(input);
        return {
            valid: isValid,
            priority: isValid
        };
    }

    IText {
        visible: valid
        text: valid ? eval(input) : ""
    }
}
