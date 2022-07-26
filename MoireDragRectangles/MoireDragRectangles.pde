PGraphics pg;
PVector start;
PVector end;

void setup() {
  size(900, 900, P2D);
  pg = createGraphics(width, height, P2D);
  rectMode(CORNERS);
  pg.smooth(8);
  pg.beginDraw();
  pg.imageMode(CORNERS);
  pg.background(255, 225, 200);
  pg.endDraw();
}

void draw() {
  background(255, 225, 200);
  image(pg, 0, 0, width, height);
  if (mousePressed) {
    noFill();
    rect(start.x, start.y, mouseX, mouseY);
  }
  println(frameCount / 60);
}

void mousePressed() {
  start = new PVector(mouseX, mouseY);
}

void mouseReleased() {
  end = new PVector(mouseX, mouseY);
  ringRect(start.x, start.y, end.x, end.y);
  
}

void ringRect(float x, float y, float x2, float y2) {
  int w = int(abs(x2 - x));
  int h = int(abs(y2 - y));
  PGraphics temp = createGraphics(w, h, P2D);
  temp.smooth(8);
  temp.beginDraw();
  temp.strokeWeight(2);
  temp.noFill();
  temp.ellipseMode(RADIUS);
  PVector center = new PVector(random(w), random(h));
  float maxR = max(w * 2, h * 2);
  for (float r = 4; r < maxR; r += 4) {
    temp.circle(center.x, center.y, r);
  }
  temp.rect(0, 0, w, h);
  temp.endDraw();
  pg.beginDraw();
  pg.image(temp, x, y, x2, y2);
  pg.endDraw();
}
