import java.util.Date;

ArrayList<ArrayList<PVector>> curves = new ArrayList<ArrayList<PVector>>();
color bgColor = color(0);
color strokeColor = color(255, 225, 200, 30);
color strokeBase = color(255, 30);
float baseY;
float curvePower = 1.0 / 3;
int minCurves = 2;
int maxCurves = 4;
boolean randomStrokeColor = true;
PGraphics pg;

void setup() {
  size(1600, 900, P2D);
  pg = createGraphics(1920, 1080, P2D);
  pg.smooth(8);
  baseY = pg.height / 20;
  colorMode(HSB, 360, 100, 100, 100);
  pg.beginDraw();
  pg.background(bgColor);
  pg.colorMode(HSB, 360, 100, 100, 100);
  pg.endDraw();
}

boolean save = false;
void keyPressed() {
  if (key == ENTER) {
    save = true;
  }
}

void mouseClicked() {
  if (mouseButton == RIGHT) {
    pg.beginDraw();
    pg.noStroke();
    pg.fill(0, 10);
    pg.rect(0, 0, pg.width, pg.height);
    baseY += pg.height / 20;
    pg.endDraw();
  }
  strokeColor = randomStrokeColor ? color(random(360), 60, 100, 30) : strokeColor;
  curves = new ArrayList<ArrayList<PVector>>();
  float mx = map(mouseX, 0, width, 0, pg.width);
  int xMin = int(mx - random(pg.width / 12, pg.width / 3));
  int xMax = int(mx + random(pg.width / 12, pg.width / 3));
  int peakX = int(mx);
  int n = int(random(minCurves, maxCurves + 1));
  for (int i = xMin; i < xMax; i += int(1.0 * (xMax - xMin) / n)) {
    ArrayList<PVector> c = powerCurve(new PVector(i, pg.height), new PVector(peakX, baseY), int(pg.height - baseY), curvePower);
    curves.add(c);
  }
  
  pg.beginDraw();
  pg.noStroke();
  pg.fill(bgColor);
  pg.beginShape();
  for (int i = 0; i < curves.get(0).size(); i++) {
    PVector p = curves.get(0).get(i);
    pg.vertex(p.x, p.y);
  }
  for (int i = curves.get(curves.size() - 1).size() - 1; i >= 0 ; i--) {
    PVector p = curves.get(curves.size() - 1).get(i);
    pg.vertex(p.x, p.y);
  }
  pg.endShape(CLOSE);
  pg.endDraw();
  
}

void draw() {  
  pg.beginDraw();
  if (frameCount == 1) {
    pg.background(bgColor);
  }
  pg.noFill();
  pg.stroke(strokeColor);
  for (int i = 0; i < curves.size() - 1; i++) {
    ArrayList<PVector> thisCurve = curves.get(i);
    ArrayList<PVector> nextCurve = curves.get(i + 1);
    for (int j = 0; j < thisCurve.size(); j++) {
      PVector left = thisCurve.get(j);
      PVector right = nextCurve.get(j);
      float span = right.x - left.x;
      pg.strokeWeight(random(1.3));
      float rand = sqrt(random(1));
      float x = left.x + span * rand;
      float y = left.y + random(-2, 2);
      pg.point(x, y);
    }
  }
  if (save) {
    println("saving...");
    pg.save("DreamscapesPartOne" + (new Date()).getTime() + ".png");
    save = false;
  }
  
  pg.endDraw();
  
  image(pg, 0, 0, width, height);
}

ArrayList<PVector> powerCurve(PVector a, PVector b, int n, float power) {
  ArrayList<PVector> result = new ArrayList<PVector>();
  float magInc = 1.0 / n;
  for (int i = 0; i < n; i++) {
    float py = lerp(a.y, b.y, magInc * i);
    float cy = lerp(0, 1, magInc * i);
    float cx = pow(cy, power);
    float px = map(cx, 0, 1, a.x, b.x);
    result.add(new PVector(px, py));
  }
  return result;
}
