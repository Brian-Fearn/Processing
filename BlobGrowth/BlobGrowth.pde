import com.hamoid.*;
import java.util.Date;
VideoExport videoExport;
final String sketchname = getClass().getName();

void rec() {
  if (frameCount == 1) {
    Date date = new Date();
    videoExport = new VideoExport(this, sketchname + date.getTime() + ".mp4", pg);
    videoExport.setFrameRate(60);  
    videoExport.startMovie();
  }
  videoExport.saveFrame();
}

int n = 10;
ArrayList<Particle> particles = new ArrayList<Particle>();
float redBase = 255;
float greenBase = 225;
float blueBase = 100;
float alphaBase = 25;
PGraphics pg;

void setup() {
  size(900, 900, P2D);
  pg = createGraphics(1080, 1080, P2D);
  pg.smooth(8);
  pg.beginDraw();
  pg.ellipseMode(RADIUS);
  
  pg.noStroke();
  pg.endDraw();
  for (int i = 0; i < n; i++) {
    float th = i * 2 * PI / n;
    particles.add(new Particle(PVector.fromAngle(th).mult(30).add(new PVector(pg.width / 2, pg.height / 2)), PVector.fromAngle(th)));
  }
}

void draw() {
  pg.beginDraw();
  if (frameCount == 1) {
    pg.background(0, 15, 35);
  }
  for (Particle p : particles) {
    p.update();
    p.show();
  }
  pg.endDraw();
  image(pg, 0, 0, width, height);
  rec();
  println(frameCount / 60);
}

class Particle {
  
  PVector p, v;
  float r;
  
  Particle(PVector p, PVector v) {
    this.p = p;
    this.v = v;
  }
  
  void update() {
    this.r = 2 + 15 * 0.5 * (1 + cos(radians(frameCount)));
    float time = sin(radians(frameCount * 0.5));
    float time2 = radians(frameCount * 0.55);
    v.rotate(PI / 300 + time2 * time * PI / 1050);
    p.add(v);
  }
  
  void show() {
    float f = 0.5 * (1 + cos(radians(frameCount * 2)));
    float f2 = 0.5 * (1 + cos(PI / 2 + radians(frameCount * 0.75)));
    pg.fill(f2 * redBase, f * greenBase, blueBase, alphaBase);
    pg.circle(p.x, p.y, r);
  }
  
}
