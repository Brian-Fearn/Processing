uniform vec2 center;
uniform vec3 centerColor;
uniform float radius;
uniform float glowRadius;
uniform float glowFalloff;
uniform vec3 color;
uniform vec3 color2; 
varying vec2 va_pos;
void main() {
  
  float d = length(va_pos - center);
  vec3 colorBlend = mix(color, color2, ((center + radius + glowRadius).x - va_pos.x) / ((radius + glowRadius) * 2.));
  float glow = pow(1. - (d - radius) / glowRadius, glowFalloff);
  vec3 col = d < radius 
        ? vec3(1.)
        : d < radius + glowRadius ? vec3(glow) : vec3(0.);
  gl_FragColor = vec4(colorBlend, col.x);
}