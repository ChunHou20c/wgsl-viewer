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
    
  let position = (in.clip_position.xy / u_resolution) * 2. - 1.;
  let position2 = (in.clip_position.xy / u_resolution) *2. - 1.;

  let center = vec2(sin(u_time * 2.0) * 0.2 + 0.5, cos(u_time * 3.0) * 0.3 + 0.5) - position;
  let center2 = vec2(sin(u_time * 2.0) * 0.2 + 0.5, cos(u_time * 3.0) * 0.3 + 0.5) - position2;

  let N = 5.0;

  let r = TWO_PI / N;
  let r2 = TWO_PI / N;

  let a = atan2(position.y, position.x) +  u_time * PI;
  let a2 = atan2(position2.y, position2.x) + u_time * PI;

  let d = cos(floor(.5 + a/r) * r - a) * length(position) * 1.3;
  let d2 = cos(floor(.5 + a2/r2) * r2 - a2) * length(position2);

  var color = vec3(1 - smoothstep(.4, .41, d));
  let color2 = vec3(1 - smoothstep(.4, .41, d2));
  // let color = vec3(d);
  color = color2 - color;
  


  return vec4<f32>(color, 1.0);

}
