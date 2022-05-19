import java.util.Date;

ArrayList<PVector> curve = new ArrayList<PVector>();
float yBase, yBaseInit;
int dotCount = 0;
int shadeDirection = -1; // -1 goes toward bottom of screen, 1 goes toward top 
int dotsPerFrame = 10000;
int dotsPerCurve = 1000000;
float shadeFuzz = 0.01;
float curveThickness = 300;
float xPadding, topPadding, bottomPadding, yIncrement;
float minCoefficient = 0.5;
float maxCoefficient = 1.5;
float shadeFalloff = 10;
float maxStrokeWeight = 1.5;
float baseHue = 140; // 0 to 360
float baseSaturation = 90;
float saturationRange = 90;
int saturationChangeDirection = -1;
long seed;
boolean noiseCurve = false;
boolean useNormal = false; // shade perpendicular to the curve rather than vertical
boolean save = false;
PGraphics pg;

void setup() {
  randomSeed(seed = (long) random(10000000));
  size(1600, 900, P2D);
  pg = createGraphics(1920, 1080, P2D);
  pg.smooth(8);
  colorMode(HSB, 360, 100, 100, 100);
  pg.beginDraw();
  pg.colorMode(HSB, 360, 100, 100, 100);
  xPadding = pg.width / 10;
  bottomPadding = pg.height / 20;
  topPadding = pg.height / 10;
  yBaseInit = pg.height / 10;
  yIncrement = pg.height / 30;
  yBase = yBaseInit;
  pg.endDraw();
}

void mouseClicked() {
  save = true;
}

void draw() {
  pg.beginDraw();
  if (frameCount == 1) {
    pg.background(0);
    newCurve();
  }
  if (!curve.isEmpty()) {
    float w = curveThickness;
    strip(curve, w, w, dotsPerFrame, shadeFuzz, shadeDirection);
    dotCount += dotsPerFrame;
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
    pg.save("DreamscapesPartTwo" + (new Date()).getTime() + "seed" + seed + ".png");
  }
  image(pg, 0, 0, width, height);
}

void newCurve() {
  curve = new ArrayList<PVector>();
  if (yBase > pg.height + bottomPadding) {
    return;
  }
  float initAngle = random(2 * PI);
  float co = random(minCoefficient, maxCoefficient);
  for (float x = -xPadding; x < pg.width + xPadding; x += 0.5) {
    float cx = map(x, -xPadding, pg.width + xPadding, 0, 1);
    float cy = 0.0; 
    if (noiseCurve) {
      cy = noise(1000 + frameCount + initAngle + 2 * PI * co * cx);
    } else {
      cy = 0.5 * (1 + sin(initAngle + 2 * PI * co * cx));
    }
    float py = map(cy, 0, 1, yBase, pg.height - bottomPadding);
    curve.add(new PVector(x, py));
  }
  yBase += yIncrement;
  pg.noStroke();
  //pg.fill(0, 5);
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
  pg.stroke(baseHue, baseSaturation + saturationChangeDirection * saturationRange * yFactor, 100, 30);
}

void strip(ArrayList<PVector> points, float wStart, float wEnd, float n, float fuzz, int dir) {
  for (int i = 0; i < n; i++) {
    float rand = random(1); //1 - pow(random(1), 0.3);
    int choice = int(rand * points.size());
    PVector p = points.get(min(choice, points.size() - 1));
    PVector pos = p.copy();
    if (useNormal) {
      PVector normal = getNormal(p, points, choice, dir);
      // use normal to pick point somewhere in the "thickness" of the curve 
      float randW = pow(random(1), 1.0 / shadeFalloff);
      float w = lerp(wStart, wEnd, 1.0 * choice / points.size());
      pos.add(normal.mult(w - w * random(fuzz) - w * randW));
    } else {
      pos.y = pos.y - dir * (1 - pow(random(1), 1.0 / shadeFalloff)) * (pg.height - p.y);
    }
    pg.strokeWeight(random(maxStrokeWeight));
    pg.point(pos.x, pos.y);
  }
}

PVector getNormal(PVector p, ArrayList<PVector> points, int choice, int dir) {
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
  return new PVector(dir * -diff.y, dir * diff.x);
} 
