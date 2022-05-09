
void setup() {
  size(900, 900, P3D);
  smooth(8);
  blendMode(ADD);
}

void draw() {
  background(0);
  noStroke();
  fill(255, 150, 100, 100);
  int n = 150;
  float maxR = 400;
  float r = maxR - maxR * abs(sin(radians(frameCount * 0.17)));
  float x = r + (width - r * 2) * (0.5 * (1 + sin(radians(frameCount * 0.33))));
  float y = r + (height - r * 2) * (0.5 * (1 + sin(radians(frameCount * 0.23))));
  PVector origin = new PVector(x, y);
  float init = radians(frameCount * 0.13);
  fill(255, 150, 10, 80);
  for (int i = 0; i < n; i++) {
    float frac = 1.0 * i / n;
    float angle = init + frac * 2 * PI; // 2 * PI * (1 - pow(2 * frac - 1, 2)) + init;
    PVector p = PVector.fromAngle(angle).mult(r).add(origin);
    float tanAngle = angle + PI / 2;
    PVector dir = PVector.fromAngle(tanAngle);
    PVector p2 = dir.copy().mult(width * 1.5).add(p);
    PVector p3 = dir.copy().mult(-width * 1.5).add(p);
    triangle(p2.x, p2.y, p2.x + 10, p2.y, p3.x, p3.y);
  }
  
  r = maxR - maxR * abs(sin(radians(PI / 3 + frameCount * 0.13)));
  x = r + (width - r * 2) * (0.5 * (1 + sin(radians(frameCount * 0.29))));
  y = r + (height - r * 2) * (0.5 * (1 + sin(radians(frameCount * 0.19))));
  origin = new PVector(x, y);
  init = radians(frameCount * 0.07);
  fill(150, 150, 255, 80);
  for (int i = 0; i < n; i++) {
    float frac = 1.0 * i / n;
    float angle = init + frac * 2 * PI; // 2 * PI * (1 - pow(2 * frac - 1, 2)) + init;
    PVector p = PVector.fromAngle(angle).mult(r).add(origin);
    float tanAngle = angle + PI / 2;
    PVector dir = PVector.fromAngle(tanAngle);
    PVector p2 = dir.copy().mult(width * 1.5).add(p);
    PVector p3 = dir.copy().mult(-width * 1.5).add(p);
    triangle(p2.x, p2.y, p2.x, p2.y + 10, p3.x, p3.y);
  }
  println(frameCount / 60);
}
