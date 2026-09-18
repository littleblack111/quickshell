use std::sync::LazyLock;

use tokio::task;

static RUNTIME: LazyLock<tokio::runtime::Runtime> =
    LazyLock::new(|| tokio::runtime::Builder::new_multi_thread().enable_all().build().unwrap());

/// for example duckduckgo we wanna cancel first request if user types new query
/// using this guarentee that only one request is running at a time or at least
/// the first one is being aborted
#[derive(Default)]
pub struct ExclusiveExecutor {
    handle: Option<task::JoinHandle<()>>,
}

impl ExclusiveExecutor {
    pub fn new() -> Self {
        Self {
            handle: None,
        }
    }

    #[track_caller]
    pub fn spawn<F>(&mut self, future: F)
    where
        F: Future<Output = ()> + Send + 'static,
        F::Output: Send + 'static,
    {
        if let Some(handle) = self.handle.take() {
            handle.abort();
        }

        self.handle = Some(RUNTIME.spawn(future))
    }
}

mod qml_interface;
mod services;
mod web;
