mod core;

fn main() {
    pollster::block_on(core::run());
}
