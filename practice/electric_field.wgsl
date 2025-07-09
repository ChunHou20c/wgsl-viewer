struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
};

@group(0) @binding(0)
var<uniform> u_resolution: vec2<f32>;

@group(1) @binding(0)
var<uniform> u_time: f32;

const mod3_: vec3<f32> = vec3(0.1031, 0.11369, 0.13787);
const detail_steps_ : u32 = 12;

fn hash3_3(p3: vec3<f32>) -> vec3<f32> {
  
  var p3_new = fract(p3 * mod3_);
  p3_new += dot(p3_new, p3_new.yzx + 19.19);
  return -1. + 2. * fract(vec3((p3_new.x + p3_new.y) * p3_new.z, (p3_new.x+p3_new.z) * p3_new.y, (p3_new.y+p3_new.z) * p3_new.x));
}

fn perlin_noise3(p: vec3<f32>) -> f32 {
	
  let pi = floor(p);
  let pf = p - pi;

  let w = pf * pf * ( 3.0 - 2.0 * pf);

  
  return mix(
      mix(
	mix(
	  dot(pf - vec3(0, 0, 0), hash3_3(pi + vec3(0, 0, 0))), 
	  dot(pf - vec3(1, 0, 0), hash3_3(pi + vec3(1, 0, 0))),
	  w.x),
	mix(
	  dot(pf - vec3(0, 0, 1), hash3_3(pi + vec3(0, 0, 1))), 
	  dot(pf - vec3(1, 0, 1), hash3_3(pi + vec3(1, 0, 1))),
	  w.x),
	w.z),
      mix(
	mix(
	  dot(pf - vec3(0, 1, 0), hash3_3(pi + vec3(0, 1, 0))), 
	  dot(pf - vec3(1, 1, 0), hash3_3(pi + vec3(1, 1, 0))),
	  w.x),
	mix(
	  dot(pf - vec3(0, 1, 1), hash3_3(pi + vec3(0, 1, 1))), 
	  dot(pf - vec3(1, 1, 1), hash3_3(pi + vec3(1, 1, 1))),
	  w.x),
	w.z),
      w.y);
}

fn noise_sum_abs_3(p: vec3<f32>) -> f32 {

  var f = 0.0;
  var p_new = p * 3;
  f += 1.0000 * abs(perlin_noise3(p_new)); 
  p_new = 2. * p_new;
  f += 0.5000 * abs(perlin_noise3(p_new));
  p_new = 3. * p_new;
  f += 0.2500 * abs(perlin_noise3(p_new));
  p_new = 4. * p_new;
  f += 0.1250 * abs(perlin_noise3(p_new));
  p_new = 5. * p_new;
  f += 0.0625 * abs(perlin_noise3(p_new));
  p_new = 6. * p_new;
  f += 0.0312 * abs(perlin_noise3(p_new));

  return f;
}

fn domain(uv: vec2<f32>, s: f32) -> vec2<f32> {
  return (2.*uv.xy-u_resolution.xy) / u_resolution.y*s;
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {


  let p = domain(in.clip_position.xy, 5.5);
  let electric_density = 0.9;
  let electric_radius  = length(p) - .2;
  let velocity = 0.1;

  let moving_coordinate = sin(velocity * u_time) / 0.2 * cos(velocity * u_time);
  let electric_local_domain = vec3<f32>(p, moving_coordinate);
  let electric_field = electric_density * noise_sum_abs_3(electric_local_domain);

  var col = vec3(107, 148, 196) / 255.;
  col += (1.0 - (electric_field + electric_radius));

  for (var i = 0u; i < detail_steps_; i += 1u) {
    if(length(col) >= 2.1 + f32(i) / 2.){
      col -= .3;
    }
  }

  col += 1. - 4.2*electric_field;

  let alpha = 1.;

  return vec4<f32>(col, alpha);

}
