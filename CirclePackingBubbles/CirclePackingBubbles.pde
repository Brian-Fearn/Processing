// "running" cirle packing for a random starting point, a minimum radius, and a maximum radius
// each EdgeSet has an ArrayList of Circle(s) that must stay within the bounds of the EdgeSet
// could be made more efficient with a quadtree but runs okay
PGraphics pg;
float minR = 4;
float maxR = 200;
int margin = 20;
float spacing = 1; // extra pixels between circles
float alpha = 25;
int maxTries = 2000; // max number of attempts to generate random point not already circumscribed by a circle
int countW = 1; // > 1 if you want a grid pattern
int countH = 1; // > 1 if you want a grid pattern
int circlesPerRound = 5; // number of circles to place and inflate at the same time
ArrayList<EdgeSet> edgeSets;
float maxDSquared;

void setup() {
  size(900, 900, P2D);
  colorMode(HSB);
  pg = createGraphics(2160, 2160, P2D);
  pg.beginDraw();
  pg.background(0);
  pg.stroke(0, 20);
  pg.ellipseMode(RADIUS);
  pg.strokeWeight(2);
  pg.colorMode(HSB);
  pg.background(0);
  pg.fill(0, 0, 255);
  pg.textSize(2000);
  pg.background(0);
  pg.endDraw();
  maxDSquared = distSquared(new PVector(0, 0), new PVector(pg.width, pg.height)); 
  edgeSets = new ArrayList<EdgeSet>();
  float incW = 1.0 * pg.width / countW;
  float incH = 1.0 * pg.height / countH;
  for (int i = 0; i < countW; i++) {
    float left = i * incW;
    float right = (i + 1) * incW;
    for (int j = 0; j < countH; j++) {
      float top = j * incH;
      float bottom = (j + 1) * incH;
      EdgeSet es = new EdgeSet(left, right, top, bottom, circlesPerRound);
      es.baseColor = random(300);
      edgeSets.add(es);
    }
  }
}

void draw() {
  image(pg, 0, 0, 900, 900);
  boolean go = false;
  pg.beginDraw();
  for (EdgeSet es : edgeSets) {
    if (es.live) {
      es.update();
    }
    go = go || es.live;
  }
  pg.endDraw();
  
  if (!go) {
    pg.save("output-1234.png");
    noLoop();
  }
  //println(frameCount);
}

void mouseClicked() {
  saveFrame("output-" + int(random(1000000000000.0)) + ".png");
}

class Circle {
  
  PVector center; 
  float r;
  boolean live = true;
  float maxRadius;
  
  Circle(float x, float y) {
    this.center = new PVector(x, y);
    this.r = minR;
    this.live = true;
    this.maxRadius = maxR; //minR + maxR * (1 - dSquared / maxDSquared);
  }
  
  boolean intersects(ArrayList<Circle> circs) {
    for (Circle c : circs) {
      if (c != this && c.intersects(this)) {
        return true;
      }
    }
    return false;
  }
  
  boolean intersects(Circle other) {
    return distSquared(this.center, other.center) < (this.r + other.r + spacing) * (this.r + other.r + spacing); 
  }
  
  boolean hitsEdges(float left, float right, float top, float bottom) {
    return this.center.x - r - spacing < left || this.center.x + r + spacing > right  
      || this.center.y - r - spacing < top || this.center.y + r + spacing > bottom;
  }
  
  boolean boundsReached(EdgeSet es) {
    if (hitsEdges(es.left, es.right, es.top, es.bottom)) {
      return true;
    }
    return r > maxRadius;
  }
  
  Circle copy() {
    Circle c = new Circle(center.x, center.y);
    c.r = this.r;
    return c;
  }
  
  void show(float baseColor) {
    color fColor = color(100 + r / maxR * 100, 255, 255, alpha); 
    pg.fill(fColor);
    pg.noStroke();
    pg.ellipse(center.x, center.y, r, r);
  }
  
}

class EdgeSet {
  
  float left, right, top, bottom;
  ArrayList<Circle> circles;
  ArrayList<Circle> candidateList;
  boolean live = true;
  float baseColor;
  int candidateCount;
  
  EdgeSet(float left, float right, float top, float bottom, int candidateCount) {
    this.left = left;
    this.right = right;
    this.top = top;
    this.bottom = bottom;
    this.circles = new ArrayList<Circle>();
    this.candidateCount = candidateCount;
    newCandidates(candidateCount);
  }
  
  void newCandidates(int candidateCount) {
    this.candidateList = new ArrayList<Circle>();
    for (int i = 0; i < candidateCount; i++) {
      Circle c = newCandidate(this);
      if (c != null) {
        candidateList.add(c);
      }
    }
  }
  
  EdgeSet(float left, float right, float top, float bottom) {
    this(left, right, top, bottom, 0);
  }
  
  Circle newCandidate(EdgeSet es) {
    Circle c = new Circle(random(es.left + minR, es.right-minR), random(es.top + minR, es.bottom-minR));
    for (int i = 0; i < maxTries; i++) {
      if (c.boundsReached(es) || c.intersects(circles) || c.intersects(candidateList)) {
        c = new Circle(random(es.left + minR, es.right-minR), random(es.top + minR, es.bottom-minR));
      } else {
        return c;
      }
    }
    return null;
  }
  
  void update() {
    ArrayList<Circle> toRemove = new ArrayList<Circle>();
    for (Circle candidate : candidateList) {
      if (candidate.boundsReached(this) || candidate.intersects(circles) || candidate.intersects(candidateList)) {
        candidate.r -= 1.0;
        circles.add(candidate);
        toRemove.add(candidate);
      } else {
        candidate.r++;
      }
      candidate.show(baseColor);
    }
    for (Circle c : toRemove) {
      candidateList.remove(c);
      Circle newCircle = newCandidate(this);
      if (newCircle != null) {
        candidateList.add(newCircle);
      }
    }
    if (candidateList.isEmpty()) {
      println("end");
      noLoop();
    }
  }
}

float distSquared(PVector a, PVector b) {
  return (a.x-b.x)*(a.x-b.x) + (a.y-b.y)*(a.y-b.y);
}
