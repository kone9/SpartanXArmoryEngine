#ifndef _COMPILED_GLSL_
#define _COMPILED_GLSL_
#define _Irr
#define _Rad
#define _Deferred
#define _ShadowMap
#define _CSM
#define _Sun
#define _Brdf
#define _SMAA
#define _SSAO
#define _Deferred
#define _ShadowMap
#define _CSM
#define _SMAA
#define _SSAO
#define _Deferred
#define _ShadowMap
#define _CSM
#define _SMAA
#define _SSAO
#define _EmissionShaded
#define _Deferred
#define _ShadowMap
#define _CSM
#define _SMAA
#define _SSAO
#define _Deferred
#define _ShadowMap
#define _CSM
#define _SMAA
#define _SSAO
#define _CToneFilmic
#define GBUF_SIZE 3
#define GBUF_IDX_0 0
#define GBUF_IDX_1 1
#define GBUF_IDX_EMISSION 2
#if defined(HLSL) || defined(METAL)
#define _InvY
#endif
const float PI = 3.1415926535;
const float PI2 = PI * 2.0;
const vec2 shadowmapSize = vec2(1024, 1024);
const float shadowmapCubePcfSize = 0.001;
const int shadowmapCascades = 4;
const float ssaoRadius = 1.0;
const float ssaoStrength = 1.0;
const float ssaoScale = 20.0;
const int skinMaxBones = 82;

#endif // _COMPILED_GLSL_
