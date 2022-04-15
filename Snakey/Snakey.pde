PGraphics pg;
int pixPerInc = 3;
color cl, cl2;

void setup() {
  size(900, 900, P2D);
  pg = createGraphics(1080, 1080, P2D);
  pg.smooth(8);
  pg.beginDraw();
  pg.strokeCap(PROJECT);
  cl = color(255, 150, 255);
  cl2 = color(100, 50, 255);
  pg.stroke(150, 100, 255);
  pg.endDraw();
}

void draw() {
  PVector c = new PVector(pg.width / 2, pg.height / 2);
  float timeFactor = 0.05 + 0.95 * 0.5 * (1 + sin(radians(frameCount * 0.5)));
  
  pg.beginDraw();
  pg.background(0, 0, 50);
  pg.strokeWeight(4);
  pg.noFill();
  int r = pg.width / 2 - 50;
  int count = 0;
  while (r >= 60) {
    float rOffset = count * PI / 3;
    float circ = 2 * PI * r;
    int n = int(circ / pixPerInc);
    float frac = 1 + n * 1.0 * timeFactor;
    float inc = 2 * PI / n;
    float offset = radians(frameCount * 0.7);
    pg.beginShape();
    for (int i = 1; i < frac; i++) {
      float t = rOffset + offset + inc * i;
      float t2 = offset + inc * i;
      float maxWeight = 25.0 * r / 400 * frac / n;
      float thisR = r + 15.0 * sin(t2 * int(1.0 * pow(1.0 * r / 400, 1 / 2.0) * 10));
      float weightFactor = (1 - pow(abs(i - 1.0 * frac / 2) / (frac / 2), 2.0));
      pg.stroke(lerpColor(cl, cl2, 1.0 * i / frac));
      pg.strokeWeight(1 + maxWeight * weightFactor);
      PVector p = PVector.fromAngle(t).mult(thisR).add(c);
      pg.vertex(p.x, p.y);
    }
    pg.endShape();
    r -= 60;
    count++;
  }
  pg.endDraw();
  image(pg, 0, 0, width, height);
  if (frameCount % 60 == 0) {
    println(frameCount / 60 + " --- " + frameRate);
  }
}
