int margin = 10;
PGraphics back;
PGraphics pg;

void setup() {
  size(900, 900, P3D);
  pg = createGraphics(1080, 1080, P3D);
  back = createGraphics(1080, 1080, P2D);
  pg.smooth(8);
  colorMode(HSB, 360, 100, 100, 100);
  pg.beginDraw();
  pg.colorMode(HSB, 360, 100, 100, 100);
  pg.endDraw();
  setupBackground();
}

void setupBackground() {
  float baseHue = 225;
  back.beginDraw();
  back.loadPixels();
  for (int y = 0; y < back.height; y++) {
    for (int x = 0; x < back.width; x++) {
      int px = x + y * back.width;
      back.pixels[px] = color(baseHue + 55.0 * x / back.height, 100, 100.0 * y / back.height);
    }
  }
  back.updatePixels();
  back.endDraw();
}

void draw() {
  pg.beginDraw();
  pg.image(back, 0, 0, pg.width, pg.height);
  pg.noFill();
  pg.strokeWeight(2);
  pg.stroke(25, 69, 100);
  PVector origin = new PVector(pg.width / 2, pg.height / 2);
  float rOuter = pg.width / 2 - margin;
  float rInner = pg.width / 4;
  int lerpPointCount = int((rOuter - rInner) / 2);
  int spokes = 10;
  float spokeInc = 2 * PI / spokes;
  float waveMagTimeFactor = pow(abs(sin(radians(frameCount * 0.1))), 0.5);
  for (int a = 0; a < spokes; a++) {
    float t = a * spokeInc;
    float t2 = t + spokeInc;
    float mid = (t + t2) / 2;
    int n = 20;
    PVector meetingPoint = PVector.fromAngle(mid).mult(rOuter).add(origin);
    float angleInc = (t2 - t) / n;
    float waveMag = 5 + 30.0 * waveMagTimeFactor;
    float waveOffset = radians(frameCount * 5);
    for (int i = 0; i <= n; i++) {
      float angle = t + i * angleInc;
      PVector rimPoint = PVector.fromAngle(angle).mult(rInner).add(origin);
      PVector dir = PVector.sub(meetingPoint, rimPoint).normalize();
      PVector normal = new PVector(-dir.y, dir.x);
      // draw line of "lerpPointCount" points between rimPoint and meetingPoint, with each point deviated a bit by a sine wave 
      pg.beginShape();
      for (int j = 0; j <= lerpPointCount; j++) {
        PVector v = PVector.lerp(rimPoint, meetingPoint, 1.0 * j / lerpPointCount);
        float calc = map(j, 0, lerpPointCount, 0, 2 * PI);
        calc = waveMag * sin(calc * 2.0 * sin(radians(frameCount * 0.5)) + waveOffset);
        float distFactor = 1.0 * j / lerpPointCount;
        // y = 1 - (2*x - 1)^2: 
        // ensure that wave magnitude approaches 0 when close to rimPoint and meetingPoint, so all lines end up where we want them to
        distFactor = 1 - (2 * distFactor - 1) * (2 * distFactor - 1); 
        v.add(PVector.mult(normal, calc * distFactor));
        pg.vertex(v.x, v.y);
      }
      pg.endShape();
      if (angle % TWO_PI > PI / 2 && angle % TWO_PI < 3 * PI / 2) { 
        PVector temp = rimPoint.copy().sub(origin);
        PVector rimPoint2 = new PVector(-temp.x, temp.y).add(origin);
        int lerpPointCount2 = int(abs(temp.x));
        float internalWaveMagTimeFactor = abs(sin(radians(frameCount * 0.25)));
        pg.beginShape();
        for (int j = 0; j <= lerpPointCount2; j++) {
          PVector v = PVector.lerp(rimPoint, rimPoint2, 1.0 * j / lerpPointCount2);
          float calc = map(j, 0, lerpPointCount, 0, 2 * PI);
          calc = internalWaveMagTimeFactor * 3 * waveMag * sin(calc * 2.0 + waveOffset);
          float distFactor = 1.0 * j / lerpPointCount2;
          distFactor = 1 - (2 * distFactor - 1) * (2 * distFactor - 1); 
          distFactor *= (1 - abs(temp.y) / rInner); // make horizontal waves smaller at top and bottom of circle
          v.add(new PVector(0, calc * distFactor));
          pg.vertex(v.x, v.y);
        }
        pg.endShape();
      }
    }
  }
  pg.endDraw();
  image(pg, 0, 0, width, height);
  println(frameCount / 60);
}
