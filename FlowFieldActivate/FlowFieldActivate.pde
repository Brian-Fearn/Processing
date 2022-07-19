PGraphics pg;

ArrayList<Point> points;
ArrayList<Mover> movers = new ArrayList<Mover>();
float radius = 300;
float sc = 0.01;
boolean randomPositions = true;

void setup() {
  
  size(900, 900, P2D);
  pg = createGraphics(1080, 1080, P2D);
  pg.smooth(8);
  pg.beginDraw();
  colorMode(HSB, 360, 100, 100, 100);
  pg.colorMode(HSB, 360, 100, 100, 100);
  pg.ellipseMode(RADIUS);
  pg.blendMode(ADD);
  pg.endDraw();
  setPositions(randomPositions);
  for (int i = 0; i < 5; i++) {
    movers.add(new Mover(new PVector(random(10, pg.width - 10), -pg.height / 10), new PVector(0, random(2, 5))));
  }
}

void setPositions(boolean randomize) {
  points = new ArrayList<Point>();
  int n = 100;
  float inc = 1.0 * pg.width / n;
  for (int yi = 0; yi < n; yi++) {
    float y = inc * yi + inc / 2;
    for (int xi = 0; xi < n; xi++) {
      float x = inc * xi + inc / 2;
      points.add(randomize ? new Point(new PVector(random(pg.width), random(pg.height))) : new Point(new PVector(x, y)));
    }
  }
}

void keyPressed() {
  if (key == CODED && keyCode == UP) {
    randomPositions = !randomPositions;
    setPositions(randomPositions);
  }
  if (keyCode == RIGHT) {
    movers.add(new Mover(new PVector(random(10, pg.width - 10), -pg.height / 10), new PVector(0, random(2, 5))));
  }
}

void draw() {
  pg.beginDraw();
  pg.background(0);
  pg.strokeWeight(2);
  //PVector m = new PVector(mouseX, mouseY);
  for (Mover m : movers) {
    m.update();
    m.show();
  }
  //PVector m = new PVector(mouseX, mouseY);
  for (Point p : points) {
    for (Mover m : movers) {
      p.distort(m.p);
    }
    p.revert();
    p.show();
  }
  pg.endDraw();
  image(pg, 0, 0, width, height);
  println(frameRate);
}

class Point {
  
  PVector init, p;
  float r;
  float revertRate;
  color initCol, col;
  
  Point(PVector init) {
    this.r = 3;
    this.init = init;
    this.p = init.copy();
    this.col = color(30, 0, 20);
    this.initCol = col;
    this.revertRate = random(0.01, 0.04);
  }
  
  void distort(PVector m) {
    //PVector diff = p.copy().sub(m);
    float dSq = m.copy().sub(p).magSq();
    if (dSq < radius * radius) {
      float fd = pow(1 - sqrt(dSq) / radius, 5);
      float noize = noise(p.x * sc, p.y * sc, frameCount * sc);
      //PVector add = PVector.fromAngle(diff.heading()).mult(fd * 15 * noize);
      PVector add = PVector.fromAngle(2 * TAU * noize).mult(fd * 15);
      color c = color(180 * noize + 180 * fd, 100, 100);
      col = lerpColor(col, c, fd);
      p.add(add);
    }
  }
  
  void revert() {
    p.lerp(init, revertRate);
    col = lerpColor(col, initCol, revertRate);
  }
  
  void show() {
    pg.stroke(col);
    pg.point(p.x, p.y);
  }
}

class Mover {
  
  PVector p, v;
  
  Mover(PVector p, PVector v) {
    this.p = p;
    this.v = v;
  }
  
  void update() {
    p.add(v);
    if (p.y > pg.height + pg.height / 10) {
      p.x = random(10, pg.width - 10);
      p.y = -pg.height / 10;
    }
  }
  
  void show() {
    pg.noStroke();
    pg.fill(0, 0, 100);
    pg.circle(p.x, p.y, 5);
  }  
  
}
