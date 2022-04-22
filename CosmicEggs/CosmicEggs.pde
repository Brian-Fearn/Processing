PGraphics pg;
int margin = 40;
PVector c;
float r;
float fuzz = 0.15;
float _power = 0.25;

void setup() {
  size(900, 900, P2D);
  pg = createGraphics(1080, 1080, P2D);
  pg.smooth(8);
  pg.beginDraw();
  pg.colorMode(HSB, 360, 100, 100, 100);
  pg.blendMode(ADD);
  pg.background(225, 100, 0);
  pg.stroke(225 + random(-25, 25), 70, 100, 15);
  pg.ellipseMode(RADIUS);
  pg.endDraw();
  r = (pg.width - margin * 2) / 20;
  c = new PVector(margin + r, margin + r);
}

boolean save = false;

void draw() {
  pg.beginDraw();
  if (frameCount == 1) {
    pg.background(0);
  }
  pg.noStroke();
  pg.blendMode(BLEND);
  pg.fill(0, 0, 0, 100);
  
  if (c.x > pg.width - r - margin) {
    pg.noFill();
    pg.noStroke();
    noLoop();
  }
  if (save) {
    save = false;
    pg.save("output" + int(random(1000000)) + ".png");
  }
  pg.circle(c.x, c.y, r);
  pg.blendMode(ADD);
  pg.stroke(300 + random(-50, 50), 70, 100, 15);
  pg.noFill();
  
  int perFrame = 30000;
  for (int i = 0; i < perFrame; i++) {
    pg.strokeWeight(random(2));
    PVector p = randomInCircle(c, r, _power, fuzz, 0, 2 * PI);
    pg.point(p.x, p.y);
  }
  c.y += r * 1.25;
  if (c.y > pg.height - r - margin) {
    c.y = r + margin;
    c.x += r * 1.25;
  }
  pg.endDraw();
  image(pg, 0, 0, width, height);
}

void mouseClicked() {
  save = true;
}

PVector randomInCircle(PVector c, float r, float power, float fuzz, float start, float end) {
  float f = pow(random(1), power);
  float r2 = f * (r + r * random(fuzz));
  return PVector.fromAngle(random(start, end)).mult(r2).add(c);
}
