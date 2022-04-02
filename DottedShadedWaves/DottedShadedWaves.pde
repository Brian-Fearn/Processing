import java.util.Date;
float [][] curves;
int curveCount = 7;

PGraphics pg;
color bgColor = color(255, 225, 200);
boolean save = false;

void setup() {
  size(900, 900, P2D);
  smooth(8);
  pg = createGraphics(2160, 2160, P2D);
  pg.smooth(8);
  pg.beginDraw();
  pg.background(bgColor);
  pg.endDraw();
  
  float amp = 300;
  float yBase = -350;
  curves = new float[curveCount][pg.width];
  for (int i = 0; i < curveCount; i++) {
    float coA = random(0.5, 2);
    float coB = random(0.5, 2);
    yBase = -400 + amp * 1.5 * i;
    float offset = random(PI / 16, 15 * PI / 16);
    curves[i] = new float[pg.width];
    for (int j = 0; j < pg.width; j++) {
      float x = map(j, 0, pg.width, 0, 2 * PI);
      float y = 0.5 * (1 + 0.5 * (cos(coA * x + offset) + sin(coB * x)));
      curves[i][j] = y * amp  + yBase;
    }
  }
}

void draw() {
  pg.beginDraw();
  if (frameCount == 1) {
    pg.background(bgColor);
  }
  float fuzz = 10;
  
  for (int i = 0; i < curveCount - 1; i++) {
    float [] topCurve = curves[i];
    float [] bottomCurve = curves[i + 1];
    for (int j = 0; j < 3000; j++) {
      int choice = int(random(0, pg.width));
      float top = topCurve[choice];
      float bottom = bottomCurve[choice];
      float d = bottom - top;
      float yChoice = random(top, bottom);
      float distFactor = abs(yChoice - top) / d;
      float f = random(fuzz);
      float px = choice + random(-fuzz/3, fuzz/3);
      if (random(1) < distFactor) {
        pg.point(px, yChoice + f);
      }
    }
  }
  pg.endDraw();
  if (save) {
    pg.save("DottedShadedWaves" + (new Date()).getTime() + ".png");
    save = false;
  }
  
  image(pg, 0, 0, width, height);
  println(frameRate);
}

void mouseClicked() {
  save = true;
}
