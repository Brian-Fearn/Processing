PGraphics pg;

Shape sh, sh2;
ArrayList<Point> pointList = new ArrayList<Point>();
float maxDist;
boolean noisy = false;

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
  sh = new Shape(points, a);
  pointList.addAll(points);
  points = new ArrayList<Point>();
  for (int i = 0; i <= 1000; i++) {
    Point p = new Point(PVector.fromAngle(TAU * i / 1000).mult(150).add(b));
    points.add(p);
  }
  pointList.addAll(points);
  sh2 = new Shape(points, b);
}

void draw() {
  PVector m = new PVector(mouseX * 1.0 * pg.width / width, mouseY * 1.0 * pg.height / height);
  pg.beginDraw();
  pg.background(255);
  pg.noStroke();
  pg.fill(0);
  sh.repel(m);
  sh2.repel(m);
  for (Point p : pointList) {
    if (!mousePressed) {    
      p.regress();
    } else {
      //p.repel(m);
    }
  }
  sh.show();
  sh2.show();
  pg.fill(255, 0, 0);
  pg.circle(m.x, m.y, 10);
  pg.endDraw();
  image(pg, 0, 0, width, height);
  println(frameCount / 60);
}

void mouseClicked() {
  noisy = !noisy;
}

class Point {
  
  PVector init, init2, p;
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
    if (noisy) {
      n = PVector.fromAngle(TAU * 2 * noise(init.x * 0.01, init.y * 0.01)).mult(f * 5);
    } else {
      n.mult(f * 5);
    }
    p.add(n);
  }
  
  void regress() {
    p.lerp(init, 0.055);
  }
  
}

class Shape {
  
  ArrayList<Point> points;
  PVector c;
  
  Shape(ArrayList<Point> points, PVector c) {
    this.points = points;
    this.c = c;
  }
  
  void repel(PVector m) {
    PVector diff = c.copy().sub(m);
    PVector n = diff.copy().normalize();
    float f = pow(1 - diff.mag() / maxDist, 5);
    PVector norm = n.copy().mult(f * 5);
    c.add(norm);
    for (Point p : points) {
      p.init.add(norm);
      p.repel(m);
    }
  }
  
  void show() {
    pg.beginShape();
    for (Point p : points) {
      pg.vertex(p.p.x, p.p.y);
    }
    pg.endShape(CLOSE);
  }
  
}
