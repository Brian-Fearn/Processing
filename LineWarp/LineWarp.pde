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

int n = 3;
ArrayList<Warper> warpers = new ArrayList<Warper>();

void setup() {
  size(900, 900, P3D);
  smooth(8);
  noFill();
  for (int i = 0; i < n; i++) {
    warpers.add(new Warper());
  }
}

void draw() {
  background(0, 0, 50);
  strokeWeight(2);
  int yn = 50;
  float yinc = 1.0 * height / yn;
  int xn = 300;
  float xinc = 1.0 * width / xn;
  for (Warper w : warpers) {
    w.update();
  }
  for (int yi = -10; yi < yn + 10; yi++) {
    float y = yi * yinc + yinc / 2;
    stroke(yi % 2 == 0 ? color(255, 225, 200) : color(200, 200, 255)); // color(255, 175, 200));
    beginShape();
    for (int xi = -35; xi < xn + 35; xi++) {
      float x = xi * xinc + xinc / 2;
      PVector p = new PVector(x, y);
      for (Warper w : warpers) {
        PVector o = w.pos;
        float fdist = pow(1 - min(1.0, p.copy().sub(o).mag() / w.warpRadius), 5.0);
        if (fdist > 0.0) {
          p.sub(o);
          p.rotate(fdist * w.warpAngle);
          p.add(o);
        }
      }
      vertex(p.x, p.y);
    }
    endShape();
  }
  println(frameRate);
}

class Warper {
  
  PVector pos, vel;
  float timeOffset, warpAngle, warpRadius;
  
  Warper() {
    this.pos = new PVector(random(width), random(height));
    this.vel = new PVector(random(1, 4) * (random(2) < 1 ? -1 : 1), random(1, 4) * (random(2) < 1 ? -1 : 1));
    this.timeOffset = random(2 * PI);
    this.warpAngle = (random(2) < 1 ? -1 : 1) * random(PI, 2 * PI);
    this.warpRadius = random(300, 500);
  }
  
  void update() {
    if (pos.x < 0 || pos.x > width) {
      vel.x *= -1;
    }
    if (pos.y < 0 || pos.y > height) {
      vel.y *= -1;
    }
    this.pos.add(vel);
  }
  
}
