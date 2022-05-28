PGraphics pg;

PShader ovalShader;
float margin;

void setup() {
  size(1600, 900, P2D);
  pg = createGraphics(1920, 1080, P2D);
  margin = pg.width / 15.0;
  ovalShader = new PShader(this, "OvalVertShader.vert", "OvalFragShader.frag");
}

void draw() {
  background(255);
  int nPoints = 10;
  float [] pointsX = new float[nPoints];
  float [] pointsY = new float[nPoints];
  float speedFactor = 0.45;
  
  float yInc = (pg.height - margin * 2) / nPoints;
  for (int i = 0; i < nPoints; i++) {
    pointsX[i] = pg.width / 2 + sin(radians(speedFactor * frameCount * noise(i) + i * 97)) * (pg.width / 2 - margin);
    pointsY[i] = margin + i * yInc + yInc / 2;
  }
  
  pg.beginDraw();
  pg.shader(ovalShader);
  ovalShader.set("pointsX", pointsX);
  ovalShader.set("pointsY", pointsY);
  ovalShader.set("d", 1.0 * pg.width / 3 + pg.width / 16 * sin(radians(frameCount * 0.71)));
  ovalShader.set("powerAddition", 3.0 * pow(0.5 * (1 + (sin(radians(frameCount * 0.31)))), 2));
  pg.rect(0, 0, pg.width, pg.height);
  pg.endDraw();
  image(pg, 0, 0, width, height);
  println(frameCount / 60);
}
