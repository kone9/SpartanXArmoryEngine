#version 330

uniform vec4 casData[20];
uniform sampler2D ImageTexture;
uniform sampler2D senvmapBrdf;
uniform vec4 shirr[7];
uniform int envmapNumMipmaps;
uniform sampler2D senvmapRadiance;
uniform float envmapStrength;
uniform vec3 sunDir;
uniform bool receiveShadow;
uniform sampler2DShadow shadowMap;
uniform vec3 eye;
uniform float shadowsBias;
uniform vec3 sunCol;

in vec3 wnormal;
in vec3 eyeDir;
in vec2 texCoord;
in vec3 wposition;
out vec4 fragColor[2];

vec3 surfaceAlbedo(vec3 baseColor, float metalness)
{
    return mix(baseColor, vec3(0.0), vec3(metalness));
}

vec3 surfaceF0(vec3 baseColor, float metalness)
{
    return mix(vec3(0.039999999105930328369140625), baseColor, vec3(metalness));
}

vec3 shIrradiance(vec3 nor, vec4 shirr_1[7])
{
    vec3 cl00 = vec3(shirr_1[0].x, shirr_1[0].y, shirr_1[0].z);
    vec3 cl1m1 = vec3(shirr_1[0].w, shirr_1[1].x, shirr_1[1].y);
    vec3 cl10 = vec3(shirr_1[1].z, shirr_1[1].w, shirr_1[2].x);
    vec3 cl11 = vec3(shirr_1[2].y, shirr_1[2].z, shirr_1[2].w);
    vec3 cl2m2 = vec3(shirr_1[3].x, shirr_1[3].y, shirr_1[3].z);
    vec3 cl2m1 = vec3(shirr_1[3].w, shirr_1[4].x, shirr_1[4].y);
    vec3 cl20 = vec3(shirr_1[4].z, shirr_1[4].w, shirr_1[5].x);
    vec3 cl21 = vec3(shirr_1[5].y, shirr_1[5].z, shirr_1[5].w);
    vec3 cl22 = vec3(shirr_1[6].x, shirr_1[6].y, shirr_1[6].z);
    return ((((((((((cl22 * 0.429042994976043701171875) * ((nor.y * nor.y) - ((-nor.z) * (-nor.z)))) + (((cl20 * 0.743125021457672119140625) * nor.x) * nor.x)) + (cl00 * 0.88622701168060302734375)) - (cl20 * 0.2477079927921295166015625)) + (((cl2m2 * 0.85808598995208740234375) * nor.y) * (-nor.z))) + (((cl21 * 0.85808598995208740234375) * nor.y) * nor.x)) + (((cl2m1 * 0.85808598995208740234375) * (-nor.z)) * nor.x)) + ((cl11 * 1.02332794666290283203125) * nor.y)) + ((cl1m1 * 1.02332794666290283203125) * (-nor.z))) + ((cl10 * 1.02332794666290283203125) * nor.x);
}

float getMipFromRoughness(float roughness, float numMipmaps)
{
    return roughness * numMipmaps;
}

vec2 envMapEquirect(vec3 normal)
{
    float phi = acos(normal.z);
    float theta = atan(-normal.y, normal.x) + 3.1415927410125732421875;
    return vec2(theta / 6.283185482025146484375, phi / 3.1415927410125732421875);
}

mat4 getCascadeMat(float d, inout int casi, inout int casIndex)
{
    vec4 comp = vec4(float(d > casData[16].x), float(d > casData[16].y), float(d > casData[16].z), float(d > casData[16].w));
    casi = int(min(dot(vec4(1.0), comp), 4.0));
    casIndex = casi * 4;
    return mat4(vec4(casData[casIndex]), vec4(casData[casIndex + 1]), vec4(casData[casIndex + 2]), vec4(casData[casIndex + 3]));
}

float PCF(sampler2DShadow shadowMap_1, vec2 uv, float compare, vec2 smSize)
{
    vec3 _208 = vec3(uv + (vec2(-1.0) / smSize), compare);
    float result = texture(shadowMap_1, vec3(_208.xy, _208.z));
    vec3 _217 = vec3(uv + (vec2(-1.0, 0.0) / smSize), compare);
    result += texture(shadowMap_1, vec3(_217.xy, _217.z));
    vec3 _228 = vec3(uv + (vec2(-1.0, 1.0) / smSize), compare);
    result += texture(shadowMap_1, vec3(_228.xy, _228.z));
    vec3 _239 = vec3(uv + (vec2(0.0, -1.0) / smSize), compare);
    result += texture(shadowMap_1, vec3(_239.xy, _239.z));
    vec3 _247 = vec3(uv, compare);
    result += texture(shadowMap_1, vec3(_247.xy, _247.z));
    vec3 _258 = vec3(uv + (vec2(0.0, 1.0) / smSize), compare);
    result += texture(shadowMap_1, vec3(_258.xy, _258.z));
    vec3 _269 = vec3(uv + (vec2(1.0, -1.0) / smSize), compare);
    result += texture(shadowMap_1, vec3(_269.xy, _269.z));
    vec3 _280 = vec3(uv + (vec2(1.0, 0.0) / smSize), compare);
    result += texture(shadowMap_1, vec3(_280.xy, _280.z));
    vec3 _291 = vec3(uv + (vec2(1.0) / smSize), compare);
    result += texture(shadowMap_1, vec3(_291.xy, _291.z));
    return result / 9.0;
}

float shadowTestCascade(sampler2DShadow shadowMap_1, vec3 eye_1, vec3 p, float shadowsBias_1)
{
    float d = distance(eye_1, p);
    int param;
    int param_1;
    mat4 _387 = getCascadeMat(d, param, param_1);
    int casi = param;
    int casIndex = param_1;
    mat4 LWVP = _387;
    vec4 lPos = LWVP * vec4(p, 1.0);
    vec3 _402 = lPos.xyz / vec3(lPos.w);
    lPos = vec4(_402.x, _402.y, _402.z, lPos.w);
    float visibility = 1.0;
    if (lPos.w > 0.0)
    {
        visibility = PCF(shadowMap_1, lPos.xy, lPos.z - shadowsBias_1, vec2(4096.0, 1024.0));
    }
    float nextSplit = casData[16][casi];
    float _428;
    if (casi == 0)
    {
        _428 = nextSplit;
    }
    else
    {
        _428 = nextSplit - casData[16][casi - 1];
    }
    float splitSize = _428;
    float splitDist = (nextSplit - d) / splitSize;
    if ((splitDist <= 0.1500000059604644775390625) && (casi != 3))
    {
        int casIndex2 = casIndex + 4;
        mat4 LWVP2 = mat4(vec4(casData[casIndex2]), vec4(casData[casIndex2 + 1]), vec4(casData[casIndex2 + 2]), vec4(casData[casIndex2 + 3]));
        vec4 lPos2 = LWVP2 * vec4(p, 1.0);
        vec3 _506 = lPos2.xyz / vec3(lPos2.w);
        lPos2 = vec4(_506.x, _506.y, _506.z, lPos2.w);
        float visibility2 = 1.0;
        if (lPos2.w > 0.0)
        {
            visibility2 = PCF(shadowMap_1, lPos2.xy, lPos2.z - shadowsBias_1, vec2(4096.0, 1024.0));
        }
        float lerpAmt = smoothstep(0.0, 0.1500000059604644775390625, splitDist);
        return mix(visibility2, visibility, lerpAmt);
    }
    return visibility;
}

vec3 lambertDiffuseBRDF(vec3 albedo, float nl)
{
    return albedo * nl;
}

float d_ggx(float nh, float a)
{
    float a2 = a * a;
    float denom = ((nh * nh) * (a2 - 1.0)) + 1.0;
    denom = max(denom * denom, 6.103515625e-05);
    return (a2 * 0.3183098733425140380859375) / denom;
}

float g2_approx(float NdotL, float NdotV, float alpha)
{
    vec2 helper = (vec2(NdotL, NdotV) * 2.0) * (vec2(1.0) / ((vec2(NdotL, NdotV) * (2.0 - alpha)) + vec2(alpha)));
    return max(helper.x * helper.y, 0.0);
}

vec3 f_schlick(vec3 f0, float vh)
{
    return f0 + ((vec3(1.0) - f0) * exp2((((-5.554729938507080078125) * vh) - 6.9831600189208984375) * vh));
}

vec3 specularBRDF(vec3 f0, float roughness, float nl, float nh, float nv, float vh)
{
    float a = roughness * roughness;
    return (f_schlick(f0, vh) * (d_ggx(nh, a) * g2_approx(nl, nv, a))) / vec3(max(4.0 * nv, 9.9999997473787516355514526367188e-06));
}

void main()
{
    vec3 n = normalize(wnormal);
    vec3 vVec = normalize(eyeDir);
    float dotNV = max(dot(n, vVec), 0.0);
    vec3 UVMap_texread_UV_res = vec3(texCoord.x, 1.0 - texCoord.y, 0.0);
    UVMap_texread_UV_res = UVMap_texread_UV_res;
    vec3 Mapping_texread_Vector_res = UVMap_texread_UV_res;
    vec4 ImageTexture_texread_store = texture(ImageTexture, vec2(Mapping_texread_Vector_res.x, 1.0 - Mapping_texread_Vector_res.y));
    vec3 _696 = pow(ImageTexture_texread_store.xyz, vec3(2.2000000476837158203125));
    ImageTexture_texread_store = vec4(_696.x, _696.y, _696.z, ImageTexture_texread_store.w);
    vec3 ImageTexture_Color_res = ImageTexture_texread_store.xyz;
    float ImageTexture_Alpha_res = ImageTexture_texread_store.w;
    vec3 basecol = ImageTexture_Color_res;
    float roughness = 1.0;
    float metallic = 0.0;
    float occlusion = 1.0;
    float specular = 0.5;
    vec3 emissionCol = vec3(0.0);
    float opacity = ImageTexture_Alpha_res - 0.00019999999494757503271102905273438;
    if (opacity == 1.0)
    {
        discard;
    }
    vec3 albedo = surfaceAlbedo(basecol, metallic);
    vec3 f0 = surfaceF0(basecol, metallic);
    vec2 envBRDF = texelFetch(senvmapBrdf, ivec2(vec2(dotNV, 1.0 - roughness) * 256.0), 0).xy;
    vec3 indirect = shIrradiance(n, shirr);
    indirect *= albedo;
    vec3 reflectionWorld = reflect(-vVec, n);
    float lod = getMipFromRoughness(roughness, float(envmapNumMipmaps));
    vec3 prefilteredColor = textureLod(senvmapRadiance, envMapEquirect(reflectionWorld), lod).xyz;
    indirect += ((prefilteredColor * ((f0 * envBRDF.x) + vec3(envBRDF.y))) * 1.5);
    indirect *= occlusion;
    indirect *= envmapStrength;
    vec3 direct = vec3(0.0);
    float svisibility = 1.0;
    vec3 sh = normalize(vVec + sunDir);
    float sdotNL = dot(n, sunDir);
    float sdotNH = dot(n, sh);
    float sdotVH = dot(vVec, sh);
    if (receiveShadow)
    {
        svisibility = shadowTestCascade(shadowMap, eye, wposition + ((n * shadowsBias) * 10.0), shadowsBias);
    }
    direct += (((lambertDiffuseBRDF(albedo, sdotNL) + (specularBRDF(f0, roughness, sdotNL, sdotNH, dotNV, sdotVH) * specular)) * sunCol) * svisibility);
    vec4 premultipliedReflect = vec4(vec3(direct + (indirect * 0.5)) * opacity, opacity);
    float w = clamp((pow(min(1.0, premultipliedReflect.w * 10.0) + 0.00999999977648258209228515625, 3.0) * 100000000.0) * pow(1.0 - (gl_FragCoord.z * 0.89999997615814208984375), 3.0), 0.00999999977648258209228515625, 3000.0);
    fragColor[0] = vec4(premultipliedReflect.xyz * w, premultipliedReflect.w);
    fragColor[1] = vec4(premultipliedReflect.w * w, 0.0, 0.0, 1.0);
}

