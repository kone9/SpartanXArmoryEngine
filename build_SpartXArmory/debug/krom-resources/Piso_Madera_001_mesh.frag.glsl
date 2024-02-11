#version 330

uniform sampler2D ImageTexture_002;
uniform sampler2D ImageTexture;
uniform sampler2D ImageTexture_001;

in vec3 wnormal;
in vec2 texCoord;
in mat3 TBN;
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
    vec4 ImageTexture_002_texread_store = texture(ImageTexture_002, texCoord);
    vec3 UVMap_texread_UV_res = vec3(texCoord.x, 1.0 - texCoord.y, 0.0);
    UVMap_texread_UV_res = UVMap_texread_UV_res;
    vec3 Mapping_texread_Vector_res = (UVMap_texread_UV_res + vec3(0.0, -1.269999980926513671875, 0.0)) * vec3(2.0, 2.0, 1.0);
    vec4 ImageTexture_texread_store = texture(ImageTexture, vec2(Mapping_texread_Vector_res.x, 1.0 - Mapping_texread_Vector_res.y));
    vec3 _116 = pow(ImageTexture_texread_store.xyz, vec3(2.2000000476837158203125));
    ImageTexture_texread_store = vec4(_116.x, _116.y, _116.z, ImageTexture_texread_store.w);
    vec3 UVMap_001_texread_UV_res = vec3(texCoord.x, 1.0 - texCoord.y, 0.0);
    UVMap_001_texread_UV_res = UVMap_001_texread_UV_res;
    vec3 Mapping_001_texread_Vector_res = (UVMap_001_texread_UV_res + vec3(0.0, -1.269999980926513671875, 0.0)) * vec3(2.0, 2.0, 1.0);
    vec4 ImageTexture_001_texread_store = texture(ImageTexture_001, vec2(Mapping_001_texread_Vector_res.x, 1.0 - Mapping_001_texread_Vector_res.y));
    vec3 ImageTexture_002_Color_res = ImageTexture_002_texread_store.xyz;
    n = (ImageTexture_002_Color_res * 2.0) - vec3(1.0);
    vec2 _151 = n.xy * 10.0;
    n = vec3(_151.x, _151.y, n.z);
    n = normalize(TBN * n);
    vec3 NormalMap_Normal_res = n;
    n = NormalMap_Normal_res;
    vec3 ImageTexture_Color_res = ImageTexture_texread_store.xyz;
    vec3 ImageTexture_001_Color_res = ImageTexture_001_texread_store.xyz;
    float SeparateColor_Blue_res = ImageTexture_001_Color_res.z;
    float Math_Value_res = SeparateColor_Blue_res * 0.0;
    float SeparateColor_Green_res = ImageTexture_001_Color_res.y;
    float Math_001_Value_res = SeparateColor_Green_res * 0.070000000298023223876953125;
    vec3 basecol = ImageTexture_Color_res;
    float roughness = Math_001_Value_res;
    float metallic = Math_Value_res;
    float occlusion = 1.0;
    float specular = 0.5;
    vec3 emissionCol = vec3(0.0);
    n /= vec3((abs(n.x) + abs(n.y)) + abs(n.z));
    vec2 _213;
    if (n.z >= 0.0)
    {
        _213 = n.xy;
    }
    else
    {
        _213 = octahedronWrap(n.xy);
    }
    n = vec3(_213.x, _213.y, n.z);
    fragColor[0] = vec4(n.xy, roughness, packFloatInt16(metallic, 0u));
    fragColor[1] = vec4(basecol, packFloat2(occlusion, specular));
    fragColor[2] = vec4(emissionCol, 0.0);
}

