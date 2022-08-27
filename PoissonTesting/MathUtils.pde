import java.util.Comparator;

class Rect {
  
  PVector pos;
  float rw, rh;
  boolean isNew;
  
  Rect(PVector pos, float rw, float rh) {
    this.pos = pos;
    this.rw = rw;
    this.rh = rh;
    this.isNew = true;
  }
  
  boolean intersects(Rect other) {
    return xOverlap(other) && yOverlap(other);
  }
  
  boolean intersectsAny(ArrayList<Rect> others) {
    for (Rect o : others) {
      if (this.intersects(o)) {
        return true;
      }
    }
    return false;
  }
  
  boolean xOverlap(Rect other) {
    return this.pos.x + this.rw > other.pos.x - other.rw || this.pos.x - this.rw < other.pos.x + other.rw; 
  }
  
  boolean yOverlap(Rect other) {
    return this.pos.y + this.rh > other.pos.y - other.rh || this.pos.y - this.rh < other.pos.y + other.rh;
  }
  
}

long getPointId(float x, float y) {
  int signX = sign(x) + 1;
  int signY = sign(y) + 1;
  return (long) (int(x) + 10000 * int(y) + 1000000000 * signX + 1000000000000L * signY);
}

class Point extends PVector {
  
  long id;
  ArrayList<Point> neighbors = new ArrayList<Point>();
  
  Point(float x, float y) {
    this.x = x;
    this.y = y;
    this.id = getPointId(x, y);
  }
  
  Point copy() {
    Point p = new Point(x, y);
    p.id = (long) random(Long.MIN_VALUE, Long.MAX_VALUE);
    return p;
  }
  
  @Override
  public boolean equals(Object o) {
    return ((Point) o).id == this.id;
  }
  
  @Override
  public int hashCode() {
    return (int) id;
  }
  
}

boolean withinDistance(Point p, float d, Point other) {
  return p.copy().sub(other).magSq() < d * d;
}

ArrayList<Point> getPointsWithinDistance(Point p, float d, ArrayList<Point> others) {
  ArrayList<Point> results = new ArrayList<Point>();
  for (Point o : others) {
    if (o != p && withinDistance(p, d, o)) {
      results.add(o);
    }
  }
  return results;
}

void rotateWithRespectTo(PVector p, PVector v, float angle) {
  p.sub(v);
  p.rotate(angle);
  p.add(v);
}

boolean outOfBounds(PVector p, float left, float right, float top, float bottom) {
  return p.x < left || p.x > right || p.y < top || p.y > bottom;
}

// line segment AB intersects line segment CD, see: https://en.wikipedia.org/wiki/Line%E2%80%93line_intersection#Given_two_points_on_each_line
boolean intersect(PVector a, PVector b, PVector c, PVector d) {
  if ((a.equals(c) && b.equals(d)) || (a.equals(d) && b.equals(c))) {
    return true;
  }
  float tNom = (a.x - c.x) * (c.y - d.y) - (a.y - c.y) * (c.x - d.x);
  float tDenom = (a.x - b.x) * (c.y - d.y) - (a.y - b.y) * (c.x - d.x);
  float uNom = (a.x - c.x) * (a.y - b.y) - (a.y - c.y) * (a.x - b.x);
  float uDenom = (a.x - b.x) * (c.y - d.y) - (a.y - b.y) * (c.x - d.x);
  
  return abs(tNom) < abs(tDenom) && sign(tNom) == sign(tDenom) && abs(uNom) < abs(uDenom) && sign(uNom) == sign(uDenom);
}

int sign(float x) {
  return x == 0 ? 0 : (x > 0 ? 1 : -1);
}

boolean withinDistance(PVector p, float d, PVector other) {
  return p.copy().sub(other).magSq() < d * d;
}

boolean anyWithinDistance(PVector p, float d, ArrayList<PVector> others) {
  for (PVector other : others) {
    if (withinDistance(p, d, other)) {
      return true;
    }
  }
  return false;
}

ArrayList<PVector> getPointsWithinDistance(PVector p, float d, ArrayList<PVector> others) {
  ArrayList<PVector> results = new ArrayList<PVector>();
  for (PVector o : others) {
    if (o != p && withinDistance(p, d, o)) {
      results.add(o);
    }
  }
  return results;
}

// ray-casting test for containment: https://en.wikipedia.org/wiki/Point_in_polygon#Ray_casting_algorithm
boolean polygonContains(ArrayList<PVector> polygon, PVector p) {
  PVector rayEnd = new PVector(width * 10, height * 10);
  int intersections = 0;
  for (int i = 0; i < polygon.size(); i++) {
    PVector a = polygon.get(i);
    PVector b = polygon.get((i + 1) % polygon.size());
    if (intersect(a, b, p, rayEnd)) {
      intersections++;
    }
  }
  return intersections % 2 == 1;
}

PVector closestPoint(PVector p, ArrayList<PVector> others) {
  PVector closest = others.get(0);
  for (PVector o : others) {
    if (p.copy().sub(o).magSq() < p.copy().sub(closest).magSq()) {
      closest = o;
    }
  }
  return closest;
}

ArrayList<PVector> closestNPoints(final PVector p, ArrayList<PVector> candidates, int n) {
  ArrayList<PVector> points = new ArrayList<PVector>(candidates);
  Comparator<PVector> comp = new Comparator<PVector>() {
    public int compare(PVector v, PVector other) {
      float d1 = v.copy().sub(p).magSq();
      float d2 = other.copy().sub(p).magSq();
      return Float.compare(d1, d2);
    }
  };
  points.sort(comp);
  return new ArrayList<PVector>(points.subList(0, n));
}

ArrayList<Point> closestNPoints(final Point p, ArrayList<Point> candidates, int n) {
  ArrayList<Point> points = new ArrayList<Point>(candidates);
  Comparator<Point> comp = new Comparator<Point>() {
    public int compare(Point v, Point other) {
      float d1 = v.copy().sub(p).magSq();
      float d2 = other.copy().sub(p).magSq();
      return Float.compare(d1, d2);
    }
  };
  points.sort(comp);
  return new ArrayList<Point>(points.subList(0, n));
}

class Segment {
  
  PVector a, b;
  long id;
  boolean isNew;
  
  Segment(PVector a, PVector b) {
    this.a = a;
    this.b = b;
    this.isNew = true;
    //this.id = (long) random(Long.MIN_VALUE, Long.MAX_VALUE);
  }
  
  boolean intersects(PVector c, PVector d) {
    return intersect(a, b, c, d);
  }
  
  boolean intersectsAny(ArrayList<Segment> others) {
    for (Segment s : others) {
      if (s.intersects(a, b)) {
        return true;
      }
    }
    return false;
  }
  
  @Override
  boolean equals(Object o) {
    Segment s = (Segment) o;
    return s.a == this.a && s.b == this.b;
  }
  
  @Override
  int hashCode() {
    return a.hashCode() + b.hashCode();
  }
  
}

class Polygon {
  
  ArrayList<PVector> points;
  
  Polygon(ArrayList<PVector> list) {
    this.points = list;
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
  
  boolean intersects(Polygon b) {
    for (int i = 0; i < this.points.size(); i++) {
      PVector aa = this.points.get(i);
      PVector ab = this.points.get((i + 1) % this.points.size());
      for (int j = 0; j < b.points.size(); j++) {
        PVector ba = b.points.get(j);
        PVector bb = b.points.get((j + 1) % b.points.size());
        if (intersect(aa, ab, ba, bb)) {
          return true;
        }
      }
    }
    return this.containsAny(b.points) || b.containsAny(this.points);
  }
  
  boolean intersectsAny(ArrayList<Polygon> list) {
    for (Polygon p : list) {
      if (this.intersects(p)) {
        return true;
      }
    }
    return false;
  }
  
}
