PGraphics pg;
PShader glowShader;

void setup() {
  size(900, 900, P2D);
  pg = createGraphics(1080, 1080, P2D);
  pg.smooth(8);
  pg.beginDraw();
  pg.ellipseMode(RADIUS);
  glowShader = new PShader(this, "GradientShader.vert", "GradientShader.frag");
  pg.blendMode(ADD);
  pg.colorMode(RGB, 255, 255, 255, 1.0);
  pg.endDraw();
  colorMode(RGB, 255, 255, 255, 1.0);
}

void draw() {
  pg.beginDraw();
  pg.background(0);
  int n = 10;
  float inc = pg.width / n;
  float rBase = inc / 2;
  float glowPortion = 0.05; // + 0.7 * mouseX / width;
  for (int yi = 0; yi < n; yi++) {
    for (int xi = 0; xi < n; xi++) {
      float t1 = 0.5 * (1 + sin(radians(frameCount + xi * 17)));
      float t2 = 0.5 * (1 + sin(radians(frameCount * 0.7 + yi * 13)));
      float yDev = yi % 2 == 0 ? sin(PI + radians(frameCount * 0.5)) : 0;
      PVector originDev = new PVector(xi * inc + inc / 2, yDev * inc + yi * inc + inc / 2);
      PVector origin = new PVector(xi * inc + inc / 2, yi * inc + inc / 2);
      pg.shader(glowShader);
      float r = rBase / 4 +  2 * rBase / 3 * pow(t1, 5);
      glowShader.set("radius", r * (1 - glowPortion));
      glowShader.set("glowRadius", r * glowPortion);
      glowShader.set("glowFalloff", 0.5);
      glowShader.set("center", origin.x, origin.y);
      glowShader.set("color", new PVector(1.0 * xi / n * t1, 0.0, 0.0));
      glowShader.set("color2", new PVector(0.0, 1.0 * yi / n * t2, 1.0));
      pg.circle(origin.x, origin.y, r);
      pg.shader(glowShader);
      glowShader.set("center", origin.x, originDev.y);
      pg.circle(origin.x, originDev.y, r);
    }
  }
  pg.endDraw();
  image(pg, 0, 0, width, height);
  println(frameCount / 60);
}
