PGraphics bg;

void setup() {
  size(900, 900, P2D);
  bg = createGraphics(width, height);
  bg.beginDraw();
  colorMode(HSB, 360, 100, 100);
  bg.endDraw();
  setupBackground();
  colorMode(RGB, 255, 255, 255);
  smooth(8);
}

void setupBackground() {
  float maxD = dist(0, 0, width / 2, height);
  bg.beginDraw();
  bg.loadPixels();
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      int px = x + y * width; 
      float dFactor = dist(x, y, width / 2, height) / maxD;
      dFactor = pow(dFactor, 0.7);
      bg.pixels[px] = color(60 - 60.0 * dFactor, 90 - 20.0 * dFactor, 90 - 20.0 * dFactor);
      //bg.pixels[px] = color(60.0 * y / height, 90 - 20.0 * abs(y - height / 2) / (height / 2), 90 - 20.0 * y / height);
    }
  }
  bg.updatePixels();
  bg.endDraw();
}

float [] timeOffsets = new float[10];

void draw() {
  background(0);
  image(bg, 0, 0);
  noStroke();
  int n = 10;
  float yInc = 1.0 * height / n;
  int xn = 900;
  float moveY = height * 0.5 * (1 + sin(radians(frameCount * 0.2)));
  
  for (int i = 1; i <= n; i++) {
    float y = yInc * i;
    float t = timeOffsets[i - 1];
    float lerpRatio = 0.5 * (1 + sin(radians(frameCount * 0.4)));
    timeOffsets[i - 1] = timeOffsets[i - 1] + 0.05 + 0.25 * pow(abs(y - moveY) / height, 2);
    fill(0);
    beginShape();
    vertex(0, y);
    for (int xi = 0; xi <= xn; xi++) {
      float cx = map(xi, 0, xn, 0, 2 * PI);
      float px = map(xi, 0, xn, 0, width);
      float blockValue = pow(0.5 * (1 + sin(i * 10000 + floor(cx * n + t * 2.5) * 4)), 2);
      float curveValue = 0.5 * (1 + sin(cx * 5 + t));
      float cy = 0.1 * yInc + 0.85 * yInc * lerp(blockValue, curveValue, lerpRatio);
      float py = y - cy;
      vertex(px, py);
    }
    vertex(width, y);
    endShape(CLOSE);
  } 
  println(frameRate);
}
