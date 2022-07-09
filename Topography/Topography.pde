import java.util.Date;

PGraphics pg;
float sc = 0.004;
boolean drawBg = true;
boolean save = false;

void setup() {
  randomSeed(10L);
  noiseSeed(10L);
  size(900, 900, P2D);
  pg = createGraphics(1080, 1080, P2D);
  colorMode(HSB, 360, 100, 100, 100);
  pg.smooth(8);
  pg.beginDraw();
  pg.colorMode(HSB, 360, 100, 100, 100);
  pg.endDraw();
  
}

void draw() {
  pg.beginDraw();
  if (drawBg) {
    pg.background(0);
    drawBg = false;
  }
  int perFrame = 10000;
  for (int i = 0; i < perFrame; i++) {
    float x = random(pg.width);
    float y = random(pg.height);
    float n2 = pow(noise(x * sc + 10000, y * sc + 10000, 100000), 5);
    float m = 10 + n2 * 100;
    float n = noise(x * sc, y * sc);
    float fn = pow(0.5 * (1 + sin(map(n, 0, 1, 0, 2 * PI) * m)), 5);
    pg.stroke(40 * fn, 100, 100 * fn);
    pg.point(x, y);
  }
  if (save) {
    pg.save(getClass().getName() + new Date().getTime() + ".png");
    save = false;
  }
  pg.endDraw();
  image(pg, 0, 0, width, height);
  println(frameRate);
}

void mouseClicked() {
  save = true;
}
