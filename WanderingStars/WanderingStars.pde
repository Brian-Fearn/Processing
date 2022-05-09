
void setup() {
  size(900, 900, P3D);
  smooth(8);
  blendMode(ADD);
}

void draw() {
  background(0);
  stroke(255, 150, 100, 100);
  float maxR = 200;
  float r = maxR - maxR * abs(sin(radians(frameCount * 0.5)));
  int n = 120;
  float init = radians(frameCount * 0.1);
  float x = r + (width - r * 2) * (0.5 * (1 + sin(radians(frameCount * 0.23))));
  PVector origin = new PVector(x, height / 2);
  for (int i = 0; i < n; i++) {
    float frac = 1.0 * i / n;
    float angle = init + frac * 2 * PI; // 2 * PI * (1 - pow(2 * frac - 1, 2)) + init;
    PVector p = PVector.fromAngle(angle).mult(r).add(origin);
    float tanAngle = angle + PI / 2;
    PVector dir = PVector.fromAngle(tanAngle);
    PVector p2 = dir.copy().mult(width * 1.5).add(p);
    PVector p3 = dir.copy().mult(-width * 1.5).add(p);
    line(p2.x, p2.y, p3.x, p3.y);
  }
  
  r = maxR - maxR * abs(sin(radians(PI / 3 + frameCount * 0.3)));
  x = r + (width - r * 2) * (0.5 * (1 + sin(radians(-frameCount * 0.13))));
  origin = new PVector(x, height / 2);
  init = radians(frameCount * 0.17);
  stroke(255, 150, 100, 100);
  for (int i = 0; i < n; i++) {
    float frac = 1.0 * i / n;
    float angle = init + frac * 2 * PI; // 2 * PI * (1 - pow(2 * frac - 1, 2)) + init;
    PVector p = PVector.fromAngle(angle).mult(r).add(origin);
    float tanAngle = angle + PI / 2;
    PVector dir = PVector.fromAngle(tanAngle);
    PVector p2 = dir.copy().mult(width * 1.5).add(p);
    PVector p3 = dir.copy().mult(-width * 1.5).add(p);
    line(p2.x, p2.y, p3.x, p3.y);
  }
  
  r = maxR - maxR * abs(sin(radians(PI / 3 + frameCount * 0.23)));
  float y = r + (height - r * 2) * (0.5 * (1 + sin(radians(-frameCount * 0.17))));
  origin = new PVector(width / 2, y);
  init = radians(frameCount * 0.19);
  stroke(255, 150, 100, 100);
  for (int i = 0; i < n; i++) {
    float frac = 1.0 * i / n;
    float angle = init + frac * 2 * PI; // 2 * PI * (1 - pow(2 * frac - 1, 2)) + init;
    PVector p = PVector.fromAngle(angle).mult(r).add(origin);
    float tanAngle = angle + PI / 2;
    PVector dir = PVector.fromAngle(tanAngle);
    PVector p2 = dir.copy().mult(width * 1.5).add(p);
    PVector p3 = dir.copy().mult(-width * 1.5).add(p);
    line(p2.x, p2.y, p3.x, p3.y);
  }
  
  r = maxR - maxR * abs(sin(radians(PI / 3 + frameCount * 0.37)));
  y = r + (height - r * 2) * (0.5 * (1 + sin(radians(frameCount * 0.29))));
  origin = new PVector(width / 2, y);
  init = radians(frameCount * 0.23);
  stroke(255, 150, 100, 100);
  for (int i = 0; i < n; i++) {
    float frac = 1.0 * i / n;
    float angle = init + frac * 2 * PI; // 2 * PI * (1 - pow(2 * frac - 1, 2)) + init;
    PVector p = PVector.fromAngle(angle).mult(r).add(origin);
    float tanAngle = angle + PI / 2;
    PVector dir = PVector.fromAngle(tanAngle);
    PVector p2 = dir.copy().mult(width * 1.5).add(p);
    PVector p3 = dir.copy().mult(-width * 1.5).add(p);
    line(p2.x, p2.y, p3.x, p3.y);
  }
  
  r = 100 - 100 * abs(sin(radians(PI / 3 + frameCount * 0.17)));
  x = r + (width - r * 2) * (0.5 * (1 + sin(radians(frameCount * 0.33))));
  y = r + (height - r * 2) * (0.5 * (1 + sin(radians(frameCount * 0.23))));
  origin = new PVector(x, y);
  init = radians(frameCount * 0.13);
  stroke(255, 150, 10, 100);
  for (int i = 0; i < n; i++) {
    float frac = 1.0 * i / n;
    float angle = init + frac * 2 * PI; // 2 * PI * (1 - pow(2 * frac - 1, 2)) + init;
    PVector p = PVector.fromAngle(angle).mult(r).add(origin);
    float tanAngle = angle + PI / 2;
    PVector dir = PVector.fromAngle(tanAngle);
    PVector p2 = dir.copy().mult(width * 1.5).add(p);
    PVector p3 = dir.copy().mult(-width * 1.5).add(p);
    line(p2.x, p2.y, p3.x, p3.y);
  }
  println(frameCount / 60);
}
