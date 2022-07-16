import java.util.Date;

PGraphics pg;

color bgColor = color(0, 10, 30);
color strokeColor = color(255, 225, 200);

void setup() {
  size(900, 900, P2D);
  colorMode(HSB, 360, 100, 100, 100);
  pg = createGraphics(1080, 1080, P2D);
  pg.smooth(8);
}

boolean drawBg = true;
boolean save = false;

void mouseClicked() {
  save = true;
}

void draw() {
  pg.beginDraw();
  if (drawBg) {
    drawBg = false;
    pg.colorMode(HSB, 360, 100, 100, 100);
    pg.background(220, 90, 10);
  }
  int perFrame = 15000;
  PVector center = new PVector(pg.width / 2, pg.height / 2);
  float maxDist = dist(center.x, center.y, center.x, 0);
  float sinMag = pg.width / 10;
  float sinFreq = 12;
  float rotationMag = 2 * TAU;
  for (int i = 0; i < perFrame; i++) {
    PVector p = new PVector(random(pg.width), random(pg.height));
    float fd = pow(center.copy().sub(p).mag() / maxDist, 0.3);
    float th = rotationMag * pow(1 - fd, 1);
    PVector p2 = p.copy().sub(center).rotate(th).add(center);
    float fy = pg.width / 2 + sinMag * sin(map(p2.y, 0, pg.height, 0, TAU) * sinFreq * (fd));
    float f = abs(p2.x - fy) / (pg.width / 2 + pg.width / 10);
    color c = lerpColor(color(220, 90, 10), color(220, 30 * fd, 90), f);
    pg.stroke(c);
    pg.strokeWeight(random(2));
    pg.point(p.x, p.y);
  }
  if (save) {
    save = false;
    pg.save(getClass().getName() + new Date().getTime() + ".png");
  }
  pg.endDraw();
  image(pg, 0, 0, width, height);
  println(frameRate);
}
