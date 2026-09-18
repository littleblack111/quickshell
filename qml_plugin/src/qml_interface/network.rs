use cxx_qt::{CxxQtType, Threading};
use cxx_qt_lib::{QString, QVariant};
use std::pin::Pin;
use unwrap_print::PrintableResult;
use zbus::zvariant::NoneValue;

use crate::{ExclusiveExecutor, services::network};

#[cxx_qt::bridge]
mod qobject {
    extern "C++" {
        include!("cxx-qt-lib/qvariant.h");
        type QVariant = cxx_qt_lib::QVariant;
    }

    extern "RustQt" {
        #[qobject]
        #[qml_element]
        #[qml_singleton]
        #[qproperty(
            QVariant, result
        )]
        type Network = super::NetworkRs;

        #[qinvokable]
        fn query_primary_device(self: Pin<&mut Network>);
    }

    impl cxx_qt::Threading for Network {}
}

#[derive(Default)]
pub struct NetworkRs {
    result: QVariant,

    executor: ExclusiveExecutor,
}

impl qobject::Network {
    fn query_primary_device(self: Pin<&mut Self>) {
        let qt_thread = self.qt_thread();
        self.rust_mut().executor.spawn(
            async move {
                let result = match network::get().await {
                    Ok(o) => {
                        let r: QString = o.into();
                        QVariant::from(&r)
                    }
                    Err(_) => QVariant::null_value(),
                };
                _ = qt_thread.queue(|mut qo| qo.as_mut().set_result(result)).unwrap_print();
            },
        );
    }
}
