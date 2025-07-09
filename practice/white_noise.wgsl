struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
};

@group(0) @binding(0)
var<uniform> u_resolution: vec2<f32>;

@group(1) @binding(0)
var<uniform> u_time: f32;

const MAX_RADIUS: i32 = 2;
const DOUBLE_HASH: u32 = 0;
const HASHSCALE1: f32 = 0.1031;
const HASHSCALE3: vec3<f32> = vec3(0.1031, 0.1030, 0.0973);

fn hash12(p: vec2<f32>) -> f32 {
  var p3 = fract(p.xyx* HASHSCALE3);
  p3 += dot(p3, p3.yzx + 19.19);
  return fract((p3.x + p3.y) * p3.z);
}

fn hash22(p: vec2<f32>) -> vec2<f32> {
  var p3 = fract(vec3<f32>(p.xyx) * HASHSCALE3);
  p3 += dot(p3, p3.yzx + 19.19);
  return fract((p3.xx + p3.yz) * p3.zy);
}

fn white_noise_2x1(p: vec2<f32>) -> f32 {
  // return p.x;

  return fract(p.x * p.y * 50.234569);
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    
  let uv = ((in.clip_position.xy / u_resolution * 2.0 )- 1.0) * 4.0;
  let noise = white_noise_2x1(uv);
  let color = vec3(noise);
  return vec4<f32>(color, 1.0);

}
