// MegaGremlin Grade - High Precision Linearization
uniform float4x4 ViewProj;
uniform texture2d image;
uniform float gain; // This links to the C++ slider

sampler_state textureSampler {
    Filter    = Linear;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

struct VertData {
    float4 pos : POSITION;
    float2 uv  : TEXCOORD0;
};

// The Resolve Secret: Math must be done in Linear Space
float3 toLinear(float3 sRGB) {
    return pow(abs(sRGB), 2.2);
}

float3 toSRGB(float3 linearRGB) {
    return pow(abs(linearRGB), 1.0 / 2.2);
}

float4 mainTransform(VertData v_in) : TARGET {
    float4 rgba = image.Sample(textureSampler, v_in.uv);
    
    // 1. Convert to 32-bit Linear
    float3 color = toLinear(rgba.rgb);
    
    // 2. Apply Gain (Our first real-time test)
    color *= gain; 
    
    // 3. Convert back for OBS display
    return float4(toSRGB(color), rgba.a);
}