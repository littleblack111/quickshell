pragma Singleton
// pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

import qs.config

import core

Singleton {
    id: root

    property var result: Calc.result
	property int result_type: Calc.result_type
	readonly property var resultType: ({
        "Math": Calc.Math,
        "Unit": Calc.Unit,
        "Currency": Calc.Currency,
        "Crypto": Calc.Crypto,
        "Time": Calc.Time,
        "Date": Calc.Date,
        "Unset": Calc.Unset
    })

    function query(input: string) {
	    console.log(input)
	   	Calc.query(input);
    }


    // FIXME: we'll prolly need to reset() everytime here after it finish just so the next time another component using it won't be affected by the previous query
    function reset() {
		Calc.reset();
	}
}
