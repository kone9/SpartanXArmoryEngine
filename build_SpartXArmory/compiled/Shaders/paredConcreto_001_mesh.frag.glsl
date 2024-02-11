#version 450
#include "compiled.inc"
#include "std/gbuffer.glsl"
in vec3 wnormal;
in vec2 texCoord;
in mat3 TBN;
out vec4 fragColor[GBUF_SIZE];
uniform sampler2D ImageTexture_001;
uniform sampler2D ImageTexture;
void main() {
	vec3 n = normalize(wnormal);
	vec4 ImageTexture_001_texread_store = texture(ImageTexture_001, texCoord.xy);
	vec3 UVMap_texread_UV_res = vec3(texCoord.x, 1.0 - texCoord.y, 0.0);
	UVMap_texread_UV_res = (UVMap_texread_UV_res);
	vec3 Mapping_texread_Vector_res = UVMap_texread_UV_res;
	vec4 ImageTexture_texread_store = texture(ImageTexture, vec2(Mapping_texread_Vector_res.x, 1.0 - Mapping_texread_Vector_res.y).xy);
	ImageTexture_texread_store.rgb = pow(ImageTexture_texread_store.rgb, vec3(2.2));
	vec3 ImageTexture_001_Color_res = ImageTexture_001_texread_store.rgb;
	n = (ImageTexture_001_Color_res) * 2.0 - 1.0;
	n.xy *= -0.5;
	n = normalize(TBN * n);
	vec3 basecol;
	float roughness;
	float metallic;
	float occlusion;
	float specular;
	vec3 emissionCol;
	vec3 NormalMap_Normal_res = n;
	n = NormalMap_Normal_res;
	vec3 ImageTexture_Color_res = ImageTexture_texread_store.rgb;
	basecol = ImageTexture_Color_res;
	roughness = 1.0;
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
