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

    let intPos = vec2<f32>(floor(norm_coords.x * 50.0), floor(norm_coords.y * 50.0));
    let rand = fract(sin(dot(intPos, vec2(12.9898, 78.233))) * 43758.1);

    //let color = vec3<f32>(clamp(norm_coords.x, 0.01, 0.9));

    return vec4<f32>(vec3<f32>(rand), 1.0);
}
