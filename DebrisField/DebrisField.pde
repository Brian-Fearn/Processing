import processing.svg.*;
import java.util.Date;

PGraphics pg;
boolean svg = false;
int minRadius = 1;
int maxRadius = 20;
float padding = -1;
ArrayList<Circle> circles = new ArrayList<Circle>();
boolean drawBg = true;
boolean save = false;

void setup() {
  size(900, 900, P2D);
  randomSeed(123L);
  noiseSeed(123L);
  pg = createGraphics(900, 900, P2D);
  smooth(8);
  pg.smooth(8);
  if (svg) {
    pg = createGraphics(900, 900, SVG, getClass().getName() + new Date().getTime() + ".svg");
  }
}

void draw() {
  if (svg) {
    drawSVG();
  } else {
    drawRaster();
  }
}

void drawRaster() {
  pg.beginDraw();
  if (frameCount < 3) {
    pg.ellipseMode(RADIUS);
    pg.fill(255, 225, 200);
    pg.noStroke();
    //pg.stroke(0);
    pg.background(0);
  } else {
  int perFrame = 100;
    for (int i = 0; i < perFrame; i++) {
      Circle c = placeCircle();
      if (c != null) {
        circles.add(c);
        c.show();
      }
    }
  }
  println(circles.size());
  pg.endDraw();
  image(pg, 0, 0, width, height);
}

void drawSVG() {
  pg.beginDraw();
  pg.ellipseMode(RADIUS);
  pg.fill(255, 225, 200);
  pg.noStroke();
  //pg.stroke(0);
  pg.background(0);
  while (circles.size() < 35000) {
    Circle c = placeCircle();
    if (c != null) {
      circles.add(c);
      println(circles.size());
    }
  }
  for (Circle c : circles) {
    c.show();
  }
  if (svg) {
    pg.dispose();
  }
  pg.endDraw();
  //image(pg, 0, 0, width, height);
  println("Done | " + circles.size());
  noLoop();
}

void mouseClicked() {
  save = true;
}

Circle placeCircle() {
  int tries = 0;
  while (tries < 1000) {
    PVector p = new PVector(random(minRadius, pg.width - minRadius), random(minRadius, pg.height - minRadius));
    Circle c = new Circle(p, minRadius);
    if (c.overlapAny(circles, padding)) {
      tries++;
      continue;
    } else {
      float y = p.y + pg.height / 13 * sin(p.x / pg.width * TAU * 2);
      float localMax = minRadius + (maxRadius - minRadius) * pow(abs(y - pg.height / 2) / (pg.height / 2), 1);
      while(c.r <= localMax) {
        c.r += 0.1;
        if (c.overlapAny(circles, padding) || c.outOfBounds(padding)) {
          c.r -= 0.1;
          break;
        }
      }
      return c;
    }
  }
  return null;
}

class Circle {
  
  PVector p;
  float r;
  Circle neighbor;
  
  Circle(PVector p, float r) {
    this.p = p;
    this.r = r;
  }
  
  boolean overlap(Circle o, float pad) {
    return this.p.copy().sub(o.p).magSq() <= (this.r + o.r + pad) * (this.r + o.r + pad);
  }
  
  boolean overlapAny(ArrayList<Circle> others, float pad) {
    for (Circle c : others) {
      if (this.overlap(c, pad)) {
        this.neighbor = c;
        return true;
      }
    }
    return false;
  }
  
  boolean outOfBounds(float padding) {
    return p.x - r - padding <= 0 || p.x + r + padding >= pg.width || p.y - r - padding <= 0 || p.y + r + padding >= pg.height; 
  }
  
  void show() {
    blob(p.x, p.y, r);
    //pg.circle(p.x, p.y, r);
  }
  
}

void blob(float x, float y, float r) {
  int n = ceil(r * TAU);
  PVector c = new PVector(x, y);
  color colA = color(200, 225, 255);
  color colB = color(0, 0, 255);
  pg.fill(lerpColor(colB, colA, r / maxRadius));
  pg.beginShape();
  for (int i = 0; i <= n; i++) {
    float th = i * TAU / n;
    float px = cos(th) * r + c.x;
    float py = sin(th) * r + c.y;
    float noize = noise(px * 0.05, py * 0.05, frameCount);
    PVector p = PVector.fromAngle(th).mult(r - r * noize).add(c);
    pg.vertex(p.x, p.y);
  }
  pg.endShape();
}
