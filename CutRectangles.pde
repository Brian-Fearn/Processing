import java.util.Date;

/* Written by Brian Fearn, 2022-03-09. */
/* Feel free to use, edit, or deploy this code for any purpose, whether personal, educational, or commercial. */
/* Usage: Click through to keep dividing. Press ENTER to apply style. Press 's' to save as PNG. */

ArrayList<Rect> rects = new ArrayList<Rect>();
int margin = 10;
int rectPadding = 2;
int minRectWidth = 40;
int minRectHeight = 40;
color [] justBlack = new color [] { color(0) };
color [] redToGreen = new color [] { color(255, 0, 0), color(255, 125, 0), color(125, 255, 0), color(255, 255, 0) };
color [] blueAndYellow = new color [] { color(0, 87, 183), color(255, 215, 0) };
color [] cool = new color [] { color(0, 0, 255), color(150, 50, 255), color(0, 125, 255), color(200, 200, 255) };
color offWhite = color(255, 255, 200);
color black = color(0);
color white = color(255);
color darkBlue = color(0, 0, 50);

final int DOT_DENSITY = 10;
final int DOT_ALPHA = 55;
final float MIN_CUT_PROPORTION = 0.35;
final float MAX_CUT_PROPORTION = 0.65;
color [] dotColors = blueAndYellow;
color backgroundColor = white;

void setup() {
  size(900, 900, P3D);
  smooth(8);
  Rect r = new Rect(margin, margin, width - margin * 2, height - margin * 2);
  rects.add(r);
  background(255, 255, 200);
  strokeWeight(1);
}

void keyPressed() {
  if (keyCode == ENTER) {
    background(backgroundColor);
    fillAll();
  }
  if (key == 's') {
    saveFrame("CutRectangles" + (new Date()).getTime() + ".png");
  }
}

void fillAll() {
  for (Rect r : rects) {
    stroke(dotColors[int(random(dotColors.length))], DOT_ALPHA);
    boolean vertical = r.h > r.w;
    boolean dir = random(2) < 1;
    if (vertical) {
      for (int i = 0; i < DOT_DENSITY * r.h * r.w; i++) {
        float dist = r.h - rectPadding * 2;
        float x = random(r.x + rectPadding, r.x + r.w - rectPadding * 2);
        float randomDist = random(1);
        float thisDist = randomDist * dist;
        boolean show = random(1) < randomDist * randomDist;
        if ((dir && show) || (!dir && !show)) {
          point(x, r.y + thisDist);
        }
      }
    } else {
      for (int i = 0; i < DOT_DENSITY * r.h * r.w; i++) {
        float dist = r.w - rectPadding * 2;
        float y = random(r.y + rectPadding, r.y + r.h - rectPadding * 2);
        float randomDist = random(1);
        float thisDist = randomDist * dist;
        boolean show = random(1) < randomDist * randomDist;
        if ((dir && show) || (!dir && !show)) {
          point(r.x + thisDist, y);
        }
      }
    }
  }
}

void mouseClicked() {
  background(255, 255, 200);
  fill(255, 100);
  ArrayList<Rect> toAdd = new ArrayList<Rect>();
  ArrayList<Rect> toRemove = new ArrayList<Rect>();
  for (Rect r : rects) {
    ArrayList<Rect> cuts = r.randomCut();
    if (!cuts.isEmpty()) {
      toRemove.add(r);
    }
    toAdd.addAll(cuts);
  }
  rects.removeAll(toRemove);
  rects.addAll(toAdd);
  for (Rect r : rects) {
    r.show();
  }
}

void draw() {
  stroke(0);
  
}

class Rect {
  
  int x, y, w, h;
  color fillColor;
  
  Rect(int x, int y, int w, int h) {
    this.x = x; this.y = y; this.w = w; this.h = h;
    this.fillColor = color(255, 100);
  }
  
  ArrayList<Rect> randomCut() {
    ArrayList<Rect> newRects = new ArrayList<Rect>();
    boolean vertical = random(2) < 1;
    Rect rectA = null;
    Rect rectB = null;
    int cut;
    
    if (vertical) {
      if (w < minRectWidth) {
        return new ArrayList<Rect>();  
      }
      cut = int(random(x + w * MIN_CUT_PROPORTION, x + w * MAX_CUT_PROPORTION)); // magic numbers to keep rectangles from being too thin
      rectA = new Rect(x, y, cut - x, h);
      rectB = new Rect(cut, y, x + w - cut, h);
    } else {
      if (h < minRectHeight) { 
        return new ArrayList<Rect>();
      };
      cut = int(random(y + h * MIN_CUT_PROPORTION, y + h * MAX_CUT_PROPORTION));
      rectA = new Rect(x, y, w, cut - y);
      rectB = new Rect(x, cut, w, y + h - cut);
    }
    newRects.add(rectA);
    newRects.add(rectB);
    return newRects;
  }
  
  void show() {
    fill(fillColor);
    rect(x + rectPadding, y + rectPadding, w - rectPadding * 2, h - rectPadding * 2);
  }
}
