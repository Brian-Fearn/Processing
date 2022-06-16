void setup() {
  size(900, 900, P3D);
  smooth(8);
}

void draw() {
  background(100, 125, 155);
  fill(225, 200, 255);
  stroke(75, 0, 100);
  strokeWeight(3);
  ArrayList<PVector> points = new ArrayList<PVector>();
  int n = 20;
  PVector o = new PVector(width / 2, height / 2);  
  for (int i = 0; i < n; i++) {
    float th = i * 2 * PI / n + 2 * PI / n * (0.5 - noise((i + 1) * 1000, frameCount * 0.01)) + radians(frameCount * 0.75);
    float add = 100 * noise((i + 1) * 0.01);
    float x = (250 + add) * cos(th); 
    float y = (100 + add) * sin(th);
    PVector p = new PVector(x, y).add(o);
    points.add(p);
  }
  boolean invert = false;
  beginShape();
  for (int i = 0; i < n; i++) {
    PVector a = points.get(i);
    PVector b = points.get((i + 1) % points.size());
    arcConnection(a, b, invert);
    //invert = !invert;
  }
  endShape();
  println(frameRate);
}

float fract(float x) {
  return x - floor(x);
}

void arcConnection(PVector a, PVector b, boolean invert) {
  PVector diff = b.copy().sub(a);
  PVector t = diff.copy().normalize();
  PVector norm = new PVector(t.y, -t.x);
  float m = diff.mag();
  int n = int(m);
  for (float i = 0; i <= n; i++) {
    float x = 1.0 * i / n;
    PVector l = PVector.lerp(a, b, x);
    float f = (invert ? -1 : 1) * sqrt(1-(2*x-1)*(2*x-1)) / 2;
    l.add(norm.copy().mult(f * m));
    vertex(l.x, l.y);
  }
}
