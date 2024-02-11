#version 330

const vec3 _345[3] = vec3[](vec3(1.0), vec3(0.0, 0.236836016178131103515625, 1.0), vec3(0.0, 0.236836016178131103515625, 1.0));
const float _359[3] = float[](0.063636370003223419189453125, 0.75454580783843994140625, 1.0);

in vec3 wnormal;
in vec3 bposition;
out vec4 fragColor[3];

float hash_f(vec3 co)
{
    return fract(sin(dot(co, vec3(12.98980045318603515625, 78.233001708984375, 52.82649993896484375)) * 24.3840007781982421875) * 43758.546875);
}

float voronoi_distance(vec3 a, vec3 b, int metric, float exponent)
{
    if (metric == 0)
    {
        return distance(a, b);
    }
    else
    {
        if (metric == 1)
        {
            return (abs(a.x - b.x) + abs(a.y - b.y)) + abs(a.z - b.z);
        }
        else
        {
            if (metric == 2)
            {
                return max(abs(a.x - b.x), max(abs(a.y - b.y), abs(a.z - b.z)));
            }
            else
            {
                if (metric == 3)
                {
                    return pow((pow(abs(a.x - b.x), exponent) + pow(abs(a.y - b.y), exponent)) + pow(abs(a.z - b.z), exponent), 1.0 / exponent);
                }
                else
                {
                    return 0.5;
                }
            }
        }
    }
}

vec3 tex_voronoi(vec3 coord, float r, int metric, int outp, float scale, float _exp)
{
    float randomness = clamp(r, 0.0, 1.0);
    vec3 scaledCoord = coord * scale;
    vec3 cellPosition = floor(scaledCoord);
    vec3 localPosition = scaledCoord - cellPosition;
    float minDistance = 8.0;
    vec3 targetOffset;
    vec3 targetPosition;
    for (int k = -1; k <= 1; k++)
    {
        for (int j = -1; j <= 1; j++)
        {
            for (int i = -1; i <= 1; i++)
            {
                vec3 cellOffset = vec3(float(i), float(j), float(k));
                vec3 pointPosition = cellOffset;
                if (randomness != 0.0)
                {
                    pointPosition += (vec3(hash_f(cellPosition + cellOffset), hash_f((cellPosition + cellOffset) + vec3(972.3699951171875)), hash_f((cellPosition + cellOffset) + vec3(342.480010986328125))) * randomness);
                }
                float distanceToPoint = voronoi_distance(pointPosition, localPosition, metric, _exp);
                if (distanceToPoint < minDistance)
                {
                    targetOffset = cellOffset;
                    minDistance = distanceToPoint;
                    targetPosition = pointPosition;
                }
            }
        }
    }
    if (outp == 0)
    {
        return vec3(minDistance);
    }
    else
    {
        if (outp == 1)
        {
            if (randomness == 0.0)
            {
                return vec3(hash_f(cellPosition + targetOffset), hash_f((cellPosition + targetOffset) + vec3(972.3699951171875)), hash_f((cellPosition + targetOffset) + vec3(342.480010986328125)));
            }
            return (targetPosition - targetOffset) / vec3(randomness);
        }
    }
    return (targetPosition + cellPosition) / vec3(scale);
}

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
    float VoronoiTexture_Distance_res = tex_voronoi(bposition, 1.0, 0, 0, 6.0, 0.5).x;
    float ColorRamp_fac = VoronoiTexture_Distance_res;
    int ColorRamp_i = 0 + int(ColorRamp_fac > 0.75454580783843994140625);
    vec3 ColorRamp_Color_res = mix(_345[ColorRamp_i], _345[ColorRamp_i + 1], vec3(max((ColorRamp_fac - _359[ColorRamp_i]) * (1.0 / (_359[ColorRamp_i + 1] - _359[ColorRamp_i])), 0.0)));
    vec3 basecol = ColorRamp_Color_res;
    float roughness = 0.0764710009098052978515625;
    float metallic = 0.0;
    float occlusion = 1.0;
    float specular = 0.5;
    vec3 emissionCol = vec3(0.0);
    n /= vec3((abs(n.x) + abs(n.y)) + abs(n.z));
    vec2 _408;
    if (n.z >= 0.0)
    {
        _408 = n.xy;
    }
    else
    {
        _408 = octahedronWrap(n.xy);
    }
    n = vec3(_408.x, _408.y, n.z);
    fragColor[0] = vec4(n.xy, roughness, packFloatInt16(metallic, 0u));
    fragColor[1] = vec4(basecol, packFloat2(occlusion, specular));
    fragColor[2] = vec4(emissionCol, 0.0);
}

