PGraphics pg;

void setup() {
  size(900, 900, P3D);
  pg = createGraphics(1080, 1080, P3D);
  pg.smooth(8);
  pg.beginDraw();
  pg.background(255);
  pg.endDraw();
}

void draw() {
  pg.beginDraw();
  pg.background(255);
  pg.stroke(0);
  pg.strokeWeight(2);
  float xInc = 20 + 200 * (0.5 * (1 + sin(radians(frameCount * 0.5))));
  float yInc = 20 + 200 * (0.5 * (1 + sin(radians(PI / 3 + frameCount * 0.3))));
  for (float y = yInc; y < pg.height + yInc; y += yInc) {
    pg.beginShape();
    for (int x = 0; x <= pg.width; x += 5) {
      float f = pow(1.0 * abs(x - pg.width / 2) / (pg.width / 2), 2);
      pg.strokeWeight(1 + yInc / 2.0 * f);
      pg.vertex(x, y);
    }
    pg.endShape();
  } 
  pg.strokeWeight(2);
  for (float x = xInc; x < pg.width + xInc; x += xInc) {
    pg.beginShape();
    for (int y = 0; y <= pg.height; y += 5) {
      float f = pow(1.0 * abs(y - pg.height / 2) / (pg.height / 2), 2);
      pg.strokeWeight(1 + xInc / 2.0 * f);
      pg.vertex(x, y);
    }
    pg.endShape();
  }
  pg.endDraw();
  image(pg, 0, 0, width, height);
  if (frameCount % 60 == 0) {
    println(frameCount / 60);
  }
  //println(frameRate);
}
