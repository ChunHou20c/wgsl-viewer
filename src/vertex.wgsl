struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
};

struct VertexInput {
    @location(0) position: vec3<f32>,
};

@vertex
fn vs_main(
    model: VertexInput,
) -> VertexOutput {
    var out: VertexOutput;
    out.clip_position = vec4<f32>(model.position, 1.0);
    return out;
}
