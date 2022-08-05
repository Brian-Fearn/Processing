PGraphics pg;

Shape sh, sh2;
ArrayList<Point> pointList = new ArrayList<Point>();
float maxDist;
boolean randomizedRegression = false;

void setup() {
  size(900, 900, P2D);
  pg = createGraphics(1080, 1080, P2D);
  maxDist = dist(pg.width, pg.height, 0, 0);
  pg.smooth(8);
  pg.beginDraw();
  pg.ellipseMode(RADIUS);
  pg.endDraw();
  PVector a = new PVector(300, 300);
  PVector b = new PVector(650, 650);
  ArrayList<Point> points = new ArrayList<Point>();
  for (int i = 0; i <= 500; i++) {
    Point p = new Point(PVector.fromAngle(TAU * i / 500).mult(100).add(a));
    points.add(p);
  }
  sh = new Shape(points);
  pointList.addAll(points);
  points = new ArrayList<Point>();
  for (int i = 0; i <= 1000; i++) {
    Point p = new Point(PVector.fromAngle(TAU * i / 1000).mult(150).add(b));
    points.add(p);
  }
  pointList.addAll(points);
  sh2 = new Shape(points);
}

void draw() {
  PVector m = new PVector(mouseX * 1.0 * pg.width / width, mouseY * 1.0 * pg.height / height);
  pg.beginDraw();
  pg.background(255);
  pg.noStroke();
  pg.fill(255, 0, 0);
  pg.circle(m.x, m.y, 10);
  pg.fill(0);
  for (Point p : pointList) {
    p.repel(m);
    p.regress();
  }
  sh.show();
  sh2.show();
  pg.endDraw();
  image(pg, 0, 0, width, height);
  println(frameCount / 60);
}

void mouseClicked() {
  randomizedRegression = !randomizedRegression;
}

class Point {
  
  PVector init, p;
  float lerpRate;
  
  Point(PVector init) {
    this.init = init;
    this.p = init.copy();
    this.lerpRate = random(0.02, 0.03);
  }
  
  void repel(PVector m) {
    PVector diff = p.copy().sub(m);
    PVector n = diff.copy().normalize();
    float f = pow(1 - diff.mag() / maxDist, 5);
    p.add(n.mult(f * 4));
  }
  
  void regress() {
    float rate = randomizedRegression ? lerpRate : 0.015;
    p.lerp(init, rate);
  }
  
}

class Shape {
  
  ArrayList<Point> points;
  
  Shape(ArrayList<Point> points) {
    this.points = points;
  }
  
  void show() {
    pg.beginShape();
    for (Point p : points) {
      pg.vertex(p.p.x, p.p.y);
    }
    pg.endShape(CLOSE);
  }
  
}
