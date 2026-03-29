// OBS Shader Header
uniform float4x4 ViewProj;
uniform texture2d image; // OBS uses 'image' as the default input identifier

sampler_state textureSampler {
    Filter    = Linear;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

struct VertData {
    float4 pos : POSITION;
    float2 uv  : TEXCOORD0;
};

struct PixelData {
    float4 pos : OVERLAY_COORD; // OBS specific semantic
    float2 uv  : TEXCOORD0;
};

PixelData VSDefault(VertData v_in)
{
    PixelData vert_out;
    vert_out.pos = mul(float4(v_in.pos.xyz, 1.0), ViewProj);
    vert_out.uv  = v_in.uv;
    return vert_out;
}

float4 PSDrawLowLatency(PixelData p_in) : TARGET
{
    // Sample the current frame
    float4 rgba = image.Sample(textureSampler, p_in.uv);
    
    // This is where we will insert the Oklab math tomorrow
    return rgba; 
}

technique Draw
{
    pass
    {
        vertex_shader = VSDefault(v_in);
        pixel_shader  = PSDrawLowLatency(p_in);
    }
}