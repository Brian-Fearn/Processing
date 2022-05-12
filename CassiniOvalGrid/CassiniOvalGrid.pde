int margin = 0;
int nBlobs = 8;

void setup() {
  size(900, 900, P3D);
  colorMode(HSB, 360, 100, 100, 100);
  smooth(8);
  ellipseMode(RADIUS);
  rectMode(RADIUS);
}

void draw() {
  background(225, 100, 20);
  noStroke();
  fill(150, 200, 255);
  float t = sin(radians(frameCount * 0.31));
  int n = 80; // circles per row / column
  float inc = 1.0 * (width - margin * 2) / n;
  float d = 150 + 100 * (0.5 * (1 + t)); // distance threshold 
  PVector [] blobs = new PVector[nBlobs];
  for (int i = 0; i < nBlobs; i++) {
    float n1 = noise(i + 12345 * i);
    float n2 = noise(i + 12345 * i, 797 + i);
    blobs[i] = new PVector(
          margin + (width - margin * 2) * 0.5 * (1 + sin(PI / 3 * n1 + radians(frameCount * n1))), 
          margin + (height - margin * 2) * 0.5 * (1 + sin(PI / 5 * n2 + radians(frameCount * n2))));
  }

  for (int yi = 0; yi < n; yi++) {
    float yBase = margin + yi * inc;
    float y = yBase + inc / 2;
    float distVal = sin(1.0 * yi / n * PI + radians(frameCount));
    for (int xi = 0; xi < n; xi++) {
      float xBase = margin + xi * inc;
      float f = 1 - pow(2 * (1.0 * xBase / (width - inc)) - 1, 2); // used to scale sine distortion with distance to center 
      float x = xBase + inc / 2 + 300.0 * f * distVal;
      
      PVector p = new PVector(x, y);
      float sum = 0.0;
      for (int i = 0; i < blobs.length; i++) {
        PVector blobI = blobs[i];
        float r = PVector.sub(p, blobI).mag();
        for (int j = i + 1; j < blobs.length; j++) {
          PVector blobJ = blobs[j];
          float r2 = PVector.sub(p, blobJ).mag();
          sum += max(0, 1 - r * r2 / (d * d));
        }
      }

      fill(200 + x / width * 50 * min(1, sum), 100 * pow(min(1, sum), 5), 100);
      if (sum > 0) {
        circle(x, y, inc / 2 * min(1, sum));
      }
    }
  }
  println(frameRate);
}
