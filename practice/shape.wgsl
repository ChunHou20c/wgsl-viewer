struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
};

@group(0) @binding(0)
var<uniform> u_resolution: vec2<f32>;

@group(1) @binding(0)
var<uniform> u_time: f32;

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    
  let position = in.clip_position.xy / u_resolution;
  let bl = step(vec2(0.1), position);
  let tr = step(vec2(0.1), 1.0 - position);
  let color = vec3(bl.x * bl.y * tr.x * tr.y);

  return vec4<f32>(color, 1.0);

}
