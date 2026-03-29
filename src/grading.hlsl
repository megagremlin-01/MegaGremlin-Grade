// 1. Native DX11 Types & Registers
// This ensures the Windows compiler identifies the texture and sampler 
// without needing OBS-specific macros that were failing.
Texture2D image : register(t0);
SamplerState textureSampler : register(s0);

// 2. Constants
// ViewProj is provided by OBS to handle the scaling/positioning of the filter.
uniform float4x4 ViewProj;

// 3. Data Structures
struct VertData {
    float4 pos : POSITION;
    float2 uv  : TEXCOORD0;
};

struct PixelData {
    float4 pos : SV_Position; 
    float2 uv  : TEXCOORD0;
};

// 4. Vertex Shader
// Transforms the 2D vertex positions into the space OBS expects.
PixelData VSDefault(VertData v_in)
{
    PixelData vert_out;
    vert_out.pos = mul(float4(v_in.pos.xyz, 1.0), ViewProj);
    vert_out.uv  = v_in.uv;
    return vert_out;
}

// 5. Pixel Shader
// Currently a pure pass-through: it samples a pixel and returns it unchanged.
float4 PSDrawLowLatency(PixelData p_in) : SV_Target
{
    return image.Sample(textureSampler, p_in.uv);
}

// 6. OBS Technique Wrapper
// By removing the (v_in) parentheses, we tell the OBS pre-processor 
// to handle the data hand-off, bypassing the 'const int' conversion error.
technique Draw
{
    pass
    {
        vertex_shader = VSDefault;
        pixel_shader  = PSDrawLowLatency;
    }
}