struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
};

@group(0) @binding(0)
var<uniform> u_resolution: vec2<f32>;

@group(1) @binding(0)
var<uniform> u_time: f32;


fn tile(st: vec2<f32>, zoom: f32) -> vec2<f32> {
  let st_new = st * zoom;
  return fract(st_new);
}

fn circle(st: vec2<f32>, radius: f32) -> f32 {

  let pos = vec2(0.5) - st;
  let r = radius * 0.75;
  return 1.0 - smoothstep(r - (r * 0.05), r + (r * 0.05), dot(pos, pos) * 3.14);
}

fn circle_pattern(st: vec2<f32>, radius: f32) -> f32 {

  return 
    circle(st + vec2(0.0, -0.5), radius) +
    circle(st + vec2(0.0, 0.5), radius) +
    circle(st + vec2(-0.5, 0.0), radius) +
    circle(st + vec2(0.5, 0.0), radius);
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    
  var st = (in.clip_position.xy / u_resolution.xy);
  st.x *= u_resolution.x / u_resolution.y;
  var color = vec3(0.0);

  let grid1 = tile(st, 7.0);

  color += mix(vec3(0.2, 0.5, 1.0), vec3(1.0, 0.5, 1.0), circle_pattern(grid1, 0.23) - circle_pattern(grid1, 0.01));
  
  let grid2 = tile(st, 5.0);
  color = mix(color, vec3(0.5, 0.0, 0.0), circle_pattern(grid2, 0.2) - circle_pattern(grid2, 0.05));

  return vec4<f32>(color, 1.0);

}
