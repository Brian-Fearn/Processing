
int margin = 0;

void setup() {
  size(900, 900, P2D);
  smooth(8);
  colorMode(HSB, 360, 100, 100, 100);
}

void draw() {
  background(0);
  noStroke();
  fill(0);
  float rowT = 0.5 * (1 + sin(radians(-frameCount * 0.5)));
  float colT = 0.5 * (1 + sin(radians(frameCount * 0.25)));
  int perRow = 30;
  int perColumn = 60;
  
  float power = 0.75 + 2.25 * rowT; // mouseX / width;
  float powerV = 0.25 + 4.75 * colT; // mouseY / height;
  float y = margin;
  float _width = width - margin * 2;
  float _height = height - margin * 2;
  for (int col = 1; col <= perColumn; col++) {
    float colOffset = 2 * PI * col / perColumn;
    float py = 1.0 * col / perColumn;
    py = pow(py, powerV);
    float nextY = margin + py * _height;
    float x = margin;
    for (int i = 1; i <= perRow; i++) {
      float rowOffset = 2 * PI * i / perRow;
      float t = 0.001 + 0.998 * 0.5 * (1 + sin(rowOffset * 5 + colOffset * 3 + radians(frameCount * 3))); // time factor to vary triangle peak offset
      color hFill = color(50.0 * i / perRow, 100, 100);
      float p = 1.0 * i / perRow;
      p = pow(p, power);
      float nextX = margin + p * _width;
      float c = lerp(x, nextX, t); // calc offset for triangle peak
      fill(hFill);
      triangle(x, nextY, nextX, nextY, c, y);
      x = nextX;
    }
    y = nextY;
  }
  println(frameRate);
}
