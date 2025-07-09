struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
};

@group(0) @binding(0)
var<uniform> u_resolution: vec2<f32>;

@group(1) @binding(0)
var<uniform> u_time: f32;


const NUM_OF_STEPS: u32 = 128;
const MIN_DIST_TO_SDF: f32 = 0.001;
const MAX_DIST_TO_TRAVEL: f32 = 64.0;

fn opSmoothUnion(d1: f32, d2: f32, k: f32) -> f32 {
  let h = clamp(0.5 + 0.5 * (d2 - d1) / k, 0.0, 1.0);
  return mix(d2, d1, h) - k * h * (1.0 - h);
}

fn sdfPlane(p: vec3<f32>, n: vec3<f32>, h: f32) -> f32 {
  // n must be normalized
  return dot(p, n) + h;
}


fn sdfSphere(p: vec3<f32>, c: vec3<f32>, r: f32) -> f32 {
  return length(p - c) - r;
}

fn map(p: vec3<f32>) -> f32 {
  let radius = 0.5;
  let center = vec3(0.0, -0.25 + sin(u_time) * 0.5, 0.0);

  let sphere = sdfSphere(p, center, radius);
  var m = sphere;

  let h = 1.0;
  let normal = vec3(0.0, 1.0, 0.0);
  let plane = sdfPlane(p, normal, h);
  m = min(sphere, plane);
  m = opSmoothUnion(m, plane, 0.5);

  return m;
  
}


fn rayMarch(ro: vec3<f32>, rd: vec3<f32>, maxDistToTravel: f32) -> f32 {
  
  var dist = 0.0;
  for(var i: u32 = 0; i < NUM_OF_STEPS; i++) {

    var currentPos = ro + rd * dist;
    var distToSdf = map(currentPos);

    if(distToSdf < MIN_DIST_TO_SDF) {
      break;
    }

    dist = dist + distToSdf;

    if (dist > maxDistToTravel) {
      break;
    }
  }

  return dist;
}

fn getNormal(p: vec3<f32>) -> vec3<f32> {

  let d = vec2(0.01, 0.0);
  let gx = map(p + d.xyy) - map(p - d.xyy);
  let gy = map(p + d.yxy) - map(p - d.yxy);
  let gz = map(p + d.yyx) - map(p - d.yyx);
  
  let normal = vec3(gx, gy, gz);
  return normalize(normal);
}

fn render(uv: vec2<f32>) -> vec3<f32> {

  var ro = vec3(0.0, 0.0, -2.0);
  var rd = vec3(uv, 1.0);
  var color = vec3(0.0, 0.0, 0.0);

  var dist = rayMarch(ro, rd, MAX_DIST_TO_TRAVEL);
  
  if (dist < MAX_DIST_TO_TRAVEL) {
    color = vec3(1.0, 1.0, 1.0);

    let p = ro + rd * dist;
    let normal = getNormal(p);
    color = normal;

    let lightColor = vec3(1.0);
    let lightSource = vec3(2.5, 2.5, -1.0);
    let diffuseStrength = max(0.0, dot(normalize(lightSource), normal));

    let diffuse = lightColor * diffuseStrength;

    let viewSource = normalize(ro);
    let reflectSource = normalize(reflect(-lightSource, normal));
    var specularStrength = max(0.0, dot(viewSource, reflectSource));
    specularStrength = pow(specularStrength, 64.0);
    let specular = specularStrength * lightColor;

    let lighting = diffuse * 0.75 + specular * 0.25;
    color = lighting;

    let lightDirection = normalize(lightSource);
    let distToLightSource = length(lightSource - p);
    ro = p + normal * 0.01; // offset to avoid self-shadowing
    rd = lightDirection;
    let dist = rayMarch(ro, rd, distToLightSource);
    if (dist < distToLightSource) {
      color = color * vec3(0.25); // shadow
    }
    color = pow(color, vec3(1.0 / 2.2));
  }

  return color;
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    
  let s = 2.0; // scale factor
  var position = (2.*in.clip_position.xy-u_resolution) / u_resolution.y*s;
  position.y = -position.y; // flip y-axis
  let color = render(position);

  return vec4<f32>(color, 1.0);

}
