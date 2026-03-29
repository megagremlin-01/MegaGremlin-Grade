// 1. Core Types
Texture2D image : register(t0);
SamplerState textureSampler : register(s0);

uniform float4x4 ViewProj;

// 2. Data Structures
struct VertData {
    float4 pos : POSITION;
    float2 uv  : TEXCOORD0;
};

struct PixelData {
    float4 pos : SV_Position; 
    float2 uv  : TEXCOORD0;
};

// 3. Vertex Shader
PixelData VSDefault(VertData v_in)
{
    PixelData vert_out;
    vert_out.pos = mul(float4(v_in.pos.xyz, 1.0), ViewProj);
    vert_out.uv  = v_in.uv;
    return vert_out;
}

// 4. Pixel Shader
float4 PSDrawLowLatency(PixelData p_in) : SV_Target
{
    return image.Sample(textureSampler, p_in.uv);
}

// 5. OBS Technique Wrapper (Fixed Syntax)
technique Draw
{
    pass
    {
        vertex_shader = VSDefault(v_in);
        pixel_shader  = PSDrawLowLatency(p_in);
    }
}