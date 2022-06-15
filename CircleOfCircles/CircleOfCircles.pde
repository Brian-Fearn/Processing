void setup() {
  size(900, 900, P2D);
  smooth(8);
  ellipseMode(RADIUS);
}

void draw() {
  background(0, 25, 35);
  noStroke();
  PVector o = new PVector(width / 2, height / 2);
  float t = 0.2 + 0.8 * 0.5 * (1 + sin(radians(frameCount * 0.2)));
  float r = t * width / 3;
  float maxR = width / 2 - 10;
  int n = 1000;
  fill(255, 200, 150);
  for (int i = 0; i < n; i++) {
    float th = i * 2 * PI / n;
    float th2 = 2 * PI * mouseY / height + sin(radians(frameCount * 0.2)) * 4 * PI;
    float d = pow(PVector.fromAngle(th).sub(PVector.fromAngle(th2)).mag() / 2, 3);
    float nz = noise(i * 30000, frameCount * 0.01);
    float nzd = nz * (maxR - r) * d;
    PVector p = PVector.fromAngle(th + 0.01 * noise(i * 23456, frameCount * 0.023)).mult(r + nzd).add(o);
    circle(p.x, p.y, 1 + noise(i) * nzd / 15);
  }
}
