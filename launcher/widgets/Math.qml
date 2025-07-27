import Quickshell
import QtQuick

IWidget {
    required property string input
    name: "Math"
    process: function () {
        // use regex to check if data is a valid math expression
        var isValid = /^[0-9+\-*/()%.\s]+$/.test(input);
        return {
            visible: isValid,
            priority: isValid
        };
    }
}
