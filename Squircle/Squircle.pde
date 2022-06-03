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

//Inspired by Inigo Quilez: https://www.shadertoy.com/view/7stcR4

void setup() {
  size(900, 900, P3D);
  strokeWeight(3);
  smooth(8);
}

void draw() {
  background(0, 50, 75);
  stroke(255, 225, 200);
  fill(245, 150, 75);
  int n = 10;
  float r = width / (n * 2);
  for (int yi = 0; yi < n; yi++) {
    for (int xi = 0; xi < n; xi++) {
      float findex = 1 - pow(1.0 * xi / n, 1);
      float t = 2 * abs(0.5 - fract(1 - pow(1.0 * yi / n, 1) + frameCount * 0.003)); // vary y-based index for size with time 
      float findex2 = 6 * pow(t, 5) - 15 * pow(t, 4) + 10 * pow(t, 3); // smoothstep: see https://en.wikipedia.org/wiki/Smoothstep#Generalization_to_higher-order_equations
      float y = yi * r * 2 + r;
      float x = xi * r * 2 + r;
      PVector o = new PVector(x, y);
      float offset = findex * PI * 2;
      squircle(o, r * (0.1 + 0.85 * findex2), offset, 0);
    }
  }
  println(frameRate);
}

float fract(float x) {
  return x - floor(x);
}

void squircle(PVector o, float r2, float offset, float rot) {
  push();
  translate(o.x, o.y);
  rotate(rot);
  translate(-r2, -r2);
  float t = 0.5 * (1 + sin(radians(frameCount * 1.3) + offset));
  ArrayList<PVector> points = new ArrayList<PVector>();
  for (float th = 0; th < PI / 2; th += (PI / 50)) {
    float cx = pow(abs(cos(th)), 0.5 + 5 * t); // exponent controls shape
    float cy = pow(abs(sin(th)), 0.5 + 5 * t);
    float px = map(cx, 0, 1, 0, r2);
    float py = map(cy, 0, 1, 0, r2);
    points.add(new PVector(px, py));
  }
  beginShape();
  for (PVector p : points) {
    vertex(p.x, p.y);
  }
  for (int i = 0; i < points.size(); i++) {
    PVector p = points.get(points.size() - 1 - i);
    vertex(p.x, 2 * r2 - p.y);
  }
  for (int i = 0; i < points.size(); i++) {
    PVector p = points.get(i);
    vertex(2 * r2 - p.x, 2 * r2 - p.y);
  }
  for (int i = 0; i < points.size(); i++) {
    PVector p = points.get(points.size() - 1 - i);
    vertex(2 * r2 - p.x, p.y);
  }
  endShape();
  pop();
}
