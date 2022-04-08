int n = 300;
ArrayList<Mover> movers = new ArrayList<Mover>();
PGraphics pg;

float offset = 0.0;

void setup() {
  size(900, 900, P3D);
  pg = createGraphics(1080, 1080, P3D);
  pg.smooth(8);
  colorMode(HSB, 360, 100, 100, 100);
  pg.beginDraw();
  pg.colorMode(HSB, 360, 100, 100, 100);
  pg.noStroke();
  for (int i = 0; i < n; i++) {
    movers.add(new Mover(random(pg.width), random(pg.height)));
  }
}

void draw() {
  pg.beginDraw();
  pg.background(0);
  for (Mover m : movers) {
    m.move();
    m.checkBounds();
    m.show();
  }
  pg.endDraw();
  
  image(pg, 0, 0, width, height);
  println(frameCount + " ::::: " +frameRate);
}

class Mover {
  
  PVector pos;
  PVector v;
  float r;
  float baseHue;
  float falloffOscFreq;
  
  Mover(float x, float y) {
    this.pos = new PVector(x, y);
    this.v = new PVector((random(2) < 1 ? -1 : 1) * random(0.5, 2), random(0.5, 2));
    this.r = random(10, 25);
    this.baseHue = random(360);
    this.falloffOscFreq = random(1, 3);
  }
  
  void move() {
    this.pos.add(v);
  }
  
  void show() {
    int glowRadius = 45;
    float glowFalloff = 2 + 4 * abs(sin(radians(0.3 * frameCount * falloffOscFreq)));
    pg.fill(baseHue, 0, 100, 100);
    pg.circle(pos.x, pos.y, r);
    for (int i = 0; i < glowRadius; i += 3) {
      float rFactor = pow((1.0 * glowRadius - i) / glowRadius, glowFalloff);
      pg.fill(baseHue, 0, 100, 20 * rFactor);
      pg.circle(pos.x, pos.y, r + i);
    } 
  }
  
  void checkBounds() {
    if (pos.x + r < 0) {
      pos.x = pg.width + r;
    }
    if (pos.x - r > pg.width) {
      pos.x = -r;
    }
    if (pos.y + r < 0) {
      pos.y = pg.height + r;
    }
    if (pos.y - r > pg.height) {
      pos.y = -r;
    }
  }
  
}
