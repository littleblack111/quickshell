use cxx_qt::{CxxQtType, Threading};
use cxx_qt_lib::QString;
use std::pin::Pin;
use unwrap_print::PrintableResult;

use crate::{ExclusiveExecutor, web::duckduckgo};

#[cxx_qt::bridge]
mod qobject {
    extern "C++" {
        include!("cxx-qt-lib/qstring.h");
        type QString = cxx_qt_lib::QString;
    }

    extern "RustQt" {
        #[qobject]
        #[qml_element]
        #[qml_singleton]
        #[qproperty(bool, ok)]
        #[qproperty(QString, title)]
        #[qproperty(QString, description_html)]
        #[qproperty(QString, image)]
        type DuckDuckGo = super::DuckDuckGoRs;

        #[qinvokable]
        fn query(self: Pin<&mut DuckDuckGo>, input: QString);

        #[qinvokable]
        fn reset(self: Pin<&mut DuckDuckGo>);
    }

    impl cxx_qt::Threading for DuckDuckGo {}
}

#[derive(Default)]
pub struct QmlDuckDuckGo {
    pub title: QString,
    pub description_html: QString,
    pub image: QString,
}

#[derive(Default)]
pub struct DuckDuckGoRs {
    ok: bool,
    title: QString,
    description_html: QString,
    image: QString,

    executor: ExclusiveExecutor,
}

impl qobject::DuckDuckGo {
    fn query(self: Pin<&mut Self>, input: QString) {
        let qt_thread = self.qt_thread();
        self.rust_mut().executor.spawn(async move {
            let qinput = input.to_string();
            let result: Result<QmlDuckDuckGo, _> =
                duckduckgo::query(&qinput).await.map(|r| r.into());
            // consider just unwrapping since this is in a separate thread and
            // is already end of life anw
            _ = qt_thread
                .queue(move |mut qo| match result {
                    Ok(r) => {
                        if (r.title.to_lower() == input.to_lower() || r.title.is_empty())
                            && r.description_html.is_empty()
                            && r.image.is_empty()
                        {
                            qo.as_mut().set_ok(false);
                        } else {
                            qo.as_mut().set_ok(true);
                            qo.as_mut().set_title(r.title);
                            qo.as_mut().set_description_html(r.description_html);
                            qo.as_mut().set_image(r.image);
                        }
                    }
                    Err(_) => qo.set_ok(false),
                })
                .unwrap_print();
        });
    }

    fn reset(mut self: Pin<&mut Self>) {
        self.as_mut().set_ok(false);
        self.as_mut().set_title("".into());
        self.as_mut().set_description_html("".into());
        self.as_mut().set_image("".into());
    }
}
