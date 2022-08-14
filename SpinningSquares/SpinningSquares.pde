PGraphics pg;

void setup() {
  size(900, 900, P3D);
  pg = createGraphics(1080, 1080, P3D);
  pg.smooth(8);
  pg.beginDraw();
  pg.strokeWeight(2);
  pg.rectMode(RADIUS);
  pg.ellipseMode(RADIUS);
  pg.endDraw();
}

int arms = 0;

void draw() {
  pg.beginDraw();
  pg.background(0);
  pg.stroke(255);
  pg.strokeWeight(1);
  pg.fill(0);
  int n = 33;
  float inc = 1.0 * pg.width / n;
  int frames = 4 * 60;
  float t = (frameCount % frames) / float(frames); // 0.3 + 0.7 * 0.5 * (1 + sin(radians(frameCount * 1)));
  float t2 = (frameCount % (frames * 2)) / float(frames * 2);
  float maxD = dist(pg.width / 2, pg.height / 2, 0, 0);
  for (int yi = 0; yi < n; yi++) {
    for (int xi = 0; xi < n; xi++) {
      float y = yi * inc + inc / 2;
      float x = xi * inc + inc / 2;
      PVector diff = new PVector(x, y).sub(new PVector(pg.width / 2, pg.height / 2));
      pg.push();
      pg.translate(x, y);
      float fd = 2 + 10 * pow(0.5 * (1 + sin(dist(pg.width / 2, pg.height / 2, x, y) / maxD * TAU * 2 + diff.heading() * arms)), 2);
      float fdd = TAU * 0.5 * (1 + sin(TAU * (t + fd)));
      pg.rotateY(x / width * PI + TAU * t2);
      //pg.rotateY(pow(sin(PI / 2 * t), fd) * TAU + PI);
      pg.rotateX(pow(sin(PI / 2 * t), fd) * TAU + PI);
      pg.translate(0, 0, 0.25);
      pg.fill(255);
      pg.square(0, 0, inc / 2 * 0.65);
      pg.translate(0, 0, -0.5);
      pg.fill(0);
      pg.square(0, 0, inc / 2 * 0.65);
      pg.pop();
    }
  }
  if (frameCount % frames == 0) {
    arms = (arms + 3) % 6;
  }
  pg.endDraw();
  image(pg, 0, 0, width, height);
  if (frameCount == 240 * 4 + 1) {
    //noLoop();
  }
  println(frameCount / 60);
}
