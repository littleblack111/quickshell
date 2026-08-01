use cxx_qt::Threading;
use cxx_qt_lib::QString;
use std::pin::Pin;

use crate::{RUNTIME, web::duckduckgo};

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
        #[qproperty(
            bool, valid
        )]
        #[qproperty(
            QString, title
        )]
        #[qproperty(
            QString,
            description_html
        )]
        #[qproperty(
            QString,
            preview_image
        )]
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
    pub preview_image: QString,
}

#[derive(Default)]
pub struct DuckDuckGoRs {
    valid: bool,
    title: QString,
    description_html: QString,
    preview_image: QString,
}

impl qobject::DuckDuckGo {
    fn query(self: Pin<&mut Self>, input: QString) {
        let qt_thread = self.qt_thread();
        RUNTIME.spawn(
            async move {
                let input = input.to_string();
                let result: Result<QmlDuckDuckGo, _> = duckduckgo::query(&input)
                    .await
                    .map(|r| r.into());
                qt_thread.queue(
                    |mut qo| match result {
                        Ok(r) => {
                            qo.as_mut()
                                .set_valid(true);
                            qo.as_mut()
                                .set_title(r.title);
                            qo.as_mut()
                                .set_description_html(r.description_html);
                            qo.as_mut()
                                .set_preview_image(r.preview_image);
                        }
                        Err(_) => qo.set_valid(false),
                    },
                )
            },
        );
    }

    fn reset(mut self: Pin<&mut Self>) {
        self.as_mut()
            .set_valid(false);
        self.as_mut()
            .set_title("".into());
        self.as_mut()
            .set_description_html("".into());
        self.as_mut()
            .set_preview_image("".into());
    }
}
