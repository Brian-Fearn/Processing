uniform vec2 center;
uniform vec3 centerColor;
uniform float radius;
uniform float glowRadius;
uniform bool linear;
uniform vec3 color;
varying vec2 va_pos;
void main() {
  float d = length(va_pos - center);
  float glow = pow(1. - (d - radius) / glowRadius, 2.);
  vec3 col = d < radius 
        ? vec3(1.)
        : d < radius + glowRadius ? vec3(glow) : vec3(0.);
  gl_FragColor = vec4(color, col.x);
}
