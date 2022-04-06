color bgColor = color(0);
color strokeColor = color(255, 225, 200); // color(200, 240, 255); //
PGraphics pg;

void setup() {
  size(900, 900, P3D);
  pg = createGraphics(1080, 1080, P3D);
  pg.smooth(8);
  
}

int folds = 2;
int n = 400;

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      n++;
    }
    if (keyCode == DOWN && n > 3) {
      n--;
    }
    if (keyCode == LEFT) {
      n = 10;
    }
    if (keyCode == RIGHT) {
      n = 400;
    }
  }
  if (key == 'i') {
    color temp = bgColor;
    bgColor = strokeColor;
    strokeColor = temp;
  }
}

void draw() {
  pg.beginDraw();
  pg.background(bgColor);
  pg.noFill();
  pg.translate(pg.width / 2, pg.height / 2);
  pg.stroke(strokeColor);
  
  float inc = 2 * PI / n;
  PVector [] values = new PVector[n];
  PVector [] distValues = new PVector[n];
  float tFactor = sin(radians(frameCount));
  for (int i = 0; i < n; i++) {
    float angle = i * inc + radians(frameCount * 0.2);
    float r = 15;
    float cosAngle = cos(angle);
    float sinAngle = sin(angle);
    float x = r * cosAngle;
    float y = r * sinAngle;
    values[i] = new PVector(x, y);
    float distR = 20 
      + 10.0 * tFactor * cos(folds * angle + radians(frameCount * 0.7));
    distValues[i] = new PVector(distR * cosAngle, distR * sinAngle);
  }
  
  color col1 = color(255, 200, 100);
  color col2 = color(200, 0, 0);
  
  int layers = 33;
  for (int i = 0; i < layers; i++) {
    pg.beginShape();
    for (int j = 0; j < values.length; j++) {
      int index = (j + i * 3) % values.length;
      pg.strokeWeight(2 + 5.0 * abs(1.0 * (frameCount * 0.005 * n + index) % n - n / 2) / (n / 2));
      float indexFactor = abs(1.0 * j - values.length / 2) / (values.length / 2); 
      pg.stroke(lerpColor(col1, col2, indexFactor));
      float ratio = abs(1.0 * i - layers) / layers;
      PVector val = PVector.lerp(values[j], distValues[j], ratio);
      PVector plot = val.copy().mult(1 + i);
      pg.vertex(plot.x, plot.y);
    }
    pg.endShape(CLOSE);
  }
  pg.endDraw();
  image(pg, 0, 0, width, height);
  println(frameCount / 60 + " | " + frameRate);
}
