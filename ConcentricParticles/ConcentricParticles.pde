Attractor att = new Attractor(new PVector(0, 0));
color bgColor;
color strokeColor;
ArrayList<ArrayList<Particle>> cPoints = new ArrayList<ArrayList<Particle>>();
ArrayList<Particle> points = new ArrayList<Particle>();
int PARTICLE_MODE = 0;
int DEFORM_MODE = 1;
int mode = PARTICLE_MODE;
int dir = 1;
boolean reform = true;
int margin = 25;
float maxD;
PGraphics pg;

void setup() {
  size(900, 900, P3D);
  colorMode(HSB, 360, 100, 100, 100);
  pg = createGraphics(1080, 1080, P3D);
  pg.smooth(8);
  pg.beginDraw();
  pg.colorMode(HSB, 360, 100, 100, 100);
  pg.strokeWeight(mode == PARTICLE_MODE ? 3 : 2);
  bgColor = color(250, 100, 10);
  pg.blendMode(ADD);
  cursor(ARROW);
  pg.background(bgColor);
  pg.noFill();
  pg.endDraw();
  int pixPerSegment = 5;
  maxD = sqrt(pg.width * pg.width + pg.height * pg.height);
  float baseHue = 200; // random(0, 280);
  for (int r = 440; r >= 10; r -= 10) {
    ArrayList<Particle> list = circlePoints(pg.width / 2, pg.height / 2, r, pixPerSegment);
    for (Particle p : list) {
      p.c = color(baseHue + 80.0 * r / 440, 60, 100); //85, 100);
    }
    cPoints.add(list);
    points.addAll(list);
  }
}

void draw() {
  PVector mouse = new PVector(map(mouseX, 0, width, 0, pg.width), map(mouseY, 0, height, 0, pg.height));
  att.pos = mouse;
  int button = 0;
  if (mousePressed) {
    button = mouseButton;
  }
  pg.beginDraw();
  pg.background(bgColor);
  
  if (mode == PARTICLE_MODE) {
    if (mousePressed && mouseButton == LEFT) {
      button = 1;
    } else if (mousePressed && mouseButton == RIGHT) {
      button = -1;
    }
    for (Particle p : points) {
      PVector f = att.calcForce(p, button);
      f.mult(10);
      p.acc.add(f);
      p.update();
      pg.stroke(p.c);
      pg.point(p.x, p.y);
    }
  } else if (mode == DEFORM_MODE) {
    switch(button) {
      case LEFT:
        deform(points, true);
        break;
      case RIGHT:
        deform(points, false);
        break;
      case CENTER:
        deformRadial(points);
        break;
      default:
        break;
    }
    for (Particle p : points) {
      p.update();
      pg.stroke(p.c);
      pg.point(p.x, p.y);
    }
  }
  
  pg.fill(0, 100, 100, 100);
  pg.noStroke();
  pg.circle(mouse.x, mouse.y, 6);
  pg.noFill();
  pg.endDraw();
  image(pg, 0, 0, width, height);
  //println(frameCount / 60);
  println(frameRate);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      dir *= -1;
    }
    if (keyCode == DOWN) {
      mode = 1 - mode;
    }
  }
}

void deform(ArrayList<Particle> set, boolean attract) {
  Particle c = new Particle(map(mouseX, 0, width, 0, pg.width), map(mouseY, 0, height, 0, pg.height)); // new Particle(width / 2, height / 2);
  float maxDiagonal = getMaxDist(c, set);
  for (Particle p : set) {
    float d = dist(p.x, p.y, c.x, c.y);
    float dFactor = attract ? 1 - 0.25 * pow(1 - d / maxDiagonal, 4) : 1 + 0.25 * pow(1 - d / maxDiagonal, 4);
    Particle temp = p.copy();
    temp.sub(c);
    temp.mult(dFactor);
    temp.add(c);
    p.x = temp.x;
    p.y = temp.y;
  }
}

void deformRadial(ArrayList<Particle> set) {
  Particle c = new Particle(map(mouseX, 0, width, 0, pg.width), map(mouseY, 0, height, 0, pg.height));
  float maxDiagonal = getMaxDist(c, set);
  for (Particle p : set) {
    float d = dist(p.x, p.y, c.x, c.y);
    float dFactor = pow(1 - d / maxDiagonal, 2.5);
    rotateWithRespectTo(p, c, dir * dFactor * PI / 16);
  }
}

float getMaxDist(Particle p, ArrayList<Particle> set) {
  if (set.isEmpty()) {
    return 0;
  }
  float maxDistSq = Float.MIN_VALUE;
  for (Particle v : set) {
    float dSq = v.copy().sub(p).magSq();
    if (dSq > maxDistSq) {
      maxDistSq = dSq;
    }
  }
  return sqrt(maxDistSq);
}

void rotateWithRespectTo(Particle p, Particle v, float angle) {
  p.sub(v);
  p.rotate(angle);
  p.add(v);
}

void rotateWithRespectTo(PVector p, PVector v, float angle) {
  p.sub(v);
  p.rotate(angle);
  p.add(v);
}

ArrayList<Particle> linePoints(float x1, float y1, float x2, float y2, int pixPerSegment) {
  float d = dist(x1, y1, x2, y2);
  Particle a = new Particle(x1, y1);
  Particle b = new Particle(x2, y2);
  Particle diff = (Particle) b.copy().sub(a).normalize().mult(pixPerSegment);
  
  int n = int(d / pixPerSegment);
  ArrayList<Particle> points = new ArrayList<Particle>();
  for (int i = 0; i <= n; i++) {
    points.add((Particle) a.copy().add(diff.copy().mult(i)));
  }
  return points;
}

ArrayList<Particle> circlePoints(float x, float y, float r, int pixPerSegment) {
  float c = 2 * PI * r;
  int n = int(c / pixPerSegment);
  float inc = 2 * PI / n;
  
  ArrayList<Particle> points = new ArrayList<Particle>();
  for (int i = 0; i < n; i++) {
    float angle = i * inc;
    points.add(new Particle(x + r * cos(angle), y + r * sin(angle)));
  }
  return points;
}

class Particle extends PVector {
  
  PVector init;
  PVector v;
  color c;
  
  PVector pos;
  PVector vel;  
  PVector acc;
  
  Particle(float x, float y) {
    this.pos = new PVector(x, y);
    this.vel = new PVector(0, 0);
    this.acc = new PVector(0, 0);
    this.x = x;
    this.y = y;
    this.init = new PVector(x, y);
    this.v = new PVector(0, 0);
  }
  
  void update() {
    if (mode == PARTICLE_MODE) {
      vel.add(acc);
      vel.limit(5);
      checkBounds();
      x += vel.x;
      y += vel.y;
      this.vel.mult(0.997);
      acc.mult(0);
    }
    if (reform) {
      Particle curr = new Particle(x, y);
      curr.lerp(init, 0.005);
      this.x = curr.x;
      this.y = curr.y;
    }
  }
  
  void checkBounds() {
    if (x < margin || x > pg.width - margin) {
      vel.x *= -1;
    }
    if (y < margin || y > pg.height - margin) {
      vel.y *= -1;
    }
  }
  
  Particle copy() {
    Particle p = new Particle(x, y);
    p.init = this.init.copy();
    return p;
  }
  
}

class Attractor {
  
  PVector pos;
  boolean active;
  
  Attractor(PVector pos) {
    this.pos = pos;
    active = false;
  }
  
  PVector calcForce(PVector otherPos, int charge) {
    if (charge == 0) {
      return new PVector(0, 0);
    }
    PVector vec = charge == 1 ? pos.copy().sub(otherPos) : otherPos.copy().sub(pos);
    float magSq = vec.mag();
    return vec.mult(500.0 / magSq).limit(5);
  }
  
  void show() {
    fill(active ? color(0, 255, 0) : color(255, 0, 0));
    ellipse(pos.x, pos.y, 30, 30);
  }
  
}
