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

import java.util.Date;

// USAGE NOTES
// click to save
// change colors by altering the show() method of Particle class
// change sweep direction of particles by altering the getVelocity() and initVelocity() methods of Particle class

boolean save = false;
int regionCount = 20;
float scaleNoiseX = 0.002;
float scaleNoiseY = 0.002;
int n = 4000;
ArrayList<Particle> particles = new ArrayList<Particle>();
PGraphics pg;

void setup() {
  size(900, 900, P2D);
  pg = createGraphics(1080, 1080, P2D);
  pg.smooth(8);
  colorMode(HSB, 360, 100, 100, 100);
  pg.beginDraw();
  pg.colorMode(HSB, 360, 100, 100, 100);
  pg.blendMode(ADD);
  pg.background(0);
  pg.endDraw();
  for (int i = 0; i < n; i++) {
    particles.add(new Particle(new PVector(random(pg.width), random(pg.height))));
  }
}

void draw() {
  pg.beginDraw();
  if (frameCount == 1) {
    pg.background(0);
  }
  for (Particle p : particles) {
    p.update();
    p.show();
  }
  pg.endDraw();
  if (save) {
    save = false;
    pg.save(getClass().getName() + (new Date()).getTime() + ".png");
  }
  image(pg, 0, 0, width, height);
  println(frameRate);
}

void mouseClicked() {
  save = true;
}

int getRegion(float x, float y) {
  return int(regionCount * noise(x * scaleNoiseX, y * scaleNoiseY));
}

class Particle {
  
  PVector pos, vel, last;
  int region;
  
  Particle(PVector pos) {
    this.pos = pos;
    this.last = pos.copy();
    this.region = getRegion(pos.x, pos.y);
    initVelocity();
  }
  
  void update() {
    last = pos.copy();
    pos.add(getVelocity());
    if (outOfBounds()) {
      this.reset();
      return;
    }
  }
  
  PVector getVelocity() {
    return vel;
    //return PVector.fromAngle(PI / 2 + PI * 0.5 * (1 + sin(map(pos.x, 0, pg.width, 0, 4 * PI))));
    //return PVector.fromAngle(radians(frameCount * 0.3) % (PI / 2));
    //return PVector.fromAngle(PI / 3 + PI / 4 * sin(radians(frameCount * 3)));
    //return PVector.fromAngle(4 * PI / 3);
  }
  
  void initVelocity() {
    this.vel = PVector.fromAngle(1.0 * region / regionCount * 2 * PI).mult(0.5);
    //this.vel = pos.copy().sub(new PVector(pg.width / 2, pg.height / 2)).normalize();
  }
  
  void reset() {
    this.pos = new PVector(random(pg.width), random(pg.height));
    this.last = pos.copy();
    this.region = getRegion(pos.x, pos.y);
    initVelocity();
  }
  
  boolean outOfBounds() {
    return this.region != getRegion(pos.x, pos.y) || pos.x < 0 || pos.x > pg.width || pos.y < 0 || pos.y > pg.height;
  }
  
  void show() {
    color ca = color(50, 50, 100, 3);
    color cb = color(225, 50, 100, 3);
    //pg.stroke(lerpColor(ca, cb, 1.0 * region / regionCount));
    //pg.stroke(40, 70, 100, 3);
    //pg.stroke(200 + 60.0 * region / regionCount, 85, 100, 4);
    pg.stroke((720.0 * region / regionCount) % 360.0, 60, 100, 4);
    pg.strokeWeight(random(1, 2.5));
    pg.line(pos.x, pos.y, last.x, last.y);
  }
  
}
