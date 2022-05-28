varying vec2 va_pos;
uniform float [10] pointsX;
uniform float [10] pointsY;
uniform float d;
uniform float powerAddition;

// animated take on the concept of Cassini ovals: https://mathworld.wolfram.com/CassiniOvals.html

void main() {
  float prod = 1.0;
  for (int i = 0; i < pointsX.length; i++) {
    vec2 pt = vec2(pointsX[i], pointsY[i]);
    float r = length(pt - va_pos);
    prod *= r;
  }
  float f = 1.0 - prod / pow(d, pointsX.length);

  f = abs(1.5 - f) / 0.5;
  f = 2. * abs(0.5 - fract(pow(f, 0.1) * 5.));
  vec3 col = vec3(max(0., pow(f, 0.2 + powerAddition)), 0., max(0., pow(f, 0.2 + powerAddition)) * 0.3); //  //, 0., f);

  // f = abs(0.5 - f) / 0.5;
  // f = pow(f, 0.2 + powerAddition);
  // vec3 col = vec3(0.7 - f * 0.7, 1. - f, max(0., 0.3 + 0.7 - f * 0.7));
  gl_FragColor = vec4(col, 1.0);
}