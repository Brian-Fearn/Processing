import java.util.Date;

PGraphics pg;
color bgColor = color(40, 0, 0); // color(0); // color(255); // color(255, 225, 200);
color strokeColor = color(255, 125, 125, 40); // color(255, 125, 50, 40); //color(255, 40); // 
PVector c;
float r;
float maxDiagonal;
boolean save;

void setup() {
  size(1600, 900, P3D);
  pg = createGraphics(1920, 1080, P3D);
  maxDiagonal = sqrt(pg.width * pg.width + pg.height * pg.height);
  pg.smooth(8);
  pg.beginDraw();
  pg.ellipseMode(RADIUS);
  pg.stroke(strokeColor);
  pg.blendMode(ADD);
  pg.endDraw();
}

void draw() {
  int perFrame = 4;
  pg.beginDraw();
  if (frameCount == 1) {
    pg.noFill();
    pg.background(bgColor);
  }
  pg.strokeWeight(1);
  for (int j = 0; j < perFrame; j++) {
      float t = random(2 * PI);
      float t2 = t + PI / 2 * (random(2) < 1 ? -1 : 1);
      float x = r * cos(t);
      float y = r * sin(t);
      PVector v = PVector.fromAngle(t2);
      if (c != null) {
        PVector p = new PVector(x, y).add(c);
        PVector p2 = p.copy().add(v.mult(maxDiagonal));
        pg.line(p.x, p.y, p2.x, p2.y);
      }
  }
  if (save) {
    pg.save("TheIllusionOfForm" + (new Date()).getTime() + ".png");
    save = false;
  }
  pg.endDraw();
  image(pg, 0, 0, width, height);
  println(frameRate);
}

void mouseClicked() {
  if (mouseButton == LEFT) {
    float x = map(mouseX, 0, width, 0, pg.width);
    float y = map(mouseY, 0, height, 0, pg.height);
    r = random(100, 200);
    c = new PVector(x, y);
  }
  if (mouseButton == RIGHT) {
    save = true;
  }
}
