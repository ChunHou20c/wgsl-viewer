struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
};

@group(0) @binding(0)
var<uniform> u_resolution: vec2<f32>;

@group(1) @binding(0)
var<uniform> u_time: f32;

fn rand(co: vec2<f32>)-> f32{ 
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

fn noise(co: vec2<f32>, freq: f32)->f32{
  let v = floor(co * freq);

  let v1 = floor(v);
  let v2 = floor(v + 1.0);
  let fx = fract(v.x);
  let fy = fract(v.y);

  // linear interpolation via the 4 points
  let fade1 = mix(rand(vec2<f32>(v1.x, v1.y)), rand(vec2<f32>(v2.x, v1.y)), fx);
  let fade2 = mix(rand(vec2<f32>(v1.x, v2.y)), rand(vec2<f32>(v2.x, v2.y)), fx);

  return mix(fade1, fade2, fy);
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    
    let position = in.clip_position.xy / u_resolution;
    let value = noise(position, 10.0);
    return vec4<f32>(vec3<f32>(value), 1.0);

}
