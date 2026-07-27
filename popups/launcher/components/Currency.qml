import core

ISmartCalc {
	symbol: "💱"
	category: SmartCalc.result_type == SmartCalc.Currency || SmartCalc.result_type == SmartCalc.Crypto
	predictiveText: '→'
}
