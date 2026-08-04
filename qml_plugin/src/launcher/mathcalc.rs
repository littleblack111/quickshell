use cxx_qt::{CxxQtType, Threading};
use cxx_qt_lib::{QString, QVariant};
use kalk::parser;
use std::{pin::Pin, sync::Arc};
use tokio::sync::Mutex;
use unwrap_print::PrintableResult;

use crate::ExclusiveExecutor;

const DEFAULT_ANGLE_UNIT: &str = "deg";

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
        type MathCalc = super::MathCalcRs;

        #[qinvokable]
        fn query(self: Pin<&mut MathCalc>, input: QString);

        #[qinvokable]
        fn reset(self: Pin<&mut MathCalc>);

        #[qinvokable]
        fn reset_ctx(self: Pin<&mut MathCalc>);

        #[qinvokable]
        fn reset_result(self: Pin<&mut MathCalc>);
    }

    impl cxx_qt::Threading for MathCalc {}
}

pub struct MathCalcRs {
    result: QVariant,
    ctx: Arc<Mutex<parser::Context>>,

    executor: ExclusiveExecutor,
}

impl Default for MathCalcRs {
    fn default() -> Self {
        Self {
            result: QVariant::default(),
            ctx: Arc::new(Mutex::new(qobject::MathCalc::new_ctx())),
            executor: ExclusiveExecutor::default(),
        }
    }
}

impl qobject::MathCalc {
    fn query(mut self: Pin<&mut Self>, input: QString) {
        let qt_thread = self.qt_thread();
        let ctx = Arc::clone(
            &self
                .as_mut()
                .rust_mut()
                .ctx,
        );
        // TODO: consider moving to spawn_blocking
        self.rust_mut()
            .executor
            .spawn(
                async move {
                    let input = input.to_string();
                    let result = parser::eval(
                        &mut *ctx
                            .lock()
                            .await,
                        &input,
                        // TODO: move to const/config
                        53,
                    )
                    .map_or_default(
                        |r| {
                            r.map_or_default(
                                |r| {
                                    let r: QString = r
                                        // to display scientific notation properly
                                        // other ones show both version without e or shows *10^_
                                        // and have a = prefix
                                        .to_string_big()
                                        .into();
                                    if r != input.into() {
                                        QVariant::from(&r)
                                    } else {
                                        QVariant::default()
                                    }
                                },
                            )
                        },
                    );
                    _ = qt_thread
                        .queue(
                            |mut qo| {
                                qo.as_mut()
                                    .set_result(result)
                            },
                        )
                        .unwrap_print();
                },
            );
    }

    fn reset(mut self: Pin<&mut Self>) {
        self.as_mut()
            .reset_result();
        self.reset_ctx();
    }

    fn new_ctx() -> parser::Context {
        parser::Context::default().set_angle_unit(DEFAULT_ANGLE_UNIT)
    }

    fn reset_ctx(mut self: Pin<&mut Self>) {
        self.as_mut()
            .rust_mut()
            .ctx = Arc::new(Mutex::new(Self::new_ctx()))
    }

    fn reset_result(mut self: Pin<&mut Self>) {
        self.as_mut()
            .set_result(QVariant::default())
    }
}
