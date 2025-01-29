struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
};

@group(0) @binding(0)
var<uniform> u_resolution: vec2<f32>;

@group(1) @binding(0)
var<uniform> u_time: f32;

const PI:f32 = 3.14159265359;
const TWO_PI:f32 = 6.28318530718;

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    
  let position = (in.clip_position.xy / u_resolution) *2. - 1.;
  let center = vec2(sin(u_time * 2.0) * 0.2 + 0.5, cos(u_time * 3.0) * 0.3 + 0.5) - position;

  let N = 5.0;

  let r = TWO_PI / N;
  let a = atan2(position.y, position.x) + PI;

  let d = cos(floor(.5 + a/r) * r - a) * length(position);
  let color = vec3(1 - smoothstep(.4, .41, d));
  // let color = vec3(d);
  


  return vec4<f32>(color, 1.0);

}
