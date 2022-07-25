PGraphics pg;

ArrayList<Point> pointList = new ArrayList<Point>();
Traveler t;
int n = 20;
float margin;
boolean stop;
boolean drawBg = true;

void setup() {
  size(900, 900, P2D);
  pg = createGraphics(1080, 1080, P2D);
  pg.smooth(8);
  background(255);
  frameRate(20);
  margin = pg.width / 30;
  float inc = (pg.width - margin * 2) / n;
  for (int y = 0; y <= n; y++) {
    for (int x = 0; x <= n; x++) {
      Point p = new Point(x, y);
      p.pos = new PVector(margin + x * inc, margin + y * inc);
      pointList.add(p);
    }
  }
  setNeighbors();
  t = new Traveler();
}

void draw() {
  pg.beginDraw();
  if (frameCount < 3) {
    pg.background(0);
    pg.stroke(255);
    pg.strokeWeight(4);
    drawBg = false;
  } else {
    t.show();
    t.travel();
    
    if (stop) {
      //exit();
    }
  }
  image(pg, 0, 0, width, height);
  pg.endDraw();
}

void setNeighbors() {
  for (int i = 0; i < pointList.size(); i++) {
    Point p = pointList.get(i);
    for (int j = i + 1; j < pointList.size(); j++) {
      Point p2 = pointList.get(j);
      if ((p.x == p2.x && abs(p.y - p2.y) == 1) || (p.y == p2.y && abs(p.x - p2.x) == 1)) {
        p.neighbors.add(p2);
        p2.neighbors.add(p);
      }
    }
  }
}

ArrayList<Point> getFreePoints() {
  ArrayList<Point> result = new ArrayList<Point>();
  for (Point p : pointList) {
    if (p.free) {
      result.add(p);
    }
  }
  return result;
}

class Point {
  
  ArrayList<Point> neighbors = new ArrayList<Point>();
  Point next;
  boolean free;
  int x, y; // grid coordinates 
  PVector pos; // screen coordinates 
  
  Point(int x, int y) {
    this.x = x;
    this.y = y;
    this.free = true;
  }
  
  ArrayList<Point> getFreeNeighbors() {
    ArrayList<Point> result = new ArrayList<Point>();
    for (Point p : neighbors) {
      if (p.free) {
        result.add(p);
      }
    }
    return result;
  }
  
  String toString() {
    String s = "";
    s += String.format("(%d, %d) | ", x, y);
    for (Point p : neighbors) {
      s += String.format("(%d, %d) ", p.x, p.y);
    }
    return s;
  }
  
}

class Traveler {
  
  Point p;
  Point last;
  ArrayList<Point> history;
  
  Traveler() {
    reset();
    this.history = new ArrayList<Point>();
  }
  
  void travel() {
    p.free = false;
    history.add(p);
    last = p;
    ArrayList<Point> choices = p.getFreeNeighbors();
    if (choices.isEmpty()) {
      reset();
    } else {
      p = choices.get(int(random(choices.size())));
    }
  }
  
  void reset() {
    ArrayList<Point> choices = getFreePoints();
    if (!choices.isEmpty()) {
      p = choices.get(int(random(choices.size())));
      last = null;
    } else {
      stop = true;
    }
  }
  
  void show() {
    stroke(255);
    fill(255);
    if (last != null) {
      PVector v = PVector.lerp(last.pos, p.pos, 0.85);
      PVector v2 = PVector.lerp(last.pos, p.pos, 0.65);
      pg.line(last.pos.x, last.pos.y, v.x, v.y);
      
      PVector diff = p.pos.copy().sub(last.pos).normalize();
      PVector n = new PVector(-diff.y, diff.x);
      PVector p2 = v2.copy().add(n.copy().mult(5));
      PVector p3 = v2.copy().add(n.copy().mult(-5));
      pg.line(p2.x, p2.y, v.x, v.y);
      pg.line(p3.x, p3.y, v.x, v.y);
    } else {
      pg.circle(p.pos.x, p.pos.y, 15);
    }
  }
  
}
