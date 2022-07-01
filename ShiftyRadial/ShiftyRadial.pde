//MIT License

//Copyright (c) 2022 Brian Fearn

//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:

//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.

//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

PGraphics pg;

void setup() {
  size(900, 900, P2D);
  pg = createGraphics(1080, 1080, P2D);
  pg.smooth(8);
}

void draw() {
  pg.beginDraw();
  pg.background(0, 20, 30);
  pg.fill(255, 215, 160);
  pg.noStroke();
  pg.translate(pg.width / 2, pg.height / 2);
  int n = 48;
  float divs = 1 + 10 * 0.5 * (1 + sin(PI / 2 + radians(frameCount * 0.1)));
  float rPadding = pg.width / 30;
  float maxR = pg.width / 2 - rPadding;
  for (int i = 0; i < n; i++) {
    float th = i * TAU / n;
    for (float d = 0; d < divs; d++) {
      float inc = maxR / divs;
      float offset = PI / divs * d;
      pg.beginShape(QUAD_STRIP);
      float rStart = rPadding + inc * d;
      float rEnd = d + 1 > divs ? rPadding + inc * divs : rPadding + inc * (d + 1);
      for (float r = rStart; r <= rEnd; r ++) {
        float w = map(r, rStart, rEnd, 0, 1);
        float fw = 1 - (2 * w - 1) * (2 * w - 1);
        float c = map(r, 0, maxR, 0, TAU);
        float a = offset + th + 0.5 * sin(offset + radians(frameCount * 0.5) + c);
        float m = 6.0;
        PVector p = PVector.fromAngle(a - fw * TAU / (n * m)).mult(r);
        PVector p2 = PVector.fromAngle(a + fw * TAU / (n * m)).mult(r);
        pg.vertex(p.x, p.y);
        pg.vertex(p2.x, p2.y);
      }
      pg.endShape();
    }
  }
  pg.endDraw();
  image(pg, 0, 0, width, height);
  println(frameCount / 60);
}
