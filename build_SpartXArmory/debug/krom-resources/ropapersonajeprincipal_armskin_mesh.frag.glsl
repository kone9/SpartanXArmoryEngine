#version 330

uniform sampler2D ImageTexture;

in vec3 wnormal;
in vec2 texCoord;
out vec4 fragColor[3];

vec2 octahedronWrap(vec2 v)
{
    return (vec2(1.0) - abs(v.yx)) * vec2((v.x >= 0.0) ? 1.0 : (-1.0), (v.y >= 0.0) ? 1.0 : (-1.0));
}

float packFloatInt16(float f, uint i)
{
    uint bitsInt = i << 12u;
    uint bitsFloat = uint(f * 4095.0);
    return float(bitsInt | bitsFloat);
}

float packFloat2(float f1, float f2)
{
    return floor(f1 * 255.0) + min(f2, 0.9900000095367431640625);
}

void main()
{
    vec3 n = normalize(wnormal);
    vec3 UVMap_texread_UV_res = vec3(texCoord.x, 1.0 - texCoord.y, 0.0);
    UVMap_texread_UV_res = UVMap_texread_UV_res;
    vec3 Mapping_texread_Vector_res = UVMap_texread_UV_res;
    vec4 ImageTexture_texread_store = texture(ImageTexture, vec2(Mapping_texread_Vector_res.x, 1.0 - Mapping_texread_Vector_res.y));
    vec3 _105 = pow(ImageTexture_texread_store.xyz, vec3(2.2000000476837158203125));
    ImageTexture_texread_store = vec4(_105.x, _105.y, _105.z, ImageTexture_texread_store.w);
    vec3 ImageTexture_Color_res = ImageTexture_texread_store.xyz;
    vec3 basecol = ImageTexture_Color_res;
    float roughness = 0.100000001490116119384765625;
    float metallic = 0.0;
    float occlusion = 1.0;
    float specular = 0.5;
    vec3 emissionCol = vec3(0.0);
    n /= vec3((abs(n.x) + abs(n.y)) + abs(n.z));
    vec2 _140;
    if (n.z >= 0.0)
    {
        _140 = n.xy;
    }
    else
    {
        _140 = octahedronWrap(n.xy);
    }
    n = vec3(_140.x, _140.y, n.z);
    fragColor[0] = vec4(n.xy, roughness, packFloatInt16(metallic, 0u));
    fragColor[1] = vec4(basecol, packFloat2(occlusion, specular));
    fragColor[2] = vec4(emissionCol, 0.0);
}

