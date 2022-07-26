PGraphics pg, pg2;
PVector start;
PVector end;
PVector mouseMapped;

void setup() {
  size(900, 900, P2D);
  pg = createGraphics(1080, 1080, P2D);
  pg2 = createGraphics(1080, 1080, P2D);
  
  pg.smooth(8);
  pg.beginDraw();
  pg.imageMode(CORNERS);
  pg.background(255, 225, 200);
  pg.endDraw();
  
  pg2.smooth(8);
  pg2.beginDraw();
  pg2.rectMode(CORNERS);
  pg2.endDraw();
}

void draw() {
  mouseMapped = new PVector(map(mouseX, 0, width, 0, pg2.width), map(mouseY, 0, height, 0, pg2.height));
  pg2.beginDraw();
  pg2.background(255, 225, 200);
  pg2.image(pg, 0, 0, pg2.width, pg2.height);
  pg2.fill(0);
  pg2.circle(mouseMapped.x, mouseMapped.y, 15);
  if (mousePressed) {
    pg2.noFill();
    pg2.rect(start.x, start.y, mouseMapped.x, mouseMapped.y);
  }
  pg2.endDraw();
  image(pg2, 0, 0, width, height);
  println(frameCount / 60);
}

void mousePressed() {
  start = new PVector(mouseMapped.x, mouseMapped.y);
}

void mouseReleased() {
  if (mouseButton != RIGHT) {
    end = new PVector(mouseMapped.x, mouseMapped.y);
    ringRect(start.x, start.y, end.x, end.y);
  }
}

void mouseClicked() {
  if (mouseButton == RIGHT) {
    exit();
  }
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
