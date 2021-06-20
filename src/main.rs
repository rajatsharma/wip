use common_rs::Result;
use std::env;
use std::fs::File;
use std::io::prelude::*;
use std::path::Path;
use std::process::Command;

fn main() -> Result<()> {
    let args: Vec<String> = env::args().collect();

    let settings = include_bytes!("../.vscode/settings.json");
    let purs_settings = include_bytes!("../res/purs-settings.json");
    let editorconfig = include_bytes!("../.editorconfig");

    if args.len() < 3 {
        panic!("Insufficient arguments passes, required atleast 2")
    }

    let command = &args[1];
    let project = &args[2];

    if command == "next-init" {
        println!("Initialising Nextjs project");

        Command::new("git")
            .args(&[
                "clone",
                "https://github.com/rajatsharma/typereform",
                project,
            ])
            .spawn()?;
    }

    if command == "rust-init" {
        println!("Initialising Rust project");

        Command::new("cargo")
            .args(&["init", project, &*args[3]])
            .spawn()?;
        Command::new("mkdir")
            .current_dir(project)
            .arg(".vscode")
            .spawn()?;

        let mut settings_file = File::create(format!("./{}/.vscode/settings.json", project))?;
        settings_file.write_all(settings)?;
        let mut editorconfig_file = File::create(format!("./{}/.editorconfig", project))?;
        editorconfig_file.write_all(editorconfig)?;
    }

    if command == "purs-init" {
        println!("Initialising Purescript project");

        Command::new("mkdir").arg(project).output()?;
        Command::new("spago")
            .arg("init")
            .current_dir(project)
            .spawn()?;

        Command::new("yarn")
            .args(&["init", "-y"])
            .current_dir(project)
            .spawn()?;

        Command::new("mkdir")
            .current_dir(project)
            .arg(".vscode")
            .spawn()?;

        let mut editorconfig_file =
            File::create(Path::new(&format!("./{}/.editorconfig", project)))?;
        editorconfig_file.write_all(editorconfig)?;
        let mut settings_file =
            File::create(Path::new(&format!("./{}/.vscode/settings.json", project)))?;
        settings_file.write_all(purs_settings)?;
    }

    Ok(())
}
