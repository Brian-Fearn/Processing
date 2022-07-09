import java.util.Date;

PGraphics pg;
Grid<Polygon> grid;
int resWidth, resHeight;
int MIN_NUMBER_OF_SIDES = 3;
int MAX_NUMBER_OF_SIDES = 3;
ArrayList<Polygon> polys = new ArrayList<Polygon>();
int MAX_ATTEMPTS = 10000;
float MIN_CIRCUMRADIUS = 5;
float MAX_CIRCUMRADIUS = 50;
int PADDING = 2;
int margin = 5;

void setup() {
  size(900, 900, P2D);
  colorMode(HSB, 360, 100, 100);
  randomSeed(10L);
  pg = createGraphics(1080, 1080, P2D);
  pg.smooth(8);
  resWidth = pg.width;
  resHeight = pg.height;
  pg.beginDraw();
  pg.colorMode(HSB, 360, 100, 100);
  grid = new Grid<Polygon>(int(pg.width / (MAX_CIRCUMRADIUS * 1.5)), int(pg.height / (MAX_CIRCUMRADIUS * 1.5)), pg.width, pg.height);
  pg.background(0);
  pg.endDraw();
}

int count = 0;

void draw() {
  pg.beginDraw();
  if (frameCount == 1) {
    pg.background(0, 0, 100);
    
  }
  pg.fill(0, 0, 0);
  int perFrame = 25;
  for (int i = 0; i < perFrame; i++) {
    Polygon p = placeNewPolygon();
    if (p == null) {
      println("done");
      for (Polygon show : polys) {
        if (show.isNew) {
          show.show();
          show.isNew = false;
        }
      }
    } else {
      polys.add(p);
      count++;
      grid.add(p, p.centroid.x, p.centroid.y);
      for (Polygon show : polys) {
        if (show.isNew) {
          show.show();
          show.isNew = false;
        }
      }
    }
  }
  if (count > 7000) {
    pg.save(getClass().getName() + new Date().getTime() + ".png");
    noLoop();
  }
  pg.endDraw();
  image(pg, 0, 0, width, height);
  println(count);
}

Polygon placeNewPolygon() {
  int attempts = 0;
  float radius = MIN_CIRCUMRADIUS;
  float maxR = radius;
  Polygon poly = null;
  //float offset = random(2 * PI);
  while (attempts < MAX_ATTEMPTS) {  
    PVector pos = new PVector(random(margin + MIN_CIRCUMRADIUS, resWidth - margin - MIN_CIRCUMRADIUS), 
      random(margin + MIN_CIRCUMRADIUS, resHeight - margin - MIN_CIRCUMRADIUS));
    float offset = TAU * pos.x / pg.width;
    maxR = MIN_CIRCUMRADIUS + (MAX_CIRCUMRADIUS - MIN_CIRCUMRADIUS) * (1 - abs(pos.x - pg.width / 2) / (pg.width / 2)); // * pow(dFactor, 3);
    ArrayList<PVector> points = getPolyPoints(pos.x, pos.y, radius, offset);
    poly = new Polygon(points, radius);
    ArrayList<Polygon> conflicts = grid.getCell(poly.centroid.x, poly.centroid.y).getOccupantsAndOccupantsOfNeighbors();
    if (overlapAny(poly, conflicts)) {
      attempts++;
      continue;
    } else {
      while (radius <= maxR) {
        radius++;
        points = getPolyPoints(pos.x, pos.y, radius, offset);
        poly = new Polygon(points, radius);
        if (overlapAny(poly, conflicts) || outOfBounds(poly)) {
          radius--;
          points = getPolyPoints(pos.x, pos.y, radius, offset);
          poly = new Polygon(points, radius);
          return poly;
        }
      }
      return poly;
    }
  }
  return null;
}

ArrayList<PVector> getPolyPoints(float x, float y, float radius, float offset) {
  ArrayList<PVector> polyPoints = new ArrayList<PVector>();
  PVector a = new PVector(x + radius * cos(offset), y + radius * sin(offset));
  PVector b = new PVector(x + radius * cos(offset + PI - PI / 6), y + radius * sin(offset + PI - PI / 6));
  PVector c = new PVector(x + radius * cos(offset + PI + PI / 6), y + radius * sin(offset + PI + PI / 6));
  polyPoints.add(a);
  polyPoints.add(b);
  polyPoints.add(c);
  return polyPoints;
}

class Polygon {
  
  ArrayList<PVector> points;
  PVector centroid;
  float r;
  float currentR;
  color fillColor;
  boolean isNew;
  
  Polygon(ArrayList<PVector> list, float r) {
    this.points = list;
    float xTotal = 0.0;
    float yTotal = 0.0;
    for (PVector p : points) {
      xTotal += p.x;
      yTotal += p.y;
    }
    this.centroid = new PVector(xTotal / list.size(), yTotal / list.size());
    this.fillColor = color(random(360), 100, 100);
    this.isNew = true;
    this.r = r;
  }
  
  // ray-casting test for containment: https://en.wikipedia.org/wiki/Point_in_polygon#Ray_casting_algorithm
  boolean contains(PVector p) {
    PVector rayEnd = new PVector(width * 10, height * 10);
    int intersections = 0;
    for (int i = 0; i < points.size(); i++) {
      PVector a = points.get(i);
      PVector b = points.get((i + 1) % points.size());
      if (intersect(a, b, p, rayEnd)) {
        intersections++;
      }
    }
    return intersections % 2 == 1;
  }
  
  boolean containsAny(ArrayList<PVector> pList) {
    for (PVector v : pList) {
      if (this.contains(v)) {
        return true;
      }
    }
    return false;
  }
  
  void show() {
    pg.beginShape();
    for (PVector p : points) {
      pg.vertex(p.x, p.y);
    }
    pg.endShape(CLOSE);
  }
  
  void show(color fillColor) {
    fill(fillColor);
    show();
  }
  
}

ArrayList<PVector> scalePoints(ArrayList<PVector> points, PVector center, float scaleFactor) {
  ArrayList<PVector> results = new ArrayList<PVector>();
  for (PVector p : points) {
    PVector v = p.copy().sub(center).mult(scaleFactor).add(center);
    results.add(v);
  }
  return results;
}

boolean outOfBounds(Polygon p) {
  for (PVector v : p.points) {
    if (v.x - p.r < margin || v.x + p.r > resWidth - margin || v.y - p.r < margin || v.y + p.r > resHeight - margin) {
      return true;
    }
  }
  return false;
}

boolean overlap(Polygon a, Polygon b) {
  //if (a.centroid.copy().sub(b.centroid).magSq() > (a.r + b.r) * (a.r + b.r)) {
  //  return false;
  //}
  for (int i = 0; i < a.points.size(); i++) {
    PVector aa = a.points.get(i);
    PVector ab = a.points.get((i + 1) % a.points.size());
    for (int j = 0; j < b.points.size(); j++) {
      PVector ba = b.points.get(j);
      PVector bb = b.points.get((j + 1) % b.points.size());
      if (intersect(aa, ab, ba, bb)) {
        return true;
      }
    }
  }
  return a.containsAny(b.points) || b.containsAny(a.points);
}

boolean overlapAny(Polygon a, ArrayList<Polygon> list) {
  for (Polygon p : list) {
    if (overlap(a, p)) {
      return true;
    }
  }
  return false;
}

// line segment AB intersects line segment CD, see: https://en.wikipedia.org/wiki/Line%E2%80%93line_intersection#Given_two_points_on_each_line
boolean intersect(PVector a, PVector b, PVector c, PVector d) {
  float tNom = (a.x - c.x) * (c.y - d.y) - (a.y - c.y) * (c.x - d.x);
  float tDenom = (a.x - b.x) * (c.y - d.y) - (a.y - b.y) * (c.x - d.x);
  float uNom = (a.x - c.x) * (a.y - b.y) - (a.y - c.y) * (a.x - b.x);
  float uDenom = (a.x - b.x) * (c.y - d.y) - (a.y - b.y) * (c.x - d.x);
  return abs(tNom) < abs(tDenom) && sign(tNom) == sign(tDenom) && abs(uNom) < abs(uDenom) && sign(uNom) == sign(uDenom);
}

int sign(float x) {
  return x == 0 ? 0 : (x > 0 ? 1 : -1);
}
