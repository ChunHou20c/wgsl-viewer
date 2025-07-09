struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
};

@group(0) @binding(0)
var<uniform> u_resolution: vec2<f32>;

@group(1) @binding(0)
var<uniform> u_time: f32;

fn palette(t: f32) -> vec3<f32>{

  let a = vec3(0.5, 0.5, 0.5);
  let b = vec3(0.5, 0.5, 0.6);
  let c = vec3(1.0, 1.0, 1.0);
  let d = vec3(0.263, 0.416, 0.557);

  return a + b * cos ( 6.28318 * (c * t + d));
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    
  var position = ((in.clip_position.xy * 2.0 - u_resolution) / u_resolution.y);
  position.y = -position.y; // flip y-axis

  position *= 2.0; // scale to fit
  position = fract(position);
  position -= 0.5;

  var uv0 = position;
  var col = vec3<f32>(1.0, 1.0, 3.0);

  var d = length(position);

  d = sin( d * 8.0 + u_time) / 8.0;
  d = abs(d);

  d = 0.01 / d;
  col *= d;
  // d = smoothstep(0.0, 0.1, d);

  // var uv = position;
  // var uv0 = position;
  // var color = vec3(0.0);

  // for (var i = 0.0; i < 4.0; i+=1.0) {

  //   uv =fract(uv * 1.5) - 0.5;
  //   var d = length(uv) * exp( -length(uv0));
  //   let col = palette(length(uv0) + i * 0.4 + u_time * 0.4);

  //   d = sin(d * 8 + u_time) / 8;
  //   d = abs(d);

  //   d = pow(0.01 / d, 1.2);

  //   color += col * d;

  // }

  return vec4<f32>(col, 1.0);

}
