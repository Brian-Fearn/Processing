int curveMode = 0;
int squareMode = 1;
int mode = squareMode;
PGraphics pg;

void setup() {
  size(900, 900, P3D);
  pg = createGraphics(1080, 1080, P3D);
  pg.smooth(8);
  pg.beginDraw();
  pg.ellipseMode(RADIUS);
  pg.endDraw();
}

void draw() {
  pg.beginDraw();
  pg.background(255, 225, 200);
  pg.noFill();
  int n = mode == curveMode ? 60 : 20;
  float r = 500;
  float inc = 2 * PI / n;
  float radiusInc = 1;
  PVector mappedMouse = new PVector(map(mouseX, 0, width, 0, pg.width), map(mouseY, 0, height, 0, pg.height));
  PVector c = new PVector(pg.width / 2, pg.height / 2);
  float maxAmp = mode == curveMode ? 125.0 : 50.0;
  float speed = mode == curveMode ? 1.3 : 4;
  float freq = mode == curveMode ? 1 : 10;
  float offset = radians(frameCount * speed);
  
  float [] sineValues = new float [int(r / radiusInc + 1)];
  float [] squareValues = new float [int(r / radiusInc + 1)];
  for (int j = 0; j <= r / radiusInc; j++) {
    sineValues[j] = sin(radians(radiusInc * j * freq) + offset) * maxAmp * mappedMouse.x / pg.width;
  }
  for (int j = 0; j <= r / radiusInc; j++) {
    float s = sin(radians(radiusInc * j * freq) + offset * 2) > 0 ? 1 : -1;
    squareValues[j] = s * maxAmp * mappedMouse.x / pg.width;
  }
  
  float maxWeight = 10 + 20.0 * mappedMouse.y / pg.height;
  float minWeight = 2.0;
  for (int i = 0; i < n; i++) {
    float angle = i * inc;
    PVector p = PVector.fromAngle(angle);
    PVector norm = new PVector(-p.y, p.x);
    pg.beginShape();
    for (int j = 0; j <= r / radiusInc; j++) {
      float weightFactor = pow(1 - abs(j * radiusInc - r / 2) / (r / 2), 1 + 10.0 * mappedMouse.y / pg.height);
      pg.strokeWeight(minWeight + maxWeight * weightFactor);
      float val = mode == curveMode ? sineValues[j] : squareValues[j];
      PVector plot = p.copy().mult(j * radiusInc).add(norm.copy().mult(val * (j * radiusInc) / r)).add(c);
      pg.vertex(plot.x, plot.y);
    } 
    pg.endShape();
  }
  pg.endDraw();
  image(pg, 0, 0, width, height);
  println(frameCount / 60);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      mode = 1 - mode;
    }
  }
}
