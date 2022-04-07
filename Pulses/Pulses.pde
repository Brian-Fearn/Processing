PGraphics pg;
color bgColor = color(0, 0, 30);
color strokeColor = color(40, 55, 255);
int margin = 25;

void setup() {
  size(900, 900, P3D);
  pg = createGraphics(1080, 1080, P3D);
  pg.smooth(8);
  pg.beginDraw();
  pg.blendMode(ADD);
  pg.strokeWeight(4);
  pg.ellipseMode(RADIUS);
  pg.endDraw();
}

void draw() {
  pg.beginDraw();
  pg.noStroke();
  pg.background(bgColor);
  float maxR = 100;
  int dir = 1;
  for (float y = maxR - 10; y < pg.height - maxR / 2; y += maxR) {
    float g = 20 + 200 * pow(abs(y - pg.height / 2) / (pg.height / 2), 3);
    float b = 255 * pow(abs(y - pg.height / 2) / (pg.height / 2), 2);
    float rd = 200 * pow(1 - abs(y - pg.height / 2) / (pg.height / 2), 2);
    pg.fill(rd, g, b, 15);
    for (int i = margin; i < pg.width - margin; i += 2) {
      float px = i;
      float xFactor = 1 - pow(abs(px - pg.width / 2) / (pg.width / 2), 1.0 / 3);
      float r = xFactor * maxR * 0.5 * (1 + sin(radians(i) + radians(dir * frameCount * 3)));
      pg.circle(px, y, r); 
    }
    dir *= -1;
  }
  pg.endDraw();
  
  image(pg, 0, 0, width, height);
  println(frameRate);
}
