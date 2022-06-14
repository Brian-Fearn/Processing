varying vec2 va_pos;
uniform vec2 resolution;
uniform sampler2D sampler;
uniform int y;
uniform float iTime;

void main()
{
    vec2 uv = va_pos / resolution.xy;
    // float xPivot = 0.5 + 0.2 * sin(iTime * 0.1);
    float f = 1. - 4. * uv.x * uv.y;
    float freq = 2.5 - 5. * 0.5 * (1. + sin(iTime * 0.2));
    float xpos = mod(uv.x + f * 0.5 * (1. + sin(freq * uv.y + iTime)), 1.);
    vec3 col = texture(sampler, vec2(xpos, 0.)).rgb;

    gl_FragColor = vec4(col, 1.0);
}

