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

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    
  let uv = ((in.clip_position.xy / u_resolution * 2.0 )- 1.0) * 4.0;
  let p0 = floor(uv);

  
  // var circles = vec2<f32>(0.0, 0.0);

  // for(var j = -MAX_RADIUS; j < MAX_RADIUS; j++) {
  //   for(var i = -MAX_RADIUS; i <= MAX_RADIUS; i++) {
  //     
  //     let pi = p0 + vec2<f32>(f32(i), f32(j));
  //     let hsh = hash22(pi);
  //     let p = pi + hash22(hsh);

  //     let t = fract(0.3 * u_time + hash12(hsh));
  //     let v = p - uv;
  //     let d = length(v) - (f32(MAX_RADIUS) + 1.0) * t;

  //     let h = 0.001;
  //     let d1 = d - h;
  //     let d2 = d + h;
  //     let p1 = sin(31. * d1) * smoothstep(-0.6, -0.3, d1) * smoothstep(0., -0.3, d1);
  //     let p2 = sin(31. * d2) * smoothstep(-0.6, -0.3, d2) * smoothstep(0., -0.3, d2);
  //     circles += 0.5 * normalize(v) * ((p2 - p1) / (2. * h) * (1.0 - t) * (1.0 -t));
  //   }
  // }

  // circles /= f32((MAX_RADIUS * 2 + 1) * (MAX_RADIUS * 2 + 1));

  // let intensity = mix(0.001, 0.15, smoothstep(0.1, 0.6, abs(fract(0.05 * u_time + 0.5) * 2.0 - 1.0)));
  // let n = vec3(circles, sqrt(1.0 - dot(circles, circles)));

  // let color = vec3<f32>(5.0 * pow(clamp(dot(n, normalize(vec3(1.0, 0.7, 0.5))), 0.0, 1.0), 6.0));

  let color = vec3(hash22(p0), 0.0);
  return vec4<f32>(color, 1.0);

}
