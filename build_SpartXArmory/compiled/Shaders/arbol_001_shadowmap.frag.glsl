#version 450
in vec2 texCoord;
uniform sampler2D ImageTexture;
void main() {
	vec3 UVMap_texread_UV_res = vec3(texCoord.x, 1.0 - texCoord.y, 0.0);
	UVMap_texread_UV_res = (UVMap_texread_UV_res);
	vec3 Mapping_texread_Vector_res = UVMap_texread_UV_res;
	vec4 ImageTexture_texread_store = texture(ImageTexture, vec2(Mapping_texread_Vector_res.x, 1.0 - Mapping_texread_Vector_res.y).xy);
	float opacity;
	float ImageTexture_Alpha_res = ImageTexture_texread_store.a;
	opacity = ImageTexture_Alpha_res - 0.0002;
	if (opacity < 1.0) discard;
}
