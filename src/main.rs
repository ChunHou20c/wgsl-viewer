mod core;
mod vertex;

use std::path::PathBuf;
use std::fs;

use clap::Parser;

/// Simple program view wgsl shader like in the shader book
#[derive(Parser, Debug)]
#[command(version, about, long_about = None)]
struct Args {
    /// input wgsl file
    #[arg(short, long)]
    input: PathBuf,

}

fn main() -> Result<(), Box<dyn std::error::Error>> {

    let args = Args::parse();

    let shader_source: String = fs::read_to_string(args.input)?;

    pollster::block_on(core::run(shader_source));

    Ok(())
}
