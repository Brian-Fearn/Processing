import java.util.Date;

ArrayList<PVector> curve = new ArrayList<PVector>();
float yBase, yBaseInit;
int dotCount = 0;
boolean save = false;
PGraphics pg;

void setup() {
  size(1600, 900, P2D);
  pg = createGraphics(1920, 1080, P2D);
  pg.smooth(8);
  colorMode(HSB, 360, 100, 100, 100);
  pg.beginDraw();
  pg.colorMode(HSB, 360, 100, 100, 100);
  yBaseInit = pg.height / 10;
  yBase = yBaseInit;
  pg.stroke(40, 40 * (yBase - yBaseInit) / yBaseInit, 100, 30);
  pg.endDraw();
  //newCurve();
}

void mouseClicked() {
  save = true;
}

void draw() {
  //PVector a = new PVector(200, 100);
  //PVector b = new PVector(700, 400);
  //strip(a, b, 1, 50, 200);
  pg.beginDraw();
  if (frameCount == 1) {
    pg.background(0);
    newCurve();
  }
  int perFrame = 10000;
  int dotsPerCurve = 1000000;
  if (!curve.isEmpty()) {
    float w = 300;
    strip(curve, w, w, perFrame, 0.01, 1);
    dotCount += perFrame;
  }
  if (dotCount > dotsPerCurve) {
    dotCount = 0;
    newCurve();
  }
  //noLoop();
  println(frameRate);
  pg.endDraw();
  if (save) {
    save = false;
    pg.save("DreamscapesPartTwo" + (new Date()).getTime() + ".png");
  }
  image(pg, 0, 0, width, height);
}

void newCurve() {
  curve = new ArrayList<PVector>();
  if (yBase > pg.height + pg.height / 15) {
    return;
  }
  float initAngle = random(2 * PI);
  float co = random(0.5, 1.5);
  for (float x = -pg.width / 10; x < pg.width + pg.width / 10; x += 0.5) {
    float cx = map(x, -pg.width / 10, pg.width + pg.width / 10, 0, 1);
    float cy = 0.5 * (1 + sin(initAngle + 2 * PI * co * cx)); 
    //cy = noise(1000 + frameCount + initAngle + 2 * PI * co * cx);
    float py = map(cy, 0, 1, yBase, pg.height - pg.height / 20);
    //println(py);
    curve.add(new PVector(x, py));
  }
  yBase += 1.0 * pg.height / 30;
  pg.noStroke();
  pg.fill(0, 5);
  //pg.rect(0, 0, pg.width, pg.height);
  pg.fill(0);
  //pg.stroke(0, 100, 100);
  pg.beginShape();
  pg.vertex(0, pg.height);
  for (PVector p : curve) {
    pg.vertex(p.x, p.y);
  }
  pg.vertex(pg.width, pg.height);
  pg.endShape();
  float yFactor = (yBase - yBaseInit) / (pg.height - yBaseInit);
  pg.stroke(225, 30 + 70 * yFactor, 100, 30);
}

void strip(ArrayList<PVector> points, float wStart, float wEnd, float n, float fuzz, int dir) {
  for (int i = 0; i < n; i++) {
    float rand = random(1); //1 - pow(random(1), 0.3);
    int choice = int(rand * points.size());
    PVector p = points.get(min(choice, points.size() - 1));
    // calculate normal for PVector p based on previous and next points
    PVector prev = null;
    PVector next = null;
    if (choice > 0) {
      prev = points.get(choice - 1);
    }
    if (choice < points.size() - 1) {
      next = points.get(choice + 1);
    }
    PVector diff = new PVector(0, 0);
    if (prev != null && next != null) {
      diff = prev.copy().sub(next).normalize();
    } else if (prev != null) {
      diff = prev.copy().sub(p).normalize();
    } else if (next != null) {
      diff = next.copy().sub(p).normalize();
    }
    // use normal to pick point somewhere in the "thickness" of the curve 
    PVector normal = new PVector(dir * -diff.y, dir * diff.x);
    float randW = pow(random(1), 0.2);
    float w = lerp(wStart, wEnd, 1.0 * choice / points.size());
    PVector pos = p.copy().add(normal.mult(w - w * random(fuzz) - w * randW));
    //pos.y = pos.y + (1 - pow(random(1), 0.1)) * (pg.height - p.y);
    pg.strokeWeight(random(1.5));
    //println(pos);
    pg.point(pos.x, pos.y);
  }
}

void strip(PVector a, PVector b, float wStart, float wEnd, float n) {
  PVector diff = b.copy().sub(a);
  float m = diff.mag();
  PVector nDiff = diff.normalize();
  PVector normal = new PVector(-nDiff.y, nDiff.x);
  for (int i = 0; i < n; i++) {
    float rand = pow(random(1), 0.5);
    float _length = rand * m;
    PVector pos = a.copy().add(nDiff.copy().mult(_length));
    float w = lerp(wStart, wEnd, _length / m);
    pos.add(normal.copy().mult(w / 2 + random(w / 2)));
    strokeWeight(2 * rand);
    point(pos.x, pos.y);
  }
}
