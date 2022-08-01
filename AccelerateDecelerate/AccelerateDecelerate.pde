int rows = 4;
float [] offsets = new float[rows + 1]; 
float [] rates = new float[rows + 1];

void setup() {
  size(900, 900, P2D);
  smooth(8);
  ellipseMode(RADIUS);
}

void draw() {
  background(0, 10, 40);
  noStroke();
  fill(255, 225, 200);
  float inc = 1.0 * width / rows;
  for (int i = 0; i <= rows; i++) {
    rates[i] = 3 * 0.5 * (1 + sin(radians(frameCount * 0.25) + i * PI / rows));
  }
  
  for (int i = 0; i <= rows; i++) {
    float y = inc * i;
    offsets[i] += rates[i];
    for (int j = 0; j <= rows + 1; j++) {
      float x = -inc + (j * inc + offsets[i]) % (width + inc * 2);
      circle(x, y, inc / 2);
    }
  }
  println(frameCount / 60);
}
