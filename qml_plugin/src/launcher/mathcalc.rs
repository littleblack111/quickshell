use cxx_qt::{CxxQtType, Threading};
use cxx_qt_lib::{QString, QVariant};
use kalk::parser;
use std::{pin::Pin, sync::Arc};
use tokio::sync::Mutex;

use crate::RUNTIME;

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

#[derive(Default)]
pub struct MathCalcRs {
    result: QVariant,

    ctx: Arc<Mutex<parser::Context>>,
}

impl qobject::MathCalc {
    fn query(self: Pin<&mut Self>, input: QString) {
        let qt_thread = self.qt_thread();
        let ctx = Arc::clone(
            &self
                .rust_mut()
                .ctx,
        );
        // TODO: consider moving to spawn_blocking
        RUNTIME.spawn(
            async move {
                let input = input.to_string();
                let result = parser::eval(
                    &mut *ctx
                        .lock()
                        .await,
                    &input,
                    // TODO: move to const/config
                    53,
                );
                qt_thread.queue(
                    |mut qo| {
                        qo.as_mut()
                            .set_result(
                                result.map_or_default(
                                    |r| {
                                        r.map_or_default(
                                            |r| {
                                                let result: QString = r
                                                    .to_string()
                                                    .into();
                                                if result != input.into() {
                                                    QVariant::from(&result)
                                                } else {
                                                    QVariant::default()
                                                }
                                            },
                                        )
                                    },
                                ),
                            )
                    },
                )
            },
        );
    }

    fn reset(mut self: Pin<&mut Self>) {
        self.as_mut()
            .reset_result();
        self.reset_ctx();
    }

    fn reset_ctx(mut self: Pin<&mut Self>) {
        self.as_mut()
            .rust_mut()
            .ctx =
            Arc::new(Mutex::new(parser::Context::default().set_angle_unit(DEFAULT_ANGLE_UNIT)));
    }

    fn reset_result(mut self: Pin<&mut Self>) {
        self.as_mut()
            .set_result(QVariant::default())
    }
}
