int margin = 35;
int perSide = 5;
PGraphics pg;

void setup() {
  size(900, 900, P2D);
  pg = createGraphics(1080, 1080, P2D);
  pg.smooth(8);
}

void draw() {
  pg.beginDraw();
  pg.background(255, 225, 200);
  int sidePlusShadow = (pg.width - margin * 2) / perSide;
  int hSide = int(sidePlusShadow * 2.0 / 3);
  int vSide = int(sidePlusShadow * 2.0 / 3);
  float h = 0.1 + 0.9 * 0.5 * (1 + sin(PI + radians(frameCount * 0.7)));
  float v = 0.1 + 0.9 * 0.5 * (1 + sin(radians(frameCount)));
  int hShadow = int(hSide / 2 * h);
  int vShadow = int(vSide / 2 * v);
  pg.noStroke();
  for (int x = margin; x < pg.width - margin; x += sidePlusShadow) {
    for (int y = margin; y < pg.height - margin; y += sidePlusShadow) {
      int px = x;
      int py = y;
      pg.fill(0);
      if (hShadow < 0) {
        hSide = -abs(hSide);
        px = x + abs(hSide);
      }
      if (vShadow < 0) {
        vSide = -abs(vSide);
        py = y + abs(vSide);
      }
      pg.push();
      pg.translate(px, py);
      if (x == margin + sidePlusShadow * 2 && y == margin + sidePlusShadow * 2) {
        pg.rotate(pow((radians(frameCount) % (2 * PI)) / (2 * PI), 3) * 2 * PI);
      }
      pg.beginShape();
      pg.vertex(0, vSide);
      pg.vertex(hSide, vSide);
      pg.vertex(hSide, 0); // 
      pg.vertex(hSide + hShadow, vShadow);
      pg.vertex(hSide + hShadow, vSide + vShadow);
      pg.vertex(hShadow, vSide + vShadow);
      pg.endShape(CLOSE);
      pg.fill(255, 225, 200);
      pg.square(0, 0, hSide);
      pg.pop();
    }
  }
  pg.endDraw();
  image(pg, 0, 0, width, height);
  if (frameCount % 60 == 0) {
    println(frameCount / 60 + " --- " + frameRate);
  }
}
