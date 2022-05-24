void setup() {
  size(1600, 900, P2D);
  colorMode(HSB, 360, 100, 100, 100);
  smooth(8);
  ellipseMode(RADIUS);
  noStroke();
}

void draw() {
  background(0);
  int ny = 36;
  int nx = 64;
  float inc = 1.0 * height / ny;
  float t = radians(frameCount);
  for (int yi = 0; yi < ny; yi++) {
    for (int xi = 0; xi < nx; xi++) {
      float x = xi * inc;
      float y = yi * inc;
      float base = 1.0 * 0.5 * (1.0 + sin((1 + sin(t * 0.2) * 0.1 * yi) * map(x, 0, height, 0, 2 * PI) - t));
      float yDisp = pow(base, 1 + 4 * 0.5 * (1 + sin(t * 0.3)));
      fill(225, 100, 80 * (1 - base));
      square(x, y, inc);
      yDisp *= inc * 1.1;
      fill(50 - 50 * yDisp / (inc * 1.1), 65 + 35 * yDisp, 100, 100);
      circle(x + inc / 2, y + inc / 2 + yDisp, 0.8 * inc / 2);
    }
  }
  println(frameRate);
}
