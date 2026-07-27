use cxx_qt::{CxxQtType, Threading};
use cxx_qt_lib::{QString, QVariant};
use kalk::parser;
use std::{pin::Pin, sync::Arc};
use tokio::sync::Mutex;

use crate::RUNTIME;

const PRECISION: u32 = 53;

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
        RUNTIME.spawn_blocking(move || {
            let result = parser::eval(
                &mut *ctx.blocking_lock(),
                &input.to_string(),
                PRECISION,
            );
            qt_thread.queue(|mut qo| {
                let variant = match result {
                    Ok(Some(value)) => {
                        let res: QString = value.to_string_big().into();
                        QVariant::from(&res)
                    }
                    Ok(None) => QVariant::default(),
                    Err(err) => {
                        eprintln!("MathCalc evaluation error: {:?}", err);
                        QVariant::default()
                    }
                };
                qo.as_mut().set_result(variant);
            });
        });
    }

    fn reset(mut self: Pin<&mut Self>) {
        self.as_mut()
            .set_result(QVariant::default());
        self.as_mut()
            .rust_mut()
            .ctx = Arc::new(Mutex::new(parser::Context::default()));
    }

    fn reset_ctx(mut self: Pin<&mut Self>) {
        self.as_mut()
            .rust_mut()
            .ctx = Arc::new(Mutex::new(parser::Context::default()));
    }
}
