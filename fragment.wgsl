struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
};

@group(0) @binding(0)
var<uniform> u_resolution: vec2<f32>;

@group(1) @binding(0)
var<uniform> u_time: f32;


@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {

    let norm_coords = in.clip_position.xy / u_resolution.xy;
    return vec4<f32>(norm_coords.y, sin(u_time), 0.0, 1.0);
}
