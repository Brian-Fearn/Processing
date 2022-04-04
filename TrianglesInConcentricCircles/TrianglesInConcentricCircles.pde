PGraphics pg;
color bgColor = color(255, 245, 235); // color(240, 250, 255);

void setup() {
  size(900, 900, P3D);
  colorMode(RGB, 255, 255, 255, 1.0);
  pg = createGraphics(2160, 2160, P3D);
  pg.smooth(8);
  pixelDensity(displayDensity());
  pg.beginDraw();
  pg.colorMode(RGB, 255, 255, 255, 1.0);
  pg.ellipseMode(RADIUS);
  pg.endDraw();
}

boolean save = false;

void draw() {
  pg.beginDraw();
  if (frameCount == 1) {
    pg.background(bgColor);
  }
  pg.fill(0);
  pg.noFill();
  pg.textSize(30);
  float r = pg.width / 2 - 10;
  float initR = r;
  PVector c = new PVector(pg.width / 2, pg.height / 2);
  while (r > initR / 10) {
    int n = 40; // triangle "segments" per circle
    float angle = 0;
    for (int i = 0; i < n; i++) {
      angle = i * 2 * PI / n;
      PVector p = new PVector(c.x + r * cos(angle), c.y + r * sin(angle));
      float len = 5 + (r - r * 0.63) * (pow(abs(angle - PI) / PI, 1.2)); // height of triangle. no formula for determing these values, just experimentation
      PVector diff = new PVector(c.x, c.y).sub(p).normalize().mult(len); // side of triangle pointing in toward center
      angle = (i + 1) * 2 * PI / n;
      PVector p2 = new PVector(c.x + r * cos(angle), c.y + r * sin(angle));
      float area = triangleArea(p, new PVector(p.x + diff.x, p.y + diff.y), p2);
      shadeTriangle(p.x, p.y, p.x + diff.x, p.y + diff.y, p2.x, p2.y, 10 + int(area / 40), 0.2, color(0, 30, 100));
      len = 5 + (r - r * 0.63) * (pow(abs(angle - PI) / PI, 1.2));
      PVector diff2 = new PVector(c.x, c.y).sub(p2).normalize().mult(len);
      shadeTriangle(p.x, p.y, p2.x + diff2.x, p2.y + diff2.y, p2.x, p2.y, 10 + int(area / 40), 0.12, color(0, 30, 100));
    } 
    c.x -= r * 0.18; // move center to left
    r *= 0.8;
  }
  pg.endDraw();
  image(pg, 0, 0, width, height);
  if (save) {
    pg.save("TrianglesInConcentricCircles" + int(random(100000000)) + ".png");
    save = false;
    println("saved");
  }
  //println(frameRate);
}

void mouseClicked() {
  save = true;
}

void shadeTriangle(float x1, float y1, float x2, float y2, float x3, float y3, int nDots, float alpha, color col) {
  PVector a = new PVector(x1, y1);
  PVector b = new PVector(x2, y2);
  PVector c = new PVector(x3, y3);
  pg.stroke(col, alpha);
  for (int i = 0; i < nDots; i++) {
    float r = pow(random(1), 10);
    pg.strokeWeight(1 + 2 * r);
    PVector p = randomInTriangle(a, b, c);
    pg.point(p.x, p.y);    
  }
}

// thank you Math Stack Exchange for the formula: https://math.stackexchange.com/questions/18686/uniform-random-point-in-triangle-in-3d
PVector randomInTriangle(PVector a, PVector b, PVector c) {
  float r1 = random(1);
  float r2 = random(1);
  PVector point = new PVector(0, 0);
  point.add(PVector.mult(a, 1 - sqrt(r1)));
  point.add(PVector.mult(b, sqrt(r1) * (1 - r2)));
  point.add(PVector.mult(c, r2 * sqrt(r1)));
  return point;
}

// see: https://mathworld.wolfram.com/TriangleArea.html
float triangleArea(PVector a, PVector b, PVector c) {
  PVector u = c.copy().sub(a);
  PVector v = c.copy().sub(b);
  return 0.5 * u.cross(v).mag();
}
