import java.util.Comparator;

boolean outOfBounds(PVector p, float left, float right, float top, float bottom) {
  return p.x < left || p.x > right || p.y < top || p.y > bottom;
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
