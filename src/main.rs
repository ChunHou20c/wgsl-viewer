mod core;
mod vertex;

fn main() {
    pollster::block_on(core::run());
}
