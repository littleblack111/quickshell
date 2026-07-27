import core

ISmartCalc {
	symbol: "📅"
	category: SmartCalc.result_type == SmartCalc.Time || SmartCalc.result_type == SmartCalc.Date
	predictiveText: 'is'
}
