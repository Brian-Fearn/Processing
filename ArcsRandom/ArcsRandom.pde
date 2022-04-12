float pixInc = 2;
ArrayList<Arc> arcs = new ArrayList<Arc>();
int side = 3;
int ySide = 3;
int margin = 25;
float maxR;
Mover m;
PGraphics pg;

void setup() {
  size(900, 900, P3D);
  pg = createGraphics(1080, 1080, P3D);
  pg.smooth(8);
  pg.beginDraw();
  pg.noFill();
  pg.endDraw();
  m = new Mover(new PVector(random(pg.width), random(pg.height)), new PVector(random(2, 4), random(2, 4))); 
  float inc = (pg.height - margin * 2) / ySide;
  maxR = 0.975 * inc / 2;
  for (int i = 0; i < ySide; i++) {
    float y = margin + inc / 2 + inc * i;
    for (int j = 0; j < side; j++) {
      float x = margin + inc / 2 + inc * j;
      float arcStart = x / pg.width * 2 * PI;
      for (float r = 0.975 * inc / 2; r > 8; r -= 8) {
        float arcLen = random(PI / 2, 3 * PI / 2);
        Arc a = new Arc(x, y, r, arcStart + random(PI / 2), arcLen);
        arcs.add(a);
      }
    }
  }
}

void draw() {
  pg.beginDraw();
  pg.background(0);
  pg.stroke(255, 225, 200);
  for (Arc a : arcs) {
    a.update();
    a.show();
  }
  //pg.save("output" + int(random(10000000)) + ".png");
  pg.endDraw();
  image(pg, 0, 0, width, height);
  println(frameRate);
  //noLoop();
}

class Arc {
  
  PVector c;
  float r, start, end, arcLen, len, currStart, currArcLen;
  float xFactor, yFactor;
  
  Arc(float x, float y, float r, float start, float arcLen) {
    this.c = new PVector(x, y);
    this.r = r;
    this.start = start;
    this.arcLen = arcLen;
    this.end = start + arcLen;
  }
  
  void update() {
    //xFactor = 1.0 * mouseX / width;
    currStart = start + 2 * PI * xFactor;
    currArcLen = arcLen + 2 * PI * yFactor;
  }
  
  void show() {
    int n = int(currArcLen * r / pixInc);
    float inc = currArcLen / n;
    pg.beginShape();
    for (int i = 0; i < n; i++) {
      float lenFactor = (1 - abs(1.0 * i - n / 2) / (n / 2));
      lenFactor = pow(lenFactor, 1.0 / 2);
      float weight = 0.5 + 5.0 * lenFactor;
      pg.strokeWeight(weight);
      float t = currStart + i * inc;
      float x = c.x + r * cos(t);
      float y = c.y + r * sin(t);
      pg.vertex(x, y);
    }
    pg.endShape();
  }
  
}

class Mover {
  
  PVector pos;
  PVector vel;
  
  Mover(PVector pos, PVector vel) {
    this.pos = pos;
    this.vel = vel;
  }
  
  void move() {
    pos.add(vel);
    if (pos.x < 0 || pos.x > width) {
      vel.x *= -1;
    }
    if (pos.y < 0 || pos.y > height) {
      vel.y *= -1;
    }
  }
  
  void show() {
    pg.stroke(255, 0, 0);
    pg.strokeWeight(20);
    pg.point(pos.x, pos.y);
  }
  
}
