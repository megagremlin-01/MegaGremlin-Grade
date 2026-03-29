// 1. Raw DirectX 11 Types (Avoids OBS macro confusion)
Texture2D image : register(t0);
SamplerState textureSampler : register(s0);

// 2. Constants
uniform float4x4 ViewProj;

// 3. Data Structures
struct VertData {
    float4 pos : POSITION;
    float2 uv  : TEXCOORD0;
};

struct PixelData {
    float4 pos : SV_Position; // Standard DX11 Semantic
    float2 uv  : TEXCOORD0;
};

// 4. Vertex Shader
PixelData VSDefault(VertData v_in)
{
    PixelData vert_out;
    vert_out.pos = mul(float4(v_in.pos.xyz, 1.0), ViewProj);
    vert_out.uv  = v_in.uv;
    return vert_out;
}

// 5. Pixel Shader
float4 PSDrawLowLatency(PixelData p_in) : SV_Target
{
    // Uses the raw .Sample() method recognized by the DX compiler
    return image.Sample(textureSampler, p_in.uv);
}

// 6. OBS Technique Wrapper
technique Draw
{
    pass
    {
        vertex_shader = VSDefault(v_in);
        pixel_shader  = PSDrawLowLatency(p_in);
    }
}