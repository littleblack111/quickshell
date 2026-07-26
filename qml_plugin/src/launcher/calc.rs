use cxx_qt::{QObject, Threading};
use cxx_qt_lib::{QDateTime, QString, QVariant};
use std::{pin::Pin, sync::mpsc, time::Duration};

use crate::RUNTIME;

#[cxx_qt::bridge]
mod qobject {
    extern "C++" {
        include!("cxx-qt-lib/qstring.h");
        include!("cxx-qt-lib/qvariant.h");
        type QString = cxx_qt_lib::QString;
        type QVariant = cxx_qt_lib::QVariant;
    }

    extern "RustQt" {
        #[qobject]
        #[qml_element]
        #[qml_singleton]
        #[qproperty(
            QVariant, result
        )]
        #[qproperty(
            ResultType,
            result_type
        )]
        type SmartCalc = super::SmartCalcRs;

        #[qinvokable]
        fn query(self: Pin<&mut SmartCalc>, input: QString);

        #[qinvokable]
        fn reset(self: Pin<&mut SmartCalc>);
    }

    impl cxx_qt::Threading for SmartCalc {}

    #[qenum(SmartCalc)]
    pub enum ResultType {
        Math,
        Unit,
        Currency,
        Crypto,
        Time,
        Date,
        Unset,
    }
}

impl Default for qobject::ResultType {
    fn default() -> Self {
        qobject::ResultType::Unset
    }
}

impl From<&smart_calculator::types::ResultType> for qobject::ResultType {
    fn from(value: &smart_calculator::types::ResultType) -> Self {
        match value {
            smart_calculator::types::ResultType::Math => qobject::ResultType::Math,
            smart_calculator::types::ResultType::Unit => qobject::ResultType::Unit,
            smart_calculator::types::ResultType::Currency => qobject::ResultType::Currency,
            smart_calculator::types::ResultType::Crypto => qobject::ResultType::Crypto,
            smart_calculator::types::ResultType::Time => qobject::ResultType::Time,
            smart_calculator::types::ResultType::Date => qobject::ResultType::Date,
        }
    }
}

#[derive(Default)]
pub struct SmartCalcRs {
    result: QVariant,
    result_type: qobject::ResultType,
}

impl qobject::SmartCalc {
    fn query(self: Pin<&mut Self>, input: QString) {
        let qt_thread = self.qt_thread();
        RUNTIME.spawn(
            async move {
                let result = smart_calculator::calculate(
                    &input.to_string(),
                    None,
                )
                .await;
                qt_thread.queue(
                    |mut qo| {
                        qo.as_mut()
                            .set_result_type(
                                match &result {
                                    Ok(value) => (&value.res_type).into(),
                                    Err(_) => qobject::ResultType::Unset,
                                },
                            );
                        qo.as_mut()
                            .set_result(
                                match result {
                                    Ok(value) => {
                                        if value.formatted == value.input {
                                            QVariant::default()
                                        } else {
                                            let result: QString = value
                                                .formatted
                                                .into();
                                            QVariant::from(&result)
                                        }
                                    }
                                    Err(_) => QVariant::default(),
                                },
                            )
                    },
                )
            },
        );
    }

    fn reset(mut self: Pin<&mut Self>) {
        self.as_mut()
            .set_result(QVariant::default());
        self.as_mut()
            .set_result_type(qobject::ResultType::Unset);
    }
}
