import java.util.Date;

PGraphics pg;

int margin = 20;
int pMargin = 375;
int initBranchCount = 6;
float initWeight = 5.0;
float spawnProbability = 0.08;
boolean decreaseSegLength, decreaseSegWeight;
ArrayList<Branch> branches = new ArrayList<Branch>();
ArrayList<Segment> allSegs = new ArrayList<Segment>();
Grid<Segment> grid;
float masterHue = 100;
float segLengthDecreaseRate = 0.004;
float masterBright;
float initSegLength = 10;
float childBranchWeightDecreaseRate = 0.05;
float childBranchSegmentLengthDecreaseRate = 0.1;
float branchWeightDecreaseRate = 0.02;
float hueVariationRange = 50;
float masterSat;
float hBaseLow, hBaseHigh, newHeadingRangeLow, newHeadingRangeHigh;
boolean quantizeAngles, constantHeadingChange, varyColor;
float headingChangeConstant = PI / 80;
float quantizedBaseAngle = PI / 2;
color bgColor;
boolean save;

interface Mode {
  int Branches = 0;
  int Nerves = 1;
  int Spiral = 2;
  int Quantized = 3;
}

void setup() {
  size(1600, 900, P2D);
  pg = createGraphics(1920, 1080, P2D);
  colorMode(HSB, 360, 100, 100, 100);
  cursor(ARROW);
  pg.smooth(8);
  pg.beginDraw();
  pg.colorMode(HSB, 360, 100, 100, 100);
  pg.endDraw();
  grid = new Grid<Segment>(pg.width / 11, pg.height / 11, pg.width, pg.height);
  setGlobals(Mode.Spiral);
}

// control general "look" and behavior
void setGlobals(int mode) {
  switch(mode) {
    case Mode.Branches:
      masterHue = 100;
      hueVariationRange = 50;
      masterBright = 100;
      masterSat = 100;
      hBaseLow = 0;
      hBaseHigh = PI / 10;
      initBranchCount = 3;
      initSegLength = 8;
      spawnProbability = 0.06;
      newHeadingRangeLow = -PI / 20;
      newHeadingRangeHigh = PI / 20;
      decreaseSegLength = true;
      decreaseSegWeight = true;
      varyColor = true;
      bgColor = color(0);
      break;
    case Mode.Nerves:
      masterHue = 200;
      masterBright = 100;
      masterSat = 80;
      hBaseLow = -PI;
      hBaseHigh = PI;
      segLengthDecreaseRate = 0.015;
      hueVariationRange = 30;
      newHeadingRangeLow = -PI / 6;
      newHeadingRangeHigh = PI / 6;
      decreaseSegLength = true;
      decreaseSegWeight = true;
      varyColor = true;
      bgColor = color(0);
      break;
    case Mode.Spiral:
      masterHue = 50;
      masterBright = 100;
      masterSat = 60;
      hBaseLow = 0;
      hBaseHigh = PI;
      initBranchCount = 5;
      initWeight = 3;
      spawnProbability = 0.05;
      decreaseSegLength = false;
      decreaseSegWeight = false;
      headingChangeConstant = PI / 45;
      childBranchWeightDecreaseRate = 0.1;
      newHeadingRangeLow = 0;
      newHeadingRangeHigh = PI / 8;
      constantHeadingChange = true;
      bgColor = color(0);
      varyColor = false;
      break;
    case Mode.Quantized:
      masterHue = 0;
      masterBright = 0;
      masterSat = 0;
      spawnProbability = 0.035;
      decreaseSegLength = false;
      decreaseSegWeight = false;
      quantizeAngles = true;
      initWeight = 2;
      bgColor = color(0, 0, 100);
      varyColor = false;
      break;
  }
}

void mouseClicked() {
  if (mouseButton == LEFT) {
    float x = map(mouseX, 0, width, 0, pg.width);
    float y = map(mouseY, 0, height, 0, pg.height);
    float hBase = random(2 * PI);
    for (int i = 0; i <= initBranchCount; i++) {
      float h = int(random(4)) * PI / 2;
      h = hBase + random(hBaseLow, hBaseHigh);
      h = random(2 * PI);
      Branch br = new Branch(new PVector(x, y), initSegLength, h, initWeight); 
      branches.add(br);
    }
  } else if (mouseButton == RIGHT) {
    save = true;
  }
}

void draw() {
  pg.beginDraw();
  if (frameCount == 1) {
    pg.background(bgColor);
  }
  ArrayList<Branch> toAdd = new ArrayList<Branch>();
  for (Branch b : branches) {
    if (b.live) {
      b.grow();
      Branch newB = b.spawn();
      if (newB != null) {
        toAdd.add(newB);
      }
    }
    
  }
  branches.addAll(toAdd);
  for (Branch b : branches) {
    b.show();
  }
  if (save) {
    pg.save("BranchingSegments" + (new Date()).getTime() + ".png");
    save = false;
  }
  pg.endDraw();
  image(pg, 0, 0, width, height);
  if (frameCount % 60 == 0) {
    println(frameCount / 60 + " --- " + frameRate);  
  }
}

float getHeading(float curr) {
  if (quantizeAngles) {
    return curr;
  }
  if (constantHeadingChange) {
    return curr + headingChangeConstant;
  }
  float h = curr;
  h = curr + random(newHeadingRangeLow, newHeadingRangeHigh);
  return h;
}

class Branch {
  
  ArrayList<Segment> segments;
  PVector pos;
  float heading;
  float balance;
  float segLength;
  boolean live;
  float weight;
  color c;
  float baseHue;
  float hue;
  
  Branch(PVector pos, float segLength, float heading, float weight) {
    this.pos = pos;
    this.segLength = segLength;
    this.heading = heading;
    this.segments = new ArrayList<Segment>();
    this.weight = weight;
    this.live = true;
    this.balance = 0;
    this.baseHue = masterHue;
    this.hue = baseHue;
  }
  
  void grow() {
    if (segLength < 1.5 || weight < 1 || outOfBounds(pos, margin, pg.width - margin, margin, pg.height - margin)) {
      live = false;
      return;
    }
    heading = getHeading(heading);
    PVector dir = PVector.fromAngle(heading).mult(segLength);
    PVector newPos = pos.copy().add(dir);
    if (decreaseSegLength) {
      segLength *= (1 - segLengthDecreaseRate);
    }
    if (decreaseSegWeight && weight > 1) {
      weight *= (1 - branchWeightDecreaseRate);
    }
    Segment s = new Segment(pos, newPos);
    ArrayList<Segment> closeSegs = grid.findCloseOccupants(newPos);
    if (!s.intersectsAny(closeSegs)) {
      s.weight = this.weight;
      segments.add(s);
      allSegs.add(s);
      grid.add(s, newPos.x, newPos.y);
      pos = newPos.copy();
    } else {
      if (random(30) < 1) {
        live = false;
      }
    }
    hue = varyColor ? baseHue + hueVariationRange * sin(radians(frameCount * 0.3)) : hue;
    this.c = color(hue, masterSat, masterBright);
  }
  
  void show() {
    for (Segment s : segments) {
      if (s.isNew) {
        s.isNew = false;
        pg.stroke(c);
        pg.strokeWeight(s.weight);
        pg.line(s.a.x, s.a.y, s.b.x, s.b.y);
      }
    }
  }
  
  Branch spawn() {
    if (random(1) < spawnProbability) {
      PVector childPos = pos.copy();
      float headingAdd = random(balance + 0.9, 1.1 - balance);
      this.balance = abs(1 - headingAdd);
      float childHeading = quantizeAngles ? heading + quantizedBaseAngle : heading * headingAdd;
      float childSegLength = segLength * (1 - childBranchSegmentLengthDecreaseRate);
      Branch newBr = new Branch(childPos, childSegLength, childHeading, this.weight * (1 - childBranchWeightDecreaseRate));
      newBr.c = c;
      return newBr;
    }
    return null;
  }
  
}

class Segment {
  
  PVector a, b;
  boolean isNew;
  float weight;
  
  Segment(PVector a, PVector b) {
    this.a = a;
    this.b = b;
    this.isNew = true;
  }
  
  boolean intersects(PVector c, PVector d) {
    return intersect(a, b, c, d);
  }
  
  boolean intersectsAny(ArrayList<Segment> others) {
    for (Segment s : others) {
      if (s.intersects(a, b)) {
        return true;
      }
    }
    return false;
  }
  
}
