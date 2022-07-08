PGraphics pg;

void setup() {
  size(900, 900, P3D);
  pg = createGraphics(1080, 1080, P3D);
  pg.smooth(8);
  pg.beginDraw();
  pg.noStroke();
  pg.endDraw();
}

void draw() {
  pg.beginDraw();
  pg.background(0);
  float n = 300;
  float xn = 25, yn = 25;
  color colA = color(50, 75, 150);
  color colB = color(255, 225, 200);
  for (float yi = 0; yi < yn; yi++) {
    float y = yi * pg.height / yn + pg.height / yn / 2;
    for (float xi = 0; xi < xn; xi++) {
      float x = xi * pg.width / yn + pg.width / yn / 2;
      PVector c = new PVector(x, y);
      float sinf = 0.25 * (2 + sin(map(yi, 0, yn, 0, TAU) + radians(frameCount * 1.3)) + sin(map(xi, 0, xn, 0, TAU) + radians(frameCount)));
      float maxAngle = PI / 8 + 15 * PI / 8 * pow(sinf, 3);
      float thisN = int(n * maxAngle / TAU);
      pg.beginShape(QUAD_STRIP);
      for (int i = 0; i <= thisN; i++) {
        float th = i * TAU / n;
        color col = lerpColor(colA, colB, pow(abs(th - maxAngle / 2) / (maxAngle / 2), 2));
        pg.fill(col);
        PVector p = PVector.fromAngle(th + radians(frameCount) + map(xi, 0, xn, 0, TAU)).mult(0.95 * pg.width / xn / 2).add(c);
        pg.vertex(c.x, c.y);
        pg.vertex(p.x, p.y);
      }
      pg.endShape();
    }
  }
  pg.endDraw();
  image(pg, 0, 0, width, height);
  println(frameCount / 60);
}
