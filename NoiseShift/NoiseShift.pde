void setup() {
  size(400, 400, P2D);
}

void draw() {
  float ft = sin(PI + radians(frameCount * 0.1));
  float ft2 = sin(PI + radians(frameCount * 0.1));
  float sc = 0.008;
  float ysc = 0.008;
  float ffc = frameCount * 0.002;
  loadPixels();
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      int px = x + y * width;
      float noize = noise(x * sc, ffc + y * ysc, ffc);
      noize = pow(0.5 * (1 + sin(noize * TAU * 10)), 5);
      float noize2 = noise(x * sc, ffc + y * ysc + ft * 10 * sc, ffc);
      noize2 = pow(0.5 * (1 + sin(noize2 * TAU * 10)), 5);
      float noize3 = noise(x * sc, ffc + y * ysc - ft2 * 10 * sc, ffc);
      noize3 = pow(0.5 * (1 + sin(noize3 * TAU * 10)), 5);
      pixels[px] = color(noize2 + noize * 255, noize2 * 255, noize3 * 255);
    }
  }
  updatePixels();
  println(frameCount / 60);
}
