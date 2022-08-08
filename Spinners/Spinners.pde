PGraphics pg;

void setup() {
  size(900, 900, P3D);
  pg = createGraphics(1080, 1080, P3D);
  pg.smooth(8);
}

void draw() {
  pg.beginDraw();
  pg.background(255);
  pg.noStroke();
  pg.fill(0);
  pg.noFill();
  pg.stroke(0);
  pg.strokeWeight(3);
  int n = 10;
  float inc = pg.width / n;
  float time = radians(frameCount);
  float ft = pow(0.5 * (1 + sin(time * 0.5)), 1.5);
  for (int yi = 0; yi < n; yi++) {
    for (int xi = 0; xi < n; xi++) {
      int m = int(3 + 8 * noise(xi * 1234, yi * 3567));
      float f = 0.75 * pow(0.5 * (1 + sin(time + TAU * xi / n)), 3);
      pg.push();
      pg.translate(xi * inc + inc / 2, yi * inc + inc / 2);
      pg.beginShape();
      for (int i = 0; i < 200; i++) {
        float th = TAU * i / 200;
        float r = f * inc * 0.45 + (1 - f ) * inc * 0.45 * pow(0.5 * (1 + sin(th * m)), 1 + 9 * ft);
        PVector p = PVector.fromAngle(TAU * i / 200 + time).mult(r);
        pg.vertex(p.x, p.y);
      }
      pg.endShape(CLOSE);
      pg.pop();
    }
  }
  pg.endDraw();
  image(pg, 0, 0, width, height);
  println(frameCount / 60);
}
