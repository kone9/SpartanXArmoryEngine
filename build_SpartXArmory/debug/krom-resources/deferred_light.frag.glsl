#version 330

uniform vec4 casData[20];
uniform sampler2D gbuffer0;
uniform sampler2D gbuffer1;
uniform sampler2D gbufferD;
uniform vec3 eye;
uniform vec3 eyeLook;
uniform vec2 cameraProj;
uniform sampler2D senvmapBrdf;
uniform vec4 shirr[7];
uniform int envmapNumMipmaps;
uniform sampler2D senvmapRadiance;
uniform float envmapStrength;
uniform sampler2D ssaotex;
uniform sampler2D gbufferEmission;
uniform vec3 sunDir;
uniform sampler2DShadow shadowMap;
uniform float shadowsBias;
uniform vec3 sunCol;

in vec2 texCoord;
in vec3 viewRay;
out vec4 fragColor;

vec2 octahedronWrap(vec2 v)
{
    return (vec2(1.0) - abs(v.yx)) * vec2((v.x >= 0.0) ? 1.0 : (-1.0), (v.y >= 0.0) ? 1.0 : (-1.0));
}

void unpackFloatInt16(float val, out float f, out uint i)
{
    uint bitsValue = uint(val);
    i = bitsValue >> 12u;
    f = float(bitsValue & 4294905855u) / 4095.0;
}

vec2 unpackFloat2(float f)
{
    return vec2(floor(f) / 255.0, fract(f));
}

vec3 surfaceAlbedo(vec3 baseColor, float metalness)
{
    return mix(baseColor, vec3(0.0), vec3(metalness));
}

vec3 surfaceF0(vec3 baseColor, float metalness)
{
    return mix(vec3(0.039999999105930328369140625), baseColor, vec3(metalness));
}

vec3 getPos(vec3 eye_1, vec3 eyeLook_1, vec3 viewRay_1, float depth, vec2 cameraProj_1)
{
    float linearDepth = cameraProj_1.y / (((depth * 0.5) + 0.5) - cameraProj_1.x);
    float viewZDist = dot(eyeLook_1, viewRay_1);
    vec3 wposition = eye_1 + (viewRay_1 * (linearDepth / viewZDist));
    return wposition;
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

mat4 getCascadeMat(float d, inout int casi, inout int casIndex)
{
    vec4 comp = vec4(float(d > casData[16].x), float(d > casData[16].y), float(d > casData[16].z), float(d > casData[16].w));
    casi = int(min(dot(vec4(1.0), comp), 4.0));
    casIndex = casi * 4;
    return mat4(vec4(casData[casIndex]), vec4(casData[casIndex + 1]), vec4(casData[casIndex + 2]), vec4(casData[casIndex + 3]));
}

float PCF(sampler2DShadow shadowMap_1, vec2 uv, float compare, vec2 smSize)
{
    vec3 _409 = vec3(uv + (vec2(-1.0) / smSize), compare);
    float result = texture(shadowMap_1, vec3(_409.xy, _409.z));
    vec3 _418 = vec3(uv + (vec2(-1.0, 0.0) / smSize), compare);
    result += texture(shadowMap_1, vec3(_418.xy, _418.z));
    vec3 _429 = vec3(uv + (vec2(-1.0, 1.0) / smSize), compare);
    result += texture(shadowMap_1, vec3(_429.xy, _429.z));
    vec3 _440 = vec3(uv + (vec2(0.0, -1.0) / smSize), compare);
    result += texture(shadowMap_1, vec3(_440.xy, _440.z));
    vec3 _448 = vec3(uv, compare);
    result += texture(shadowMap_1, vec3(_448.xy, _448.z));
    vec3 _459 = vec3(uv + (vec2(0.0, 1.0) / smSize), compare);
    result += texture(shadowMap_1, vec3(_459.xy, _459.z));
    vec3 _470 = vec3(uv + (vec2(1.0, -1.0) / smSize), compare);
    result += texture(shadowMap_1, vec3(_470.xy, _470.z));
    vec3 _481 = vec3(uv + (vec2(1.0, 0.0) / smSize), compare);
    result += texture(shadowMap_1, vec3(_481.xy, _481.z));
    vec3 _492 = vec3(uv + (vec2(1.0) / smSize), compare);
    result += texture(shadowMap_1, vec3(_492.xy, _492.z));
    return result / 9.0;
}

float shadowTestCascade(sampler2DShadow shadowMap_1, vec3 eye_1, vec3 p, float shadowsBias_1)
{
    float d = distance(eye_1, p);
    int param;
    int param_1;
    mat4 _582 = getCascadeMat(d, param, param_1);
    int casi = param;
    int casIndex = param_1;
    mat4 LWVP = _582;
    vec4 lPos = LWVP * vec4(p, 1.0);
    vec3 _597 = lPos.xyz / vec3(lPos.w);
    lPos = vec4(_597.x, _597.y, _597.z, lPos.w);
    float visibility = 1.0;
    if (lPos.w > 0.0)
    {
        visibility = PCF(shadowMap_1, lPos.xy, lPos.z - shadowsBias_1, vec2(4096.0, 1024.0));
    }
    float nextSplit = casData[16][casi];
    float _622;
    if (casi == 0)
    {
        _622 = nextSplit;
    }
    else
    {
        _622 = nextSplit - casData[16][casi - 1];
    }
    float splitSize = _622;
    float splitDist = (nextSplit - d) / splitSize;
    if ((splitDist <= 0.1500000059604644775390625) && (casi != 3))
    {
        int casIndex2 = casIndex + 4;
        mat4 LWVP2 = mat4(vec4(casData[casIndex2]), vec4(casData[casIndex2 + 1]), vec4(casData[casIndex2 + 2]), vec4(casData[casIndex2 + 3]));
        vec4 lPos2 = LWVP2 * vec4(p, 1.0);
        vec3 _700 = lPos2.xyz / vec3(lPos2.w);
        lPos2 = vec4(_700.x, _700.y, _700.z, lPos2.w);
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

void main()
{
    vec4 g0 = textureLod(gbuffer0, texCoord, 0.0);
    vec3 n;
    n.z = (1.0 - abs(g0.x)) - abs(g0.y);
    vec2 _749;
    if (n.z >= 0.0)
    {
        _749 = g0.xy;
    }
    else
    {
        _749 = octahedronWrap(g0.xy);
    }
    n = vec3(_749.x, _749.y, n.z);
    n = normalize(n);
    float roughness = g0.z;
    float param;
    uint param_1;
    unpackFloatInt16(g0.w, param, param_1);
    float metallic = param;
    uint matid = param_1;
    vec4 g1 = textureLod(gbuffer1, texCoord, 0.0);
    vec2 occspec = unpackFloat2(g1.w);
    vec3 albedo = surfaceAlbedo(g1.xyz, metallic);
    vec3 f0 = surfaceF0(g1.xyz, metallic);
    float depth = (textureLod(gbufferD, texCoord, 0.0).x * 2.0) - 1.0;
    vec3 p = getPos(eye, eyeLook, normalize(viewRay), depth, cameraProj);
    vec3 v = normalize(eye - p);
    float dotNV = max(dot(n, v), 0.0);
    vec2 envBRDF = texelFetch(senvmapBrdf, ivec2(vec2(dotNV, 1.0 - roughness) * 256.0), 0).xy;
    vec3 envl = shIrradiance(n, shirr);
    vec3 reflectionWorld = reflect(-v, n);
    float lod = getMipFromRoughness(roughness, float(envmapNumMipmaps));
    vec3 prefilteredColor = textureLod(senvmapRadiance, envMapEquirect(reflectionWorld), lod).xyz;
    envl *= albedo;
    envl *= (vec3(1.0) - ((f0 * envBRDF.x) + vec3(envBRDF.y)));
    envl += (prefilteredColor * ((f0 * envBRDF.x) + vec3(envBRDF.y)));
    envl *= (envmapStrength * occspec.x);
    fragColor = vec4(envl.x, envl.y, envl.z, fragColor.w);
    vec3 _913 = fragColor.xyz * textureLod(ssaotex, texCoord, 0.0).x;
    fragColor = vec4(_913.x, _913.y, _913.z, fragColor.w);
    vec3 emission = textureLod(gbufferEmission, texCoord, 0.0).xyz;
    vec3 _925 = fragColor.xyz + emission;
    fragColor = vec4(_925.x, _925.y, _925.z, fragColor.w);
    vec3 sh = normalize(v + sunDir);
    float sdotNH = max(0.0, dot(n, sh));
    float sdotVH = max(0.0, dot(v, sh));
    float sdotNL = max(0.0, dot(n, sunDir));
    float svisibility = 1.0;
    vec3 sdirect = lambertDiffuseBRDF(albedo, sdotNL) + (specularBRDF(f0, roughness, sdotNL, sdotNH, dotNV, sdotVH) * occspec.y);
    svisibility = shadowTestCascade(shadowMap, eye, p + ((n * shadowsBias) * 10.0), shadowsBias);
    vec3 _985 = fragColor.xyz + ((sdirect * svisibility) * sunCol);
    fragColor = vec4(_985.x, _985.y, _985.z, fragColor.w);
    fragColor.w = 1.0;
}

