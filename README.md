# Wgsl viewer
A super simple cli application to view your wgsl fragment shader like in the book of shader

## Uniforms
There are 2 uniforms I passed into the shader:
1)  resolution of the window - @group(0) bindng(0) vec2<f32>
2)  time since startup - @group(1) binding(0) f32

## Examples
### A random number generater fragment shader
```
cargo run -- -i fragment.wgsl
```
![2025-01-20T23:26:22,220652361+08:00](https://github.com/user-attachments/assets/07bc6337-8eac-4637-a518-1457efdbb1a0)



### Animated perlin noise
modified from glsl shader of https://www.mgsx.net/2015/07/21/009-animated-noise.html
```
cargo run -- -i noise.wgsl
```
![2025-01-20T23:28:56,166736751+08:00](https://github.com/user-attachments/assets/69532661-cbc6-4e1a-83b5-a5027b408fc5)

## Run with nix flake

run directly
```
nix run github:chunhou20c/wgsl-viewer#wgsl_viewer -- -i <your shader path>
```

### Contributing to this project
I do not know whether it works in x11, you may open for issue to improve the project.
