// OBS Standard Uniforms
uniform float4x4 ViewProj;
uniform texture2d image; // Must be lowercase 'texture2d'

// Sampler tells the GPU how to read the pixels
sampler_state textureSampler {
    Filter    = Linear;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// Input from OBS
struct VertData {
    float4 pos : POSITION;
    float2 uv  : TEXCOORD0;
};

// Output from Vertex to Pixel Shader
struct PixelData {
    float4 pos : OVERLAY_COORD;
    float2 uv  : TEXCOORD0;
};

// Standard Vertex Shader
PixelData VSDefault(VertData v_in)
{
    PixelData vert_out;
    vert_out.pos = mul(float4(v_in.pos.xyz, 1.0), ViewProj);
    vert_out.uv  = v_in.uv;
    return vert_out;
}

// Pixel Shader: Simple Pass-Through
float4 PSDrawLowLatency(PixelData p_in) : TARGET
{
    // Sample the current frame (your video)
    return image.Sample(textureSampler, p_in.uv);
}

// Technique block: Tells OBS how to use this file
technique Draw
{
    pass
    {
        vertex_shader = VSDefault(v_in);
        pixel_shader  = PSDrawLowLatency(p_in);
    }
}