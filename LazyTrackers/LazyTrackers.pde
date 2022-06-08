ArrayList<Watcher> watchers = new ArrayList<Watcher>();
int n = 8;
float turnRate = 0.02;

void setup() {
  size(900, 900, P2D);
  smooth(8);
  ellipseMode(CENTER);
  float inc = 1.0 * width / n;
  for (int yi = 0; yi < n; yi++) {
    for (int xi = 0; xi < n; xi++) {
      float x = xi * inc + inc / 2;
      float y = yi * inc + inc / 2;
      watchers.add(new Watcher(new PVector(x, y), inc / 5));
    }
  }
}

float currHeading = 0.0;

void draw() {
  background(0, 25, 50);
  stroke(255, 225, 200);
  fill(25, 75, 100);
  strokeWeight(20.0 / n);
  for (Watcher w : watchers) {
    w.update();
    w.show();
  }
  stroke(255, 100, 75);
  fill(255, 100, 75);
  circle(mouseX, mouseY, 20);
  println(frameRate);
}

class Watcher {
  
  PVector pos;
  float currHeading;
  float dim;
  
  Watcher(PVector pos, float dim) {
    this.pos = pos;
    this.dim = dim;
  }
  
  void update() {
    PVector m = new PVector(mouseX, mouseY);
    PVector diff = m.copy().sub(pos);
    float h = diff.heading();
    float heading = h > 0 ? h : 2 * PI + h;
    // make sure Watcher always turns using the geometrically "shortest" direction (cw or ccw)
    if (heading > 3 * PI / 2 && currHeading < PI / 2) {
      float goalHeading = heading - 2 * PI;
      currHeading = lerp(currHeading, goalHeading, turnRate);
      currHeading = currHeading < 0 ? 2 * PI + currHeading : currHeading;
    } else if (heading < PI / 2 && currHeading > 3 * PI / 2) {
      float goalHeading = 2 * PI + heading;
      currHeading = lerp(currHeading, goalHeading, turnRate) % (2 * PI);
    } else { 
      currHeading = lerp(currHeading, heading, turnRate);
    }
  }
  
  void show() {
    push();
    translate(pos.x, pos.y);
    rotate(currHeading);
    triangle(-dim, -dim, -dim, dim, dim * 2, 0);
    pop();
  }
  
}
