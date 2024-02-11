#version 330

uniform sampler2D ImageTexture;

in vec2 texCoord;

void main()
{
    vec3 UVMap_texread_UV_res = vec3(texCoord.x, 1.0 - texCoord.y, 0.0);
    UVMap_texread_UV_res = UVMap_texread_UV_res;
    vec3 Mapping_texread_Vector_res = UVMap_texread_UV_res;
    vec4 ImageTexture_texread_store = texture(ImageTexture, vec2(Mapping_texread_Vector_res.x, 1.0 - Mapping_texread_Vector_res.y));
    float ImageTexture_Alpha_res = ImageTexture_texread_store.w;
    float opacity = ImageTexture_Alpha_res - 0.00019999999494757503271102905273438;
    if (opacity < 1.0)
    {
        discard;
    }
}

