struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
};

@group(0) @binding(0)
var<uniform> u_resolution: vec2<f32>;

@group(1) @binding(0)
var<uniform> u_time: f32;

fn rand(co: vec3<f32>)-> f32{ 
    return fract(sin(dot(co.xyz ,vec3(12.9898, 78.233, 33.87637))) * 43758.5453);
}

fn noise(co: vec3<f32>, freq: f32)->f32{
  let v = co * freq;

  let x1 = floor(v.x);
  let x2 = floor(v.x + 1.0);
  let y1 = floor(v.y);
  let y2 = floor(v.y + 1.0);
  let z1 = floor(v.z);
  let z2 = floor(v.z + 1.0);

  let fx = smoothstep(0.0, 1.0, fract(v.x));
  let fy = smoothstep(0.0, 1.0, fract(v.y));
  let fz = smoothstep(0.0, 1.0, fract(v.z));

  // linear interpolation via the 4 points
  let fade1 = mix(rand(vec3<f32>(x1, y1, z1)), rand(vec3<f32>(x2, y1, z1)), fx);
  let fade2 = mix(rand(vec3<f32>(x1, y2, z1)), rand(vec3<f32>(x2, y2, z1)), fx);

  let mix1 = mix(fade1, fade2, fy);

  let fade3 = mix(rand(vec3<f32>(x1, y1, z2)), rand(vec3<f32>(x2, y1, z2)), fx);
  let fade4 = mix(rand(vec3<f32>(x1, y2, z2)), rand(vec3<f32>(x2, y2, z2)), fx);

  let mix2 = mix(fade3, fade4, fy);

  return mix(mix1, mix2, fz);
  // return fade2;
}

fn fnoise(co: vec3<f32>, freq: f32, steps: i32) -> f32 {

  var value = 0.0;
  var ifreq = freq;
  for(var i = 0; i < steps; i++){
    value += noise(co, ifreq);
    ifreq *= 2.0;
  }

  return value / f32(steps);

}

fn pnoise(co: vec3<f32>, freq: f32, steps: i32, persistence: f32) -> f32 {

  var value = 0.0;
  var ampl = 1.0;
  var sum = 0.0;
  var ifreq = freq;

  for(var i = 0; i < steps; i++){
    sum += ampl;
    value += noise(co, ifreq) * ampl;
    ifreq *= 2.0;
    ampl *= persistence;
  }

  return value / sum;
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    
    let position = in.clip_position.xy / u_resolution;
    //let value = fnoise(position, 50.0, 3);
    let value = pnoise(vec3<f32>(position, u_time * 0.01 ), 15.0, 5, 0.8);

    let ripple = fract(value * 30.0);
    let id = floor(value * 30.0) / 30.0;
    let v = mix(id, ripple, pow(1.0 - abs(ripple - 0.5) *0.7, 2.0));

   // return vec4<f32>(vec3<f32>(v * 0.5 + 0.5, v * 0.2 + 0.3, v * 0.1 + 0.1), 1.0);
   return vec4<f32>(vec3<f32>(step(value, 0.5)), 1.0);

}
