PGraphics pg;
PShader bloomShader;

void setup() {
  size(900, 900, P2D);
  pg = createGraphics(1080, 1080, P2D);
  pg.smooth(8);
  pg.beginDraw();
  pg.ellipseMode(RADIUS);
  bloomShader = new PShader(this, "shader.vert", "shader.frag");
  bloomShader.set("resolution", pg.width, pg.height);
  pg.blendMode(ADD);
  pg.colorMode(RGB, 255, 255, 255, 1.0);
  pg.endDraw();
  colorMode(RGB, 255, 255, 255, 1.0);
}

void draw() {
  pg.beginDraw();
  pg.background(0);
  pg.noStroke();
  
  float r = 90;
  int n = int(pg.height / (r * 2));
  int seconds = 5;
  int framesPerLoop = 60 * seconds;
  float xMin = r;
  float xMax = pg.width - r;
  
  float glowPortion = 0.5 + 0.5 * (0.5 * (1 + sin(radians(frameCount * 0.75))));
  bloomShader.set("radius", r * (1 - glowPortion));
  bloomShader.set("glowRadius", r * glowPortion);
  
  int reps = 1;
  for (int rep = 0; rep < reps; rep++) {
    int frameOffset = rep * framesPerLoop / (reps * 3);
    float calcX = 1.0 * ((frameCount + frameOffset) % framesPerLoop) / framesPerLoop;
    for (int i = 0; i < n; i++) {
      for (int c = 0; c < 3; c++) {
        PVector col = new PVector(0, 0, 0); // easy kludge: use PVector to store float RGB values to pass to shader
        switch (c % 3) {
          case 0:
            col = new PVector(1.0, 0, 0);
            break;
          case 1: 
            col = new PVector(0, 1.0, 0);
            break;
          case 2: 
            col = new PVector(0, 0, 1.0);
            break;
        }
        float yBase = r + 2 * i * r;
        float slope = 1 + i * 3.0 * mouseX / pg.width + c * 5.0 * mouseY / pg.height;
        
        // movement speed determined by sigmoid curve: starts slow, accelerates fast, then decelerates fast
        float sig0 = sigmoid(0, slope, 0.5);
        float sig1 = sigmoid(1, slope, 0.5);
        float sigX = sigmoid(calcX, slope, 0.5);
  
        // side to side movement
        bloomCircle(col, map(sigX, sig0, sig1, xMax, xMin), yBase, r);
        bloomCircle(col, map(sigX, sig0, sig1, xMin, xMax), yBase, r);
        bloomCircle(col, map(sigX, sig0, sig1, xMax, xMin), pg.height - yBase, r);
        bloomCircle(col, map(sigX, sig0, sig1, xMin, xMax), pg.height - yBase, r);
        
        // up and down movement
        bloomCircle(col, yBase, map(sigX, sig0, sig1, xMax, xMin), r);
        bloomCircle(col, pg.height - yBase, map(sigX, sig0, sig1, xMax, xMin), r);
        bloomCircle(col, yBase, map(sigX, sig0, sig1, xMin, xMax), r);
        bloomCircle(col, pg.height - yBase, map(sigX, sig0, sig1, xMin, xMax), r);
      }
    }
  }
  pg.endDraw();
  image(pg, 0, 0, width, height);
  println(frameCount / 60 + " --- " + frameRate);
}

void bloomCircle(PVector col, float x, float y, float r) {
  pg.shader(bloomShader);
  bloomShader.set("color", col);
  bloomShader.set("center", x, y);
  pg.circle(x, y, r);
}

float E = exp(1.0);
float sigmoid(float x, float k, float xMidpoint) {
  return 1 / (1.0 + pow(E, -k * (x - xMidpoint)));
}
