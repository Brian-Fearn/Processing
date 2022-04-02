PGraphics pg;
Grid<Polygon> grid;
int resWidth, resHeight;
int MIN_NUMBER_OF_SIDES = 3;
int MAX_NUMBER_OF_SIDES = 6;
ArrayList<Polygon> polys = new ArrayList<Polygon>();
int MAX_ATTEMPTS = 10000;
float MIN_CIRCUMRADIUS = 5;
float MAX_CIRCUMRADIUS = 100;
int PADDING = 2;
int margin = 5;

void setup() {
  size(1600, 900, P2D);
  colorMode(HSB, 360, 100, 100);
  pg = createGraphics(1920, 1080, P2D);
  pg.smooth(8);
  resWidth = pg.width;
  resHeight = pg.height;
  pg.beginDraw();
  pg.colorMode(HSB, 360, 100, 100);
  pg.blendMode(ADD);
  grid = new Grid<Polygon>(int(pg.width / (MAX_CIRCUMRADIUS * 1.5)), int(pg.height / (MAX_CIRCUMRADIUS * 1.5)), pg.width, pg.height);
  pg.background(0);
  pg.endDraw();
}

int doneFrame = 0;

void draw() {
  pg.beginDraw();
  if (frameCount == 1) {
    pg.background(0);
  }
  int perFrame = 2;
  for (int i = 0; doneFrame == 0 && i < perFrame; i++) {
    Polygon p = placeNewPolygon();
    if (p == null) {
      println("done");
      doneFrame = frameCount;
      for (Polygon show : polys) {
        if (show.isNew) {
          show.show();
          show.isNew = false;
        }
      }
      //pg.save("polys.png");
      //noLoop();
    } else {
      polys.add(p);
      grid.add(p, p.centroid.x, p.centroid.y);
      for (Polygon show : polys) {
        if (show.isNew) {
          show.show();
          show.isNew = false;
        }
      }
    }
  }
  pg.endDraw();
  image(pg, 0, 0, width, height);
  if (doneFrame != 0 && doneFrame + 180 == frameCount) {
    noLoop();
    exit();
  }
  println(frameCount / 60);
}

Polygon placeNewPolygon() {
  int attempts = 0;
  int sides = int(random(MIN_NUMBER_OF_SIDES, MAX_NUMBER_OF_SIDES + 1));
  float radius = MIN_CIRCUMRADIUS;
  float maxR = radius;
  Polygon poly = null;
  float offset = random(2 * PI);
  while (attempts < MAX_ATTEMPTS) {  
    PVector pos = new PVector(random(margin + MIN_CIRCUMRADIUS, resWidth - margin - MIN_CIRCUMRADIUS), 
      random(margin + MIN_CIRCUMRADIUS, resHeight - margin - MIN_CIRCUMRADIUS));
    //float dFactor = 1 - dist(pos.x, pos.y, width / 2, height / 2) / sqrt(width * width / 4 + height * height / 4);
    maxR = MAX_CIRCUMRADIUS; // * pow(dFactor, 3);
    ArrayList<PVector> points = getPolyPoints(pos.x, pos.y, sides, radius, offset);
    poly = new Polygon(points, radius);
    ArrayList<Polygon> conflicts = grid.getCell(poly.centroid.x, poly.centroid.y).getOccupantsAndOccupantsOfNeighbors();
    if (overlapAny(poly, conflicts)) {
      attempts++;
      continue;
    } else {
      while (radius <= maxR) {
        radius++;
        points = getPolyPoints(pos.x, pos.y, sides, radius, offset);
        points = chaikin(points, 0.8, 4);
        poly = new Polygon(points, radius);
        if (overlapAny(poly, conflicts) || outOfBounds(poly)) {
          radius--;
          points = getPolyPoints(pos.x, pos.y, sides, radius, offset);
          points = chaikin(points, 0.8, 4);
          poly = new Polygon(points, radius);
          return poly;
        }
      }
      return poly;
    }
  }
  return null;
}

ArrayList<PVector> chaikin(ArrayList<PVector> curve, float ratio, int count) {
  ArrayList<PVector> newPoints = new ArrayList<PVector>(curve);
  for (int i = 0; i < count; i++) {
    newPoints = chaikin(newPoints, ratio);
  }
  return newPoints;
}

ArrayList<PVector> chaikin(ArrayList<PVector> curve, float ratio) {
    ArrayList<PVector> newPoints = new ArrayList<PVector>();
    for (int i = 0; i < curve.size(); i++) {
      PVector a = curve.get(i);
      PVector b = curve.get((i + 1) % curve.size());
      newPoints.add(a.copy().mult(ratio).add(b.copy().mult(1 - ratio)));
      newPoints.add(a.copy().mult(1 - ratio).add(b.copy().mult(ratio)));
    }
    return newPoints;
} 

ArrayList<PVector> getPolyPoints(float x, float y, float sides, float radius, float offset) {
  ArrayList<PVector> polyPoints = new ArrayList<PVector>();
  for (int i = 0; i < sides; i++) {
    float px = x + radius * cos(offset + i * 2 * PI / sides);
    float py = y + radius * sin(offset + i * 2 * PI / sides);
    polyPoints.add(new PVector(px, py));
  }
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
    pg.noStroke();
    //noFill();
    //strokeWeight(2);
    ArrayList<PVector> newP = new ArrayList<PVector>();
    for (PVector p : points) {
      newP.add(p.copy());
    }
    //for (int i = 0; i < 4; i++) {
    //  newP = chaikin(newP, 0.8);
    //}
    float maxCount = 30;
    int count = int(3 + 28.0 * pow(r / MAX_CIRCUMRADIUS, 1.0 / 3));
    for (int i = count; i >= 1; i--) {
      float sc = pow(1.0 * i / count, 4);
      ArrayList<PVector> scaled = scalePoints(newP, centroid, sc);
      pg.fill(fillColor, 40 + 65 * (1 - count / maxCount));
      pg.beginShape();
      for (PVector p : scaled) {
        pg.vertex(p.x, p.y);
      }
      pg.endShape(CLOSE);
    }
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
  if (a.centroid.copy().sub(b.centroid).magSq() > (a.r + b.r) * (a.r + b.r)) {
    return false;
  }
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
