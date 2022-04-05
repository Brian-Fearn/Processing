ArrayList<ArrayList<PVector>> curvePair = new ArrayList<ArrayList<PVector>>();
PGraphics pg;
int yInc = 70;
int margin = 20;
color bgColor = color(0); 
color strokeColor = color(255, 200, 175);
import com.jogamp.opengl.*;
com.jogamp.opengl.GL3 gl;

void setup() {
  size(900, 900, P3D);
  colorMode(RGB, 255, 255, 255, 1.0);
  blendMode(DIFFERENCE);
  pg = createGraphics(1080, 1080, P3D);
  pg.smooth(8);

  pg.beginDraw();
  pg.blendMode(DIFFERENCE);
  pg.colorMode(RGB, 255, 255, 255, 1.0);
  pg.background(bgColor);
  pg.endDraw();
}

boolean save = false;
int freq = 2;

void draw() {
  background(0);
  pg.beginDraw();
  pg.translate(pg.width / 2, pg.height / 2);
  
  pg.beginPGL().enable(GL3.GL_BLEND);
  pg.beginPGL().blendFunc(GL3.GL_ONE_MINUS_DST_COLOR, GL3.GL_ZERO);
  pg.fill(255, 0, 170);
  pg.background(bgColor);
  //pg.stroke(strokeColor);
  //pg.strokeWeight(4);
  pg.noStroke();
  
  int n = 500;
  float inc = 2 * PI / n;
  float tFactor = sin(radians(frameCount * 0.3));
  float tFactor2 = sin(radians(frameCount * 0.4));
  
  curvePair = new ArrayList<ArrayList<PVector>>();
  
  ArrayList<PVector> points = new ArrayList<PVector>();
  for (int i = 0; i < n; i++) {
    float t = i * inc;
    float r = 25 + 15.0 * tFactor * cos(freq * t - radians(frameCount * 0.7));
    float x = r * cos(t);
    float y = r * sin(t);
    points.add(new PVector(x, y));
  }
  curvePair.add(points);
  
  points = new ArrayList<PVector>();
  for (int i = 0; i < n; i++) {
    float t = i * inc;
    float r = 20 + 10.0 * tFactor2 * cos(PI / 2 + freq * t + radians(frameCount * 0.7));
    float x = r * cos(t + PI / 2);
    float y = r * sin(t + PI / 2);
    points.add(new PVector(x, y));
  }
  curvePair.add(points);

  pg.fill(255);
  for (int m = 1; m < 62; m += 3) {
    
    for (ArrayList<PVector> c : curvePair) {
      pg.beginShape();
      for (PVector p : c) {
        pg.vertex(p.x * m, p.y * m);
      }
      pg.endShape(CLOSE);
    }
  }
  if (frameCount % 60 == 0) {
    //pg.save("output" + int(random(1000000000)) + ".png");
    save = false;
  }
  pg.endDraw();
 
  image(pg, 0, 0, width, height);
  //if (frameCount % 60 == 0) {
  //  pg.save("output" + int(random(1000000000)) + ".png");
  //  save = false;
  //}
  println(frameCount / 60 + " " + frameRate);
}

void keyPressed() {
  if (keyCode == UP) {
    freq++;
  }
  if (keyCode == DOWN) {
    freq--;
  }
}

void mouseClicked() {
  save = true;
}
