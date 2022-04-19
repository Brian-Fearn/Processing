ArrayList<PVector> tri = new ArrayList<PVector>();
PGraphics pg;

void setup() {
  size(900, 900, P2D);
  pg = createGraphics(1080, 1080, P2D);
  pg.smooth(8);
  int sideLength = pg.width / 10;
  tri.add(new PVector(0, 0));
  tri.add(new PVector(0, 1));
  tri.add(new PVector(1, 1));
  tri = fillIn(tri, 2.0 / sideLength);
}

void draw() {
  pg.beginDraw();
  pg.background(0);
  pg.noStroke();
  float f = pow(0.5 + 0.5 * mouseX / width, 1);
  float speed = 0.8; 
  
  color c1 = color(255, 75, 0);
  color c2 = color(255, 225, 200);
  color c3 = color(100, 50, 255);
  color c4 = color(0, 0, 255);
  //color c5 = lerpColor(c2, c4, 0.5 * (1 + sin(radians(frameCount * speed))));  
  int n = 10;
  int inc = pg.width / n;  
  for (int cy = 0; cy < n; cy++) {
    int yBase = cy * inc;
    color c = lerpColor(c1, c3, 1.0 * cy / n);
    for (int cx = 0; cx < n; cx++) {
      int off = int(frameCount * speed + 50.0 * cx / n);
      int endIndex = int(off + f * tri.size());
      int xBase = cx * inc;
      pg.fill(c);
      pg.beginShape();
      for (int i = off; i < endIndex; i ++) {
        PVector p = tri.get(i % tri.size());
        pg.vertex(p.x * inc + xBase, p.y * inc + yBase);
      }
      pg.endShape();
      pg.fill(c2);
      pg.beginShape();
      for (int i = off; i < endIndex; i ++) {
        PVector p = tri.get(i % tri.size());
        pg.vertex(inc - p.x * inc + xBase, inc - p.y * inc + yBase);
      }
      pg.endShape();
    } 
  }
  pg.endDraw();
  if (frameCount % 60 == 0) {
    println(frameCount / 60 + " --- " + frameRate);
  }
  image(pg, 0, 0, width, height);
}

ArrayList<PVector> fillIn(ArrayList<PVector> curve, float pixInc) {
  if (curve.isEmpty()) {
    return curve;
  }
  ArrayList<PVector> newCurve = new ArrayList<PVector>();
  for (int i = 0; i < curve.size(); i++) {
    PVector p = curve.get(i % curve.size());
    PVector next = curve.get((i + 1) % curve.size());
    PVector diff = next.copy().sub(p);
    PVector n = diff.copy().normalize();
    float mag = diff.mag();
    int c = round(mag / pixInc);
    for (float j = 0; j < c; j++) {
      PVector v = p.copy().add(n.copy().mult(j * mag / c));
      newCurve.add(v);
    }  
  }
  return newCurve;
}
