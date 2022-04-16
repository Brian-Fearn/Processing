ArrayList<ArrayList<Point>> lines = new ArrayList<ArrayList<Point>>();
ArrayList<Point> points = new ArrayList<Point>();
ArrayList<Mover> movers = new ArrayList<Mover>();
int divs = 60;
int moverCount = 30;
int margin = 80;
color c1, c2;
PGraphics pg;

void setup() {
  size(900, 900, P3D);
  c1 = color(255, 225, 200);
  c2 = color(175, 25, 100);
  pg = createGraphics(1080, 1080, P3D);
  pg.smooth(8);
  pg.beginDraw();
  pg.ellipseMode(RADIUS);
  pg.endDraw();
  int inc = round(1.0 * pg.width / divs);
  for (int i = 1; i < divs; i++) {
    ArrayList<Point> line = new ArrayList<Point>();
    for (int j = 0; j <= pg.height; j += 10) {
      Point p = new Point(new PVector(i * inc, j));
      line.add(p);
      points.add(p);
    }
    lines.add(line);
  }
  for (int i = 0; i < moverCount; i++) {
    movers.add(new Mover(new PVector(random(pg.width), random(-pg.height, 0))));
  }
}

float offset = 0;

void draw() {
  pg.beginDraw();
  pg.background(0, 0, 0); //255, 225, 200);
  pg.noFill();
  for (Mover m : movers) {
    m.move();
    m.show();
  }
  offset += 0.01;
  pg.stroke(200, 200, 255);
  pg.strokeWeight(5);
  for (Point p : points) {
    for (Mover m : movers) {
      PVector diff = p.pos.copy().sub(m.pos);
      PVector n = diff.copy().normalize().mult(75.0 * m.repelForce * 1 / diff.mag());
      n.y = 0;
      p.pos.add(n);
    }
    p.update();
    pg.strokeWeight(p.weight);
    pg.point(p.pos.x, p.pos.y);
  }

  pg.endDraw();
  if (frameCount % 60 == 0) {
    println(frameCount / 60 + " --- " + frameRate);
  }
  image(pg, 0, 0, width, height);
}

class Point {
  
  PVector pos;
  PVector init;
  float weight;
  color cl;
  
  Point(PVector pos) {
    this.pos = pos;
    this.init = pos.copy();
    this.weight = 3 
      + 7 * 0.5 * (1 + cos(2 * 2 * PI * map(pos.x, 0, pg.width, 0, 1)));
      //+ 2 * sin(2 * PI * 7 * map(pos.y, 0, pg.height, 0, 1));
    this.cl = lerpColor(c1, c2, pos.y / pg.height);
  }
  
  void update() {
    pos = PVector.lerp(pos, init, 0.03);
    
  }  
  
}

class Mover {
  
  PVector pos;
  PVector vel;
  float r;
  float repelForce;
  float offset = random(2 * PI);
  
  Mover(PVector pos) {
    this.pos = pos;
    this.vel = new PVector(random(0.5, 1) * (random(2) < 1 ? -1 : 1), random(2.5, 4));
    this.r = 5;
    this.repelForce = random(1, 4);
  }
  
  void move() {
    pos.add(vel);
    checkBounds();
  }
  
  void checkBounds() {
    boolean out = pos.x + r < -margin
      || pos.x - r > pg.width + margin 
      || pos.y - r > pg.height + margin;
    if (out) {
      this.pos = new PVector(random(pg.width), random(-pg.height, -pg.height / 2));
      this.vel = new PVector(random(0.5, 1) * (random(2) < 1 ? -1 : 1), random(1.5, 2.5));
      this.r = 5;
      this.repelForce = random(1, 4);
    }
  }
  
  void show() {
    pg.noStroke();
    pg.fill(100, 150, 255);
    pg.circle(pos.x, pos.y, r * repelForce);
    float glowRadius = 10;
    for (int i = 1; i < glowRadius; i++) {
      pg.fill(100, 150, 255, 50 * (1 - 1.0 * i / glowRadius));
      pg.circle(pos.x, pos.y, r * repelForce + i * 2);
    }
  }
}
