void setup() {
  size(900, 900, P3D);
  smooth(8);
  colorMode(HSB, 360, 100, 100, 100);
}

void draw() {
  background(150, 80, 10);
  noStroke();
  int pixPerInc = 1;
  int petals = 10;
  int flowersX = 4;
  int flowersY = 4;
  float timeFactor = radians(frameCount * 2.5);
  float baseR = height / flowersY / 2;
  float useR = baseR * 0.95;
  int n = int(baseR * 2 * PI / pixPerInc);
  float inc = 2 * PI / n;
  for (int yi = 0; yi < flowersY; yi++) {
    for (int xi = 0; xi < flowersX; xi++) {
      float timeOffset = xi * PI / flowersX;
      float power = 1 + 10.0 * pow(abs(sin(radians(frameCount * 0.5) - timeOffset)), 4);
      fill((175 + xi * 45 + yi * 20) % 360, 75, 90);
      PVector origin = new PVector(baseR + baseR * 2 * xi, baseR + baseR * 2 * yi);
      beginShape();
      for (int i = 0; i <= n; i++) {
        float angle = i * inc;
        float r = useR * pow(abs(sin(petals / 2 * angle + timeFactor + timeOffset)), power);
        PVector p = PVector.fromAngle(angle).mult(useR - r).add(origin);
        vertex(p.x, p.y);
      }
      endShape();
      
      fill((225 + xi * 45 + yi * 20) % 360, 75, 90);
      float timeFactor2 = radians(frameCount * 2.3);
      beginShape();
      for (int i = 0; i <= n; i++) {
        float angle = i * inc;
        float r = useR * pow(abs(sin(petals / 2 * angle + timeFactor2)), power);
        PVector p = PVector.fromAngle(angle).mult(useR - r).add(origin);
        vertex(p.x, p.y);
      }
      endShape();
    }
  }
  println(frameCount / 60 + " --- " + frameRate);
}
