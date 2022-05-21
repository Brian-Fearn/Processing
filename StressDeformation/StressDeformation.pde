ArrayList<Point> points = new ArrayList<Point>();
int dpn = 0;
int n = 80;
float velMultiplier = 1.005;
int margin = 0;
float inc;
ArrayList<ArrayList<Point>> grid = new ArrayList<ArrayList<Point>>();
float moverBaseSpeed = 10;
ArrayList<Mover> movers = new ArrayList<Mover>();
int nMovers = 3;
float distortionMagFudge = 0.6;
float distortionMagDivider = 200.0;
float distanceFactorMultiplier = 0.3;
boolean constantReturnRate = true;
float minReturnRate = 0.024;
float maxReturnRate = 0.045;
float moverLimitAdd = 15;
int blendMode = ADD; // SUBTRACT
boolean enlargeOnDeform = true;
boolean circleDraw = true;
PGraphics pg;

void setup() {
  size(900, 900, P2D);
  pg = createGraphics(1080, 1080, P2D);
  colorMode(HSB, 360, 100, 100, 100);
  
  pg.smooth(8);
  pg.beginDraw();
  pg.colorMode(HSB, 360, 100, 100, 100);
  pg.blendMode(blendMode);
  pg.endDraw();
  inc = (pg.width - margin * 2.0) / n;
  for (int i = -10; i <= n + 10; i++) {
    ArrayList<Point> list = new ArrayList<Point>();
    float y = margin + i * inc;
    for (int j = -10; j <= n + 10; j++) {
      float x = margin + j * inc;
      Point p = new Point(x, y);
      list.add(p);
      points.add(p);
    }
    grid.add(list);
  }
  
  for (int i = 0; i < nMovers; i++) {
    PVector mPos = PVector.random2D().mult(pg.width * 2).add(new PVector(pg.width / 2, pg.height / 2));
    PVector mDest = new PVector(random(pg.width), random(pg.height));
    PVector mVel = mDest.copy().sub(mPos).normalize().mult(moverBaseSpeed);
    Mover mover = new Mover(mPos, mVel);
    movers.add(mover);
  }
}

boolean onScreen(PVector p) {
  return p.x >= margin && p.x <= pg.width - margin && p.y >= margin && p.y <= pg.height - margin;
}

void mouseClicked() {
  if (mouseButton == LEFT) {
    constantReturnRate = !constantReturnRate;
  }
  if (mouseButton == RIGHT) {
    enlargeOnDeform = !enlargeOnDeform;
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      circleDraw = true;
    }
    if (keyCode == DOWN) {
      circleDraw = false;
    }
    if (keyCode == LEFT) {
      blendMode = SUBTRACT;
      pg.blendMode(blendMode);
    }
    if (keyCode == RIGHT) {
      blendMode = ADD;
      pg.blendMode(blendMode);
    }
  }
}

void draw() {
  for (Mover mover : movers) {
    mover.update();
  }
  deform(points);
  
  pg.beginDraw();
  color bgColor = blendMode == ADD ? color(225, 90, 20) : color(0, 0, 100);
  pg.background(bgColor);
  pg.strokeWeight(1.5);
  if (circleDraw) {
    pg.noStroke();
  }
  
  for (Point p : points) {
    p.update();
  }

  for (int j = 0; j < grid.size() - 1; j++) {
    ArrayList<Point> row = grid.get(j);
    for (int i = 0; i < row.size() - 1; i++) {
      Point pt = row.get(i);
      Point pt2 = row.get(i + 1);
      PVector p = row.get(i).pos;
      PVector p2 = row.get(i + 1).pos;
      PVector p3 = grid.get(j + 1).get(i).pos;
      float bright = (pt.distortionMag + pt2.distortionMag) / 2;
      color fillColor = color(pt.hue, 90 - 50 * bright, 40 + 60 * bright, bright * 100);
      if (onScreen(p) || onScreen(p2) || onScreen(p3)) {
        if (circleDraw) {
          pg.fill(fillColor);
          float baseR = enlargeOnDeform ? 10 : 15;
          float rMult = enlargeOnDeform ? bright : 1 - bright; 
          float r = blendMode == ADD ? 1 + rMult * baseR : 1 + rMult * baseR;
          pg.circle(p.x, p.y, r);
        } else {
          pg.stroke(fillColor);
          pg.line(p.x, p.y, p2.x, p2.y);
          pg.stroke(fillColor);
          pg.line(p.x, p.y, p3.x, p3.y);
        }
      }
    }
  }
  pg.endDraw();
  image(pg, 0, 0, width, height);
  //println(frameRate);
  if (frameCount % 60 == 0) {
    println(frameCount / 60);
  }
}

void deform(ArrayList<Point> set) {
  for (Mover mover : movers) {
    Point center = new Point(mover.pos.x, mover.pos.y); 
    float maxDiagonal = getMaxDist(center, set); 
    for (Point pt : set) {
      PVector p = pt.pos;
      PVector c = center.pos;
      float d = dist(p.x, p.y, c.x, c.y);
      float dFactor = 1 - distanceFactorMultiplier * pow(1 - d / maxDiagonal, 10);
      PVector temp = p.copy();
      temp.sub(c);
      temp.mult(dFactor);
      temp.add(c);
      p.x = temp.x;
      p.y = temp.y;
    }
  }
}

float getMaxDist(Point p, ArrayList<Point> set) {
  if (set.isEmpty()) {
    return 0;
  }
  float maxDistSq = Float.MIN_VALUE;
  for (Point pt : set) {
    PVector v = pt.pos;
    float dSq = v.copy().sub(p.pos).magSq();
    if (dSq > maxDistSq) {
      maxDistSq = dSq;
    }
  }
  return sqrt(maxDistSq);
}

class Point {
  
  long id;
  PVector pos, init;
  float distortionMag;
  float hue;
  float returnRate;
  
  Point(float x, float y) {
    this.init = new PVector(x, y);
    this.pos = init.copy();
    this.returnRate = random(minReturnRate, maxReturnRate);
  }
  
  void update() {
    float lerpRate = constantReturnRate ? minReturnRate : this.returnRate;
    pos.lerp(init, lerpRate);
    PVector diff = pos.copy().sub(init);
    distortionMag = min(1.0, diff.mag() / distortionMagDivider);
    distortionMag = pow(distortionMag, distortionMagFudge);
    hue = 360.0 * abs(diff.heading() / PI);
    if (mousePressed) {
      pos.x += 0.5 * sin(radians(init.y + 2 * frameCount));
      pos.y += 0.5 * sin(PI / 3 + radians(init.x + 2 * frameCount));
    }
  }
  
  Point copy() {
    Point p = new Point(pos.x, pos.y);
    p.id = (long) random(Long.MIN_VALUE, Long.MAX_VALUE);
    return p;
  }
  
}

class Mover {
  
  PVector pos, vel;
  float baseSpeed;
  
  Mover(PVector pos, PVector vel) {
    this.pos = pos;
    this.vel = vel;
    this.baseSpeed = random(10, 15);
  }
  
  void update() {
    pos.add(vel);
    PVector origin = new PVector(pg.width / 2, pg.height / 2);
    PVector diff = PVector.sub(pos, origin);
    vel.mult(velMultiplier).limit(baseSpeed + moverLimitAdd);
    if (diff.magSq() > pg.width * 2 * pg.width * 2) {
      PVector dest = new PVector(random(pg.width), random(pg.height));
      PVector dir = dest.copy().sub(pos).normalize();
      vel = dir.mult(baseSpeed);
    }
  }
  
}
