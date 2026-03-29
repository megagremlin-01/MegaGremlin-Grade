// OBS Standard Uniforms
uniform float4x4 ViewProj;
uniform texture2d image;

// Sampler for the video texture
sampler_state textureSampler {
    Filter    = Linear;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// Data passed from OBS to the Vertex Shader
struct VertData {
    float4 pos : POSITION;
    float2 uv  : TEXCOORD0;
};

// Data passed from Vertex Shader to Pixel Shader
struct PixelData {
    float4 pos : OVERLAY_COORD;
    float2 uv  : TEXCOORD0;
};

// Default Vertex Shader
PixelData VSDefault(VertData v_in)
{
    PixelData vert_out;
    vert_out.pos = mul(float4(v_in.pos.xyz, 1.0), ViewProj);
    vert_out.uv  = v_in.uv;
    return vert_out;
}

// Pixel Shader: This is where the magic happens
float4 PSDrawLowLatency(PixelData p_in) : TARGET
{
    // Sample the current frame
    float4 rgba = image.Sample(textureSampler, p_in.uv);
    
    // Return original color for now (Pass-through)
    return rgba;
}

// Technique definition for OBS to recognize the filter
technique Draw
{
    pass
    {
        vertex_shader = VSDefault(v_in);
        pixel_shader  = PSDrawLowLatency(p_in);
    }
}