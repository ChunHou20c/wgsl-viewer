struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
};

@group(0) @binding(0)
var<uniform> u_resolution: vec2<f32>;

@group(1) @binding(0)
var<uniform> u_time: f32;

fn sdfCircle(p: vec2<f32>, r: f32) -> f32 {
  return length(p) -r;
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    
  let position = ((in.clip_position.xy / u_resolution * 2.0 )- 1.0) * 4.0;
  let red = vec3(1.0, 0.0, 0.0);
  let orange = vec3(0.9, 0.6, 0.3);
  let green = vec3(0.0, 1.0, 0.0);
  let blue = vec3(0.65, 0.85, 1.0);
  let black = vec3(0.0, 0.0, 0.0);
  let white = vec3(1.0, 1.0, 1.0);

  let radius = 1.0;
  let center = vec2(0.0, 0.0);

  let distanceToCircle = sdfCircle(position - center, radius);

  var color = select(orange, blue, distanceToCircle < 0.0);
  color = color * ( 1.0 - exp( -2.0 * abs(distanceToCircle)));
  color = color * 0.8 + color * 0.2 * sin(distanceToCircle * 10.0 - u_time * 2.0);
  // color = mix(white, color, step(0.1, distanceToCircle));
  // color = mix(white, color, step(0.1, abs(distanceToCircle)));
  color = mix(white, color, smoothstep(0.0, 0.1, abs(distanceToCircle)));
  color = mix(white, color, 2.0 * abs(distanceToCircle));
  color = mix(red, color, 4.0 * abs(distanceToCircle));
  color = mix(blue, color, 8.0 * abs(distanceToCircle));

  return vec4<f32>(color, 1.0);

}
