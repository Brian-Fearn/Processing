import java.util.Date;

ArrayList<Mover> movers = new ArrayList<Mover>();
PGraphics pg;
color c;
boolean save = false;

void setup() {
  size(900, 900, P2D);
  pg = createGraphics(1080, 1080, P2D);
  pg.smooth(8);
  pg.beginDraw();
  pg.noStroke();
  pg.colorMode(HSB, 360, 100, 100, 100);
  pg.background(225, 100, 10);
  pg.blendMode(ADD);
  pg.ellipseMode(RADIUS);
  for (int i = 0; i < 40; i++) {
    PVector p = new PVector(random(pg.width), random(pg.height));
    movers.add(new Mover(p.copy()));
  }
}

void draw() {
  pg.beginDraw();
  if (frameCount < 3) {
    pg.background(225, 100, 10);
  }
  for (Mover m : movers) {
    m.update();
    m.show();
  }
  if (save) {
    pg.save(getClass().getName() + new Date().getTime() + ".png");
    save = false;
  }
  pg.endDraw();
  image(pg, 0, 0, width, height);
}

void mouseClicked() {
  save = true;
}

class Mover {
  
  PVector pos;
  float offset;
  int steps = 0;
  float speed;
  
  Mover(PVector pos) {
    this.pos = pos.copy();
    this.offset = random(TAU);
    this.speed = random(0.05, 0.6);
  }
  
  void update() {
    if (steps >= 200) {
      steps = 0;
      pos = new PVector(random(pg.width), random(pg.height));
    }
    float th = offset + sin(radians(frameCount * speed)) * TAU;
    pos.add(PVector.fromAngle(th).mult(1));
    steps++;
  }
  
  void show() {
    float th = offset + sin(radians(frameCount * 0.2)) * TAU;
    float ft = 0.5 * (1 + sin(radians(frameCount * 3)));
    pg.fill(160, 60 + 30 * sin(th), 60, 4);
    pg.circle(pos.x, pos.y, 2 + 30 * pow(float(steps) / 200, 2));
  }
  
}
