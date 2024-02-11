#version 330

in vec3 normal;
out vec4 fragColor;

void main()
{
    vec3 n = normalize(normal);
    fragColor = vec4(vec3(0.050876088440418243408203125).x, vec3(0.050876088440418243408203125).y, vec3(0.050876088440418243408203125).z, fragColor.w);
    fragColor.w = 0.0;
}

