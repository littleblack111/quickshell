import Quickshell
import QtQuick

import qs.components

IWidget {
    name: "Math"
    valid: process().valid
    priority: process().priority

    anchors.verticalCenter: parent.verticalCenter
    process: function () {
        // use regex to check if data is a valid math expression
        var isValid = /^[0-9+\-*/()%.\s]+$/.test(input);
        return {
            valid: isValid,
            priority: isValid
        };
        console.log("Math process called with input:", input, "valid:", isValid);
    }

    IText {
        visible: valid
        text: valid ? eval(input) : ""
    }
}
