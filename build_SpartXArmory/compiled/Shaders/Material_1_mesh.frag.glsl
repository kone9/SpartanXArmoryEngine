#version 450
#include "compiled.inc"
#include "std/gbuffer.glsl"
in vec3 wnormal;
in vec2 texCoord;
in mat3 TBN;
out vec4 fragColor[GBUF_SIZE];
uniform sampler2D ImageTexture;
void main() {
	vec3 n = normalize(wnormal);
	vec4 ImageTexture_texread_store = texture(ImageTexture, texCoord.xy);
	vec3 ImageTexture_Color_res = ImageTexture_texread_store.rgb;
	n = (ImageTexture_Color_res) * 2.0 - 1.0;
	n.xy *= 0.19150499999523163;
	n = normalize(TBN * n);
	vec3 basecol;
	float roughness;
	float metallic;
	float occlusion;
	float specular;
	vec3 emissionCol;
	vec3 NormalMap_Normal_res = n;
	n = NormalMap_Normal_res;
	basecol = vec3(0.003469000104814768, 0.05448000133037567, 0.040915001183748245);
	roughness = 0.1038297712802887;
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
