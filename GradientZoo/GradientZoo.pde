import java.util.Date;

void setup() {
  size(900, 900, P2D);
  background(255, 225, 200);
  smooth(8);
  stroke(0, 30);
}

void draw() {
  //drawCenteredGradientCircles();
  //drawLinearGradientCircles();
  //drawGradientRings();
  //drawGradientStrips();
  //drawOffsetGradientSquares();
  //drawGradientWaves();
  drawCenteredGradientSquares();
}

void mouseClicked() {
  saveFrame("GradientZoo" + (new Date()).getTime() + ".png");
}

void drawCenteredGradientCircles() {
  int perSide = 3;
  int inc = width / perSide;
  int pointsPerFrame = 500;
  float r = inc / 2.1;
  stroke(0, 30);
  strokeWeight(1);
  for (int yi = 0; yi < perSide; yi++) {
    for (int xi = 0; xi < perSide; xi++) {
      float x = inc * xi + inc / 2;
      float y = inc * yi + inc / 2;
      int index = xi + yi * perSide;
      for (int i = 0; i < pointsPerFrame; i++) {
        PVector p = randomInCircle(x, y, r, 0.1 + index / 12.0, 0.02);
        point(p.x, p.y);
      }
    }
  }
}

void drawLinearGradientCircles() {
  int perSide = 3;
  int inc = width / perSide;
  int pointsPerFrame = 500;
  float r = inc / 2.1;
  stroke(0, 30);
  float minWeight = 0.5;
  for (int yi = 0; yi < perSide; yi++) {
    for (int xi = 0; xi < perSide; xi++) {
      float x = inc * xi + inc / 2;
      float y = inc * yi + inc / 2;
      int index = xi + yi * perSide;
      for (int i = 0; i < pointsPerFrame; i++) {
        PVector p = randomInCircle(x, y, r, 0.5, 0.00);
        float verticalDistanceFactor = pow(abs(y + r - p.y) / (r * 2), 3.0 * (index + 1.0) / (perSide * perSide));
        strokeWeight(minWeight + 2.0 * verticalDistanceFactor);
        point(p.x, p.y);
      }
    }
  }
}

void drawGradientRings() {
  int rings = 10;
  int margin = 5;
  float minRadius = width / 30;
  float maxRadius = width / 2 - margin * 2; 
  float radiusRange = maxRadius - minRadius;
  float perRing = radiusRange / rings;
  for (int i = 0; i < rings; i++) {
    float baseRadius = minRadius + perRing * i;
    float thisMaxRadius = baseRadius + perRing;
    float ringArea = PI * thisMaxRadius * thisMaxRadius - PI * baseRadius * baseRadius; // scale number of points to ring area (bigger rings need more points)
    int perFrame = int(ringArea / 50); 
    for (int points = 0; points < perFrame; points++) {
      float initAngle = 4 * i * 2 * PI / rings;
      float rand = random(1);
      float r = minRadius + perRing * i + perRing * rand;
      float angle = initAngle + 2 * PI * sqrt(random(1));
      PVector p = PVector.fromAngle(angle).mult(r).add(new PVector(width / 2, height / 2));
      point(p.x, p.y);
    }
  }
}

void drawGradientStrips() {
  int strips = 10;
  int margin = 25;
  int inc = (width - margin * 2) / strips;
  int perFrame = 1000;
  for (int xi = 0; xi < strips; xi++) {
    float x = margin + xi * inc;
    float x2 = x + inc;
    boolean upsideDown = xi % 2 == 0;
    for (int points = 0; points < perFrame; points++) {
      float rand = pow(random(1), 0.1 + xi * 0.5 / strips); // sharper falloff toward the left
      float y = upsideDown 
        ? margin + rand * (height - margin * 2) 
        : height - margin - rand * (height - margin * 2);
      PVector p = new PVector(random(x, x2), y);
      strokeWeight(random(2));
      point(p.x, p.y);
    }
  }
}

void drawGradientWaves() {
  int margin = 10;
  int waves = 6;
  stroke(0, 30);
  noFill();
  float initAngle = 0.0;
  float angleInc = 1.3;
  float freq = 0.7;
  float waveAmp = (height - margin * 2.0) / waves;
  // it would be way more efficient to precalculate the sine waves for each x value
  // but I wanted to keep everything in one draw method
  for (int waveCount = 0; waveCount < waves - 1; waveCount++) {
    float yBase = margin + waveCount * waveAmp;
    float yBase2 = margin + (waveCount + 1) * waveAmp;
    for (int i = 0; i < width; i++) {
      float cx = map(i, 0, width, 0, 2 * PI);
      float cy = sin(initAngle + cx * freq);
      float cy2 = sin(initAngle + angleInc + cx * freq);
      PVector p = new PVector(i, map(cy, -1, 1, yBase, yBase + waveAmp));
      PVector p2 = new PVector(i, map(cy2, -1, 1, yBase2, yBase2 + waveAmp));
      PVector plot = PVector.lerp(p, p2, sqrt(random(1)));
      strokeWeight(random(2));
      point(plot.x, plot.y);
    }
    initAngle += angleInc;
  }
}

void drawOffsetGradientSquares() {
  int perSide = 5;
  int margin = 10;
  int inc = (width - margin * 2) / perSide;
  int perFrame = 500;
  for (int yi = 0; yi < perSide; yi++) {
    for (int xi = 0; xi < perSide; xi++) {
      float xBase = margin + xi * inc;
      float yBase = margin + yi * inc;
      for (int points = 0; points < perFrame; points++) {
        float x = xBase + inc * pow(random(1), 1.0 / (xi + 2));
        float y = yBase + inc * pow(random(1), 1.0 / (yi + 2));
        strokeWeight(random(2));
        point(x, y);
      }
    }
  }
}

void drawCenteredGradientSquares() {
  int perSide = 5;
  int margin = 10;
  int inc = (width - margin * 2) / perSide;
  int perFrame = 500;
  for (int yi = 0; yi < perSide; yi++) {
    for (int xi = 0; xi < perSide; xi++) {
      float xBase = margin + xi * inc;
      float yBase = margin + yi * inc;
      int index = xi + yi * perSide;
      for (int points = 0; points < perFrame; points++) {
        float x = xBase + random(inc);
        float y = yBase + random(inc);
        float distanceFromSide = min(x - xBase, min(xBase + inc - x, min(y - yBase, yBase + inc - y)));
        float distanceF = pow(distanceFromSide / (inc / 2), 0.5 + index * 0.15);
        strokeWeight(1.5 - 1.5 * distanceF);
        point(x, y);
      }
    }
  }
}

PVector randomInCircle(float x, float y, float r, float power, float fuzz) {
  return PVector.random2D().mult((r + r * random(fuzz)) * pow(random(1), power)).add(new PVector(x, y));
}
