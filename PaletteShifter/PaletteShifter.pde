PGraphics pg;

Ball ball;

void setup() {
  size(900, 900, P2D);
  pg = createGraphics(1080, 1080, P2D);
  pg.smooth(8);
  colorMode(RGB, 1.0, 1.0, 1.0, 1.0);
  pg.beginDraw();
  pg.colorMode(RGB, 1.0, 1.0, 1.0, 1.0);
  pg.endDraw();
  ball = new Ball(new PVector(pg.width / 2, pg.height / 2), new PVector(1.5, 1), 20);
}

void draw() {
  pg.beginDraw();
  float rCoefficient = ball.p.x / pg.width;
  float gCoefficient = ball.p.y / pg.height;
  int nx = 5;
  int xInc = pg.width / nx;
  for (int y = 0; y < pg.height; y++) {
    float d = 1.0 * y / pg.height / 2;
    for (int x = 0; x < nx; x++) {
      float r = pow(abs(sin(radians(frameCount * 0.01 * (x + 1)) + 2 * PI * rCoefficient + 2 * PI * d)), 2 + x);
      float g = pow(abs(sin(2 * PI * gCoefficient + 2 * PI * d)), 3 + x);
      float b = pow(abs(sin(2 * PI * d)), 4 + x);
      pg.stroke(r, g, b);
      pg.line(x * xInc, y, (x + 1) * xInc, y);
    }
  }
  ball.update();
  ball.show();
  pg.endDraw();
  image(pg, 0, 0, width, height);
  println(frameCount / 60);
}

class Ball {
  
  float r;
  PVector p, v;
  
  Ball(PVector p, PVector v, float r) {
    this.p = p;
    this.v = v;
    this.r = r;    
  }
  
  void update() {
    p.add(v);
    if (p.x - r < 0 || p.x + r > pg.width) {
      v.x *= -1;
    }
    if (p.y - r < 0 || p.y + r > pg.height) {
      v.y *= -1;
    }
  }
  
  void show() {
    pg.noStroke();
    pg.fill(0);
    pg.circle(p.x, p.y, r);
  }
}
