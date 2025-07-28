import Quickshell
import QtQuick

import qs.components

IWidget {
    name: "Math"
    valid: process().valid
    priority: process().priority

    anchors.verticalCenter: parent.verticalCenter
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
