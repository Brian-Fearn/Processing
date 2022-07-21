PGraphics pg;
int arms = 2;

void setup() {
  size(900, 900, P2D);
  pg = createGraphics(1080, 1080, P2D);
  colorMode(HSB, 360, 100, 100, 100);
  pg.smooth(8);
  pg.beginDraw();
  pg.ellipseMode(RADIUS);
  pg.colorMode(HSB, 360, 100, 100, 100);
  pg.endDraw();
}

void draw() {
  pg.beginDraw();
  pg.background(245, 90, 5);
  pg.noStroke();
  int n = 90;
  float inc = 1.0 * pg.width / n;
  float maxD = dist(0, 0, pg.width / 2, pg.height / 2);
  float spiralAdd = 10.0;
  float spiralExp = 5;
  float shadeExp = 3;
  float speed = 4;
  float proportion = 0.1;
  for (int yi = 0; yi < n; yi++) {
    float y = inc * yi + inc / 2;
    for (int xi = 0; xi < n; xi++) {
      float x = inc * xi + inc / 2;
      float th = atan2(y - pg.height / 2, x - pg.width / 2);
      pg.fill(color(abs(th) / PI * 45, 90, 100));
      float d = dist(x, y, pg.width / 2, pg.height / 2);
      float fd = 0.5 * (1 + sin(d / maxD * TAU * (1 + spiralAdd * pow(d / maxD, spiralExp)) + th * arms + radians(-frameCount * speed)));
      pg.circle(x, y, inc / 2 * (0.1 + 0.8 * pow(fd, shadeExp)));
    }
  }
  pg.endDraw();
  image(pg, 0, 0, width, height);
  println(frameRate);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      arms++;
    }
    if (keyCode == DOWN && arms > 1) {
      arms--;
    }
  }
}
