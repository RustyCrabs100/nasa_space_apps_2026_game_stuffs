use std::env;
use std::path::{Path, PathBuf};

fn main() {
    let root = env::var("CARGO_MANIFEST_DIR").expect("Failed to get CARGO_MANIFEST_DIR");
    let out = env::var("OUT_DIR").expect("Failed to get OUT_DIR");

    println!("{0}", &out);

    let assets = PathBuf::from(root).join("assets");
    let dst = PathBuf::from(out).join("assets");

    if !dst.exists() {
        std::fs::create_dir_all(&dst);
    }
}

fn copy_dir_all(src: &Path, dst: &Path, assets: &PathBuf) {
    for tmp_entry in std::fs::read_dir(assets).expect("Failed to read assets") {
        let entry = tmp_entry.expect("Failed to enter Dir");

        let path = entry.path();
        let dst_path = dst.join(entry.file_name());

        if entry.file_type().expect("failed to get filetype").is_dir() {
            copy_dir_all(&path, &dst_path, assets);
        } else if entry.file_type().expect("Failed to get filetype").is_file() {
            std::fs::copy(path, dst_path);
        } else {
            panic!("Unknown File Type");
        }
    }
}
