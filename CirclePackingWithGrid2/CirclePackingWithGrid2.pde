import processing.svg.*;
import java.util.Date;

PGraphics pg;
boolean svg = false;
int minRadius = 2;
int maxRadius = 40;
float padding = 1;
ArrayList<Circle> circles = new ArrayList<Circle>();
Grid<Circle> grid;
boolean drawBg = true;
boolean save = false;

void setup() {
  size(900, 900, P2D);
  randomSeed(123L);
  noiseSeed(123L);
  colorMode(HSB, 360, 100, 100, 100);
  pg = createGraphics(4320, 4320, P2D);
  grid = new Grid<Circle>(maxRadius * 2, pg.width, pg.height);
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
    pg.colorMode(HSB, 360, 100, 100, 100);
  } else {
    int perFrame = 1000;
    for (int i = 0; i < perFrame; i++) {
      Circle c = placeCircle();
      if (c != null) {
        circles.add(c);
        c.show();
      }
    }
  }
  //println(circles.size());
  if (save) {
    save = false;
    pg.save(getClass().getName() + new Date().getTime() + ".png");
    println(circles.size());
    exit();
  }
  pg.endDraw();
  println(frameRate);
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
  int regions = 8;
  float regionSize = 0.95 * pg.width / 2 / regions;
  PVector canvasCenter = new PVector(pg.width / 2, pg.height / 2);
  while (tries < 1000) {
    float cr = sqrt(random(1)) * pg.width / 2 * 0.95;
    PVector p = new PVector(random(minRadius, pg.width - minRadius), random(minRadius, pg.height - minRadius));
    Circle c = new Circle(p, minRadius);
    ArrayList<Circle> close = grid.getCell(p.x, p.y).getOccupantsAndOccupantsOfNeighbors();
    if (c.overlapAny(close, padding)) {
      tries++;
      continue;
    } else {
      
      PVector diff = p.copy().sub(new PVector(pg.width / 2, pg.height / 2));
      float th = diff.heading();
      color col = color(abs(th / PI) * 60, 80, 100);
      c.col = col;
      float fdist = diff.mag() / dist(pg.width / 2, pg.height / 2, 0, 0);
      float localMax = minRadius + (maxRadius - minRadius) * pow(0.5 * (1 + sin(noise(p.x * 0.003, p.y * 0.003) * TAU * 2)), 4); // minRadius + (maxRadius - minRadius) * pow(0.5 * (1 + sin(th * 5 + fdist * TAU * (0.1 + pow(fdist, 4) * 10))), 2); 
      while(c.r <= localMax) {
        c.r += 0.1;
        if (c.overlapAny(close, padding) || c.outOfBounds(padding)) {
          c.r -= 0.1;
          break;
        }
      }
      grid.add(c, c.p.x, c.p.y);
      c.col = color(40 - 40 * c.r / localMax, 85, 100);
      return c;
    }
  }
  return null;
}

class Circle {
  
  PVector p;
  float r;
  Circle neighbor;
  color col;
  
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
  
  boolean outOfBounds(PVector c, float minR, float maxR) {
    float mag = p.copy().sub(c).mag();
    return mag - r < minR || mag + r > maxR;
  }
  
  boolean outOfBounds(float padding) {
    return p.x - r - padding <= 0 || p.x + r + padding >= pg.width || p.y - r - padding <= 0 || p.y + r + padding >= pg.height; 
  }
  
  void show() {
    //blob(p.x, p.y, r);
    //color colA = color(200, 225, 255);
    //color colB = color(0, 0, 255);
    //pg.fill(lerpColor(colB, colA, r / maxRadius));
    pg.fill(col);
    pg.noStroke();
    pg.circle(p.x, p.y, r);
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
