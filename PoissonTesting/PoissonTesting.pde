//import com.hamoid.*;
//import java.util.Date;
//VideoExport videoExport;
//final String sketchname = getClass().getName();
//import java.util.Arrays;

//void rec() {
//  if (frameCount == 1) {
//    Date date = new Date();
//    videoExport = new VideoExport(this, sketchname + date.getTime() + ".mp4", pg);
//    videoExport.setFrameRate(60);  
//    videoExport.startMovie();
//  }
//  videoExport.saveFrame();
//}

PoissonSampler ps = new PoissonSampler();
ArrayList<PVector> points = new ArrayList<PVector>();
Grid<PVector> grid;
Grid<Segment> segs;
int margin = 5;
PGraphics pg;

void setup() {
  size(900, 900, P3D);
  pg = createGraphics(1080, 1080, P3D);
  pg.smooth(8);
  pg.beginDraw();
  pg.background(200, 225, 255);
  pg.noStroke();
  ArrayList<PVector> vecs = ps.getPointsRect(new PVector(margin, margin), pg.width - margin * 2, pg.height - margin * 2, 30, 11);
  points.addAll(vecs);
  grid = new Grid<PVector>(pg.width / 11, pg.height / 11, pg.width, pg.height);
  segs = new Grid<Segment>(pg.width / 100, pg.height / 100, pg.width, pg.height); 
  for (PVector v : vecs) {
    grid.add(v);
  }
  pg.background(0, 0, 50); 
  pg.endDraw();
  
}

int index = 0;
boolean drawBg = true;

void draw() {
  pg.beginDraw();
  pg.strokeWeight(2);
  //pg.stroke(255);
  if (drawBg) {
    pg.background(0, 0, 50);
    pg.ellipseMode(RADIUS);
    //drawBg = false;
  }
  int perFrame = 100;
  //for (int i = 0; i < perFrame && index < points.size(); i++) {
  //  PVector p = points.get(index);
  //  pg.point(p.x, p.y);
  //  index++;
  //}
  float maxD = dist(0, 0, pg.width / 2, pg.height / 2);
  float t = radians(frameCount * 0.2);
  for (PVector p : points) {
    PVector diff = p.copy().sub(new PVector(pg.width / 2, pg.height / 2));
    float fd = pow(1 - dist(p.x, p.y, pg.width / 2, pg.height / 2) / maxD, 0.5);
    float r = 1 + 7 * pow(0.5 * (1 + sin(fd * TAU * 6 + (diff.heading() + t) * 5 + radians(frameCount * 4.5))), 2);
    //r = r * 0.5 * (1 + sin(p.x / pg.width * TAU * 3.1 + radians(frameCount * 3)));
    pg.square(p.x, p.y, r);
  }
  
  pg.endDraw();
  image(pg, 0, 0, width, height);
  //if (index == points.size()) {
  //  //pg.save("Poisson" + (new Date()).getTime() + ".png");
  //  println(index);
  //  noLoop();
  //}
  //rec();
  println(frameCount / 60);
}
