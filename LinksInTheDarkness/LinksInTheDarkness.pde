ArrayList<Circle> circles = new ArrayList<Circle>();
int n = 35;
int minR = 10;
int maxR = 60;
int connectionsPerCircle = 30;
color COPPER = color(255, 150, 75);
color ELECTRIC_PURPLE = color(125, 100, 225);
color strokeColor = COPPER;
float springFactor = 0.02;

void setup() {
  size(900, 900, P3D);
  smooth(8);
  blendMode(ADD);
  ellipseMode(RADIUS);
  noFill();
  for (int i = 0; i < n; i++) {
    boolean big = false; // random(n / 2) < 1;
    float r = big ? maxR * 2 : random(minR, maxR);
    circles.add(new Circle(new PVector(random(r, width - r), random(r, height - r)), r, big ? connectionsPerCircle * 2 : connectionsPerCircle, i));
  }
}

void draw() {
  background(0, 0, 10);
  strokeWeight(1);
  doCollisions();
  for (Circle c : circles) {
    c.update();
    for (Circle o : circles) {
      if (o != c) {
        c.connect(o);
      }
    }
  }
  println(frameCount / 60);
  println(frameRate);
}

void doCollisions() {
  for (int i = 0; i < circles.size() - 1; i++) {
    for (int j = i + 1; j < circles.size(); j++) {
      circles.get(i).collide(circles.get(j));
    }
  }
}

class Circle {
  
  PVector c, v;
  float r;
  int id;
  ArrayList<PVector> points;
  
  Circle(PVector c, float r, int nPoints, int id) {
    this.c = c;
    this.r = r;
    this.v = new PVector(random(1, 2) * (random(2) < 1 ? -1 : 1), 
      random(1, 2) * (random(2) < 1 ? -1 : 1));
    points = new ArrayList<PVector>();
    for (int i = 0; i < nPoints; i++) {
      points.add(PVector.fromAngle(i * 2 * PI / nPoints).mult(r).add(c));
    }
    this.id = id;
  }
  
  void update() {
    if (c.x - r < 0 || c.x + r > width) {
      v.x *= -1;
    }
    if (c.y - r < 0 || c.y + r > height) {
      v.y *= -1;
    }
    for (PVector p : points) {
      p.sub(c);
      p.rotate(PI / 360);
      p.add(c);
      p.add(v);
    }
    c.add(v);
  }
  
  void connect(Circle o) {
    for (PVector p : points) {
      PVector closest = findClosest(p, o.points);
      float maxD = (150 + 100.0 * mouseX / width);
      float d = PVector.sub(p, closest).mag();
      if (d < maxD) {
        float fd = max(pow(1 - d / maxD, 3), 0);
        strokeWeight(0.5 + 3 * fd);
        stroke(strokeColor, 255 * fd);
        line(p.x, p.y, closest.x, closest.y);
      }
    }
  }
  
  void collide(Circle o) {
    PVector diff = o.c.copy().sub(this.c);
    float minDist = this.r + o.r;
    if (diff.magSq() < (o.r + this.r) * (o.r + this.r)) {
      float angle = atan2(o.c.y - this.c.y, o.c.x - this.c.x);
      float targetX = this.c.x + cos(angle) * minDist;
      float targetY = this.c.y + sin(angle) * minDist;
      PVector velDiff = new PVector(
        (targetX - o.c.x) * springFactor,
        (targetY - o.c.y) * springFactor);
      this.v.sub(velDiff);
      o.v.add(velDiff);
    }
  }
  
} 

PVector findClosest(PVector p, ArrayList<PVector> o) {
  float dSq = Float.MAX_VALUE;
  PVector closest = null;
  for (PVector v : o) {
    float dSq2 = PVector.sub(p, v).magSq(); 
    if (dSq2 < dSq) {
      closest = v;
      dSq = dSq2;
    }
  }
  return closest;
}
