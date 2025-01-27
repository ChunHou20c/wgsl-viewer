struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
};

@group(0) @binding(0)
var<uniform> u_resolution: vec2<f32>;

@group(1) @binding(0)
var<uniform> u_time: f32;

fn fn_mod(x: vec3<f32>, y: f32) -> vec3<f32> {
  return x - y * floor( x / y );
}

fn hsb2rgb(in: vec3<f32>) -> vec3<f32> {

  var rgb = clamp(abs(
    fn_mod(in.x * 6.0 + vec3(0.0, 4.0, 2.0), 6.0) 
      - 3.0 ) - 1.0, vec3(0.0), vec3(1.0));
  rgb = rgb * rgb * (3.0 - 2.0 *rgb);
  return in.z * mix(vec3(1.0), rgb, in.y);
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    
  let position = in.clip_position.xy / u_resolution;
  let color = hsb2rgb(vec3(position.x, 1.0, position.y));

  return vec4<f32>(color, 1.0);

}
