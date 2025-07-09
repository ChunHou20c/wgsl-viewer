struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
};

@group(0) @binding(0)
var<uniform> u_resolution: vec2<f32>;

@group(1) @binding(0)
var<uniform> u_time: f32;

const NUM_OF_STEPS: u32 = 128;

// sdf for sphere
fn sdfSphere(p: vec3<f32>,o: vec3<f32>, r: f32) -> f32 {

  let rad = r + 0.1 * sin(p.x * 7 * 0.5 + u_time * 12) * sin(p.y * 7 +  u_time * 10) * sin(p.z * 7 + u_time * 5);
  return length(p - 0) - rad;
}

fn sdRoundBox(p: vec3<f32>, b: vec3<f32>, r: f32) -> f32 {
  let q = abs(p) - b + r;
  return length(max(q, vec3<f32>(0.0))) + min(max(q.y, q.z), 0.0) - r;
}

fn sdfScene(p: vec3<f32>) -> f32 {

  var d = sdfSphere(p, vec3<f32>(0.0, 0.0, 0.0), 4.0);
  // var d = sdRoundBox(p, vec3<f32>(3.0, 2.0, 3.0), 0.5);
  //d = min(d, sdfSphere(p, vec3<f32>(0.0, 5.0, 0.0), 4.0));

  return d;
}

// get the normal at a point p on the surface of the sphere
fn getNormal(p: vec3<f32>) -> vec3<f32> {

  let epsilon = 0.001;
  let dx = vec3<f32>(epsilon, 0.0, 0.0);
  let dy = vec3<f32>(0.0, epsilon, 0.0);
  let dz = vec3<f32>(0.0, 0.0, epsilon);

  // the normal is the direction of steepest ascent of the sdf
  let normal = vec3<f32>(
      sdfScene(p + dx) - sdfScene(p - dx),
      sdfScene(p + dy) - sdfScene(p - dy),
      sdfScene(p + dz) - sdfScene(p - dz)
      );

  return normalize(normal);
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    
  let s = 4.0;
  let uv = (2.*in.clip_position.xy-u_resolution) / u_resolution.y*s;

  let ray_origin = vec3(0.0, 0.0, -5.0);

  let ray_direction = normalize(vec3(uv, 1.0));

  var dist = 0.0;
  var hit = false;
  for(var i: u32 = 0; i < NUM_OF_STEPS; i++) {

    let current_pos = ray_origin + ray_direction * dist;
    let dist_to_sdf = sdfScene(current_pos);
    if (dist_to_sdf < 0.001) {
      hit = true;
      break;
    }

    dist += dist_to_sdf;
  }

  if(hit){

    let hit_position = ray_origin + ray_direction * dist;

    // use the hit_position for lighting and coloring
    // for now, just return a solid color to prove it works
    let normal = getNormal(hit_position);

    // define the light position
    let light_position = vec3(5.0, 5.0, -5.0);
    let light_direction = normalize(light_position - hit_position);

    // calculate the diffuse brightness (dot product)
    // max (..., 0.0) ensure we don't have negative light or surface facing away
    let diffuse_intensity = max(dot(normal, light_direction), 0.0);

    let object_color = vec3(1.0, 0.5, 0.2);
    let final_color = object_color * diffuse_intensity;

    return vec4<f32>(final_color, 1.0);

  } else {

    let background_color = vec3(0.1, 0.2, 0.3);
    return vec4(background_color, 1.0);
  }

}
