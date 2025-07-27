import Quickshell
import QtQuick

import "widgets"
import qs.components

ILauncher {
    property string input: "a"
    Math {
        input: input
    }
}
