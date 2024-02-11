#version 450
#include "compiled.inc"
#include "std/gbuffer.glsl"
in vec3 wnormal;
in vec3 bposition;
out vec4 fragColor[GBUF_SIZE];
const vec3 COLORRAMP_COLS[3] = vec3[](vec3(1.0, 1.0, 1.0), vec3(0.0, 0.2368360161781311, 1.0), vec3(0.0, 0.2368360161781311, 1.0));
const float COLORRAMP_FACS[3] = float[](0.06363637000322342, 0.7545458078384399, 1.0);

//	<https://www.shadertoy.com/view/4dS3Wd>
//	By Morgan McGuire @morgan3d, http://graphicscodex.com
float hash_f(const float n) { return fract(sin(n) * 1e4); }
float hash_f(const vec2 p) { return fract(1e4 * sin(17.0 * p.x + p.y * 0.1) * (0.1 + abs(sin(p.y * 13.0 + p.x)))); }
float hash_f(const vec3 co){ return fract(sin(dot(co.xyz, vec3(12.9898,78.233,52.8265)) * 24.384) * 43758.5453); }

float noise(const vec3 x) {
	const vec3 step = vec3(110, 241, 171);

	vec3 i = floor(x);
	vec3 f = fract(x);
 
	// For performance, compute the base input to a 1D hash from the integer part of the argument and the 
	// incremental change to the 1D based on the 3D -> 1D wrapping
    float n = dot(i, step);

	vec3 u = f * f * (3.0 - 2.0 * f);
	return mix(mix(mix( hash_f(n + dot(step, vec3(0, 0, 0))), hash_f(n + dot(step, vec3(1, 0, 0))), u.x),
                   mix( hash_f(n + dot(step, vec3(0, 1, 0))), hash_f(n + dot(step, vec3(1, 1, 0))), u.x), u.y),
               mix(mix( hash_f(n + dot(step, vec3(0, 0, 1))), hash_f(n + dot(step, vec3(1, 0, 1))), u.x),
                   mix( hash_f(n + dot(step, vec3(0, 1, 1))), hash_f(n + dot(step, vec3(1, 1, 1))), u.x), u.y), u.z);
}

//  Shader-code adapted from Blender
//  https://github.com/sobotka/blender/blob/master/source/blender/gpu/shaders/material/gpu_shader_material_tex_wave.glsl & /gpu_shader_material_fractal_noise.glsl
float fractal_noise(const vec3 p, const float o)
{
  float fscale = 1.0;
  float amp = 1.0;
  float sum = 0.0;
  float octaves = clamp(o, 0.0, 16.0);
  int n = int(octaves);
  for (int i = 0; i <= n; i++) {
    float t = noise(fscale * p);
    sum += t * amp;
    amp *= 0.5;
    fscale *= 2.0;
  }
  float rmd = octaves - floor(octaves);
  if (rmd != 0.0) {
    float t = noise(fscale * p);
    float sum2 = sum + t * amp;
    sum *= float(pow(2, n)) / float(pow(2, n + 1) - 1.0);
    sum2 *= float(pow(2, n + 1)) / float(pow(2, n + 2) - 1);
    return (1.0 - rmd) * sum + rmd * sum2;
  }
  else {
    sum *= float(pow(2, n)) / float(pow(2, n + 1) - 1); 
    return sum;
  }
}


//Shader-code adapted from Blender
//https://github.com/sobotka/blender/blob/master/source/blender/gpu/shaders/material/gpu_shader_material_tex_voronoi.glsl
float voronoi_distance(const vec3 a, const vec3 b, const int metric, const float exponent)
{
  if (metric == 0)  // SHD_VORONOI_EUCLIDEAN
  {
    return distance(a, b);
  }
  else if (metric == 1)  // SHD_VORONOI_MANHATTAN
  {
    return abs(a.x - b.x) + abs(a.y - b.y) + abs(a.z - b.z);
  }
  else if (metric == 2)  // SHD_VORONOI_CHEBYCHEV
  {
    return max(abs(a.x - b.x), max(abs(a.y - b.y), abs(a.z - b.z)));
  }
  else if (metric == 3)  // SHD_VORONOI_MINKOWSKI
  {
    return pow(pow(abs(a.x - b.x), exponent) + pow(abs(a.y - b.y), exponent) +
                   pow(abs(a.z - b.z), exponent),
               1.0 / exponent);
  }
  else {
    return 0.5;
  }
}

vec3 tex_voronoi(const vec3 coord, const float r, const int metric, const int outp, const float scale, const float exp)
{
  float randomness = clamp(r, 0.0, 1.0);

  vec3 scaledCoord = coord * scale;
  vec3 cellPosition = floor(scaledCoord);
  vec3 localPosition = scaledCoord - cellPosition;

  float minDistance = 8.0;
  vec3 targetOffset, targetPosition;
  for (int k = -1; k <= 1; k++) {
    for (int j = -1; j <= 1; j++) {
      for (int i = -1; i <= 1; i++) {
        vec3 cellOffset = vec3(float(i), float(j), float(k));
        vec3 pointPosition = cellOffset;
        if(randomness != 0.) {
            pointPosition += vec3(hash_f(cellPosition+cellOffset), hash_f(cellPosition+cellOffset+972.37), hash_f(cellPosition+cellOffset+342.48)) * randomness;}
        float distanceToPoint = voronoi_distance(pointPosition, localPosition, metric, exp);
        if (distanceToPoint < minDistance) {
          targetOffset = cellOffset;
          minDistance = distanceToPoint;
          targetPosition = pointPosition;
        }
      }
    }
  }
  if(outp == 0){return vec3(minDistance);}
  else if(outp == 1) {
      if(randomness == 0.) {return vec3(hash_f(cellPosition+targetOffset), hash_f(cellPosition+targetOffset+972.37), hash_f(cellPosition+targetOffset+342.48));}
      return (targetPosition - targetOffset)/randomness;
  }
  return (targetPosition + cellPosition) / scale;
}

void main() {
	vec3 n = normalize(wnormal);
	vec3 basecol;
	float roughness;
	float metallic;
	float occlusion;
	float specular;
	vec3 emissionCol;
	float VoronoiTexture_Distance_res = tex_voronoi(bposition, 1.0, 0, 0, 6.0, 0.5).x;
	float ColorRamp_fac = VoronoiTexture_Distance_res;
	int ColorRamp_i = 0 + ((ColorRamp_fac > 0.7545458078384399) ? 1 : 0);
	vec3 ColorRamp_Color_res = mix(COLORRAMP_COLS[ColorRamp_i], COLORRAMP_COLS[ColorRamp_i + 1], max((ColorRamp_fac - COLORRAMP_FACS[ColorRamp_i]) * (1.0 / (COLORRAMP_FACS[ColorRamp_i + 1] - COLORRAMP_FACS[ColorRamp_i])), 0.0));
	basecol = ColorRamp_Color_res;
	roughness = 0.0764710009098053;
	metallic = 0.0;
	occlusion = 1.0;
	specular = 0.5;
	emissionCol = vec3(0.0);
	n /= (abs(n.x) + abs(n.y) + abs(n.z));
	n.xy = n.z >= 0.0 ? n.xy : octahedronWrap(n.xy);
	const uint matid = 0;
	fragColor[GBUF_IDX_0] = vec4(n.xy, roughness, packFloatInt16(metallic, matid));
	fragColor[GBUF_IDX_1] = vec4(basecol, packFloat2(occlusion, specular));
	#ifdef _EmissionShaded
	fragColor[GBUF_IDX_EMISSION] = vec4(emissionCol, 0.0);
	#endif
}
