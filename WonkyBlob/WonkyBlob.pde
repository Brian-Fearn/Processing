color bgColor = color(0, 0, 40);
color strokeColor = color(255, 225, 200); // color(200, 240, 255); //
PGraphics pg;

void setup() {
  size(900, 900, P2D);
  pg = createGraphics(1080, 1080, P2D);
  pg.smooth(8);
  
}

int folds = 5;
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
      n = 6;
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
  //pg.noFill();
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
    float distR = 50 
      + 50.0 * tFactor * cos(folds * angle + radians(frameCount * 5));
    distValues[i] = new PVector(distR * cosAngle, distR * sinAngle);
  }
  
  color col1 = color(255, 200, 255);
  
  int layers = 33;
  for (int i = layers - 1; i >= 0; i--) {
    PVector c = new PVector(height / 2 * sin(radians(frameCount)) * (1 - 1.0 * i / layers), height / 2 * sin(radians(PI / 3 + frameCount * 1.3)) * (1 - 1.0 * i / layers));
    float indexFactor = 1.0 * i / layers; 
    pg.fill(lerpColor(col1, bgColor, indexFactor));
    pg.noStroke();
    pg.beginShape();
    for (int j = 0; j < values.length; j++) {
      float ratio = abs(1.0 * i - layers) / layers;
      ratio = pow(ratio, 3);
      PVector val = PVector.lerp(values[j], distValues[j], ratio);
      PVector plot = val.copy().mult(1 + i);
      pg.vertex(c.x + plot.x, c.y + plot.y);
    }
    pg.endShape(CLOSE);
  }
  pg.endDraw();
  image(pg, 0, 0, width, height);
  println(frameCount / 60 + " | " + frameRate);
}
