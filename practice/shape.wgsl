struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
};

@group(0) @binding(0)
var<uniform> u_resolution: vec2<f32>;

@group(1) @binding(0)
var<uniform> u_time: f32;

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    
  let position = (in.clip_position.xy / u_resolution * 2.0 )- 1.0;
  let center = vec2(sin(u_time * 2.0) * 0.2 + 0.5, cos(u_time * 2.0) * 0.2 + 0.5);
  let positive_v = vec3(1.0, 0.0, 0.0);
  let negative_v = vec3(0.0, 0.0, 1.0);
  let d = length(max(abs(position) - 0.3, vec2(0.0, 0.0)));
  let color = vec3(smoothstep(.3, .4, d) * smoothstep(.5, .6, d));
  // let color = vec3(d);
  


  return vec4<f32>(color, 1.0);

}
