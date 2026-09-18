use std::fs;

use cxx_qt_build::{CxxQtBuilder, PluginType, QmlModule};

const NAME: &str = "core";
const INTERFACE_DIR: &str = "src/qml_interface";

fn main() {
    let version_script =
        std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("qml_plugin.version");

    println!(
        "cargo:rustc-cdylib-link-arg=-Wl,--version-script={}",
        version_script.display()
    );

    CxxQtBuilder::new_qml_module(QmlModule::new(NAME).plugin_type(PluginType::Dynamic))
        .qt_module("Qml")
        .files(fs::read_dir(INTERFACE_DIR).unwrap().map(|d| d.unwrap().path()))
        .build();
}
