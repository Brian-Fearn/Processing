PImage img;
PGraphics pg;
PShader shader;

void setup() {
  size(1600, 900, P3D);
  pg = createGraphics(1920, 1080, P3D);
  shader = new PShader(this, "VertShader.vert", "PixelWaveFragShader.frag");
  img = loadImage("fruit3.png");
}

void draw() {
  pg.beginDraw();
  pg.background(0);
  pg.image(img, 0, 0, pg.width, pg.height);
  if (frameCount == 1) {
    pg.loadPixels();
  }
  float t = 0.5 * (1 + sin(radians(frameCount * 0.05)));
  int y = min(pg.height - 1, int(t * pg.height));
  PImage sampler = img.get(0, y, img.width, 1);
  pg.noStroke();
  shader.set("sampler", sampler);
  shader.set("resolution", float(img.width), float(img.height));
  shader.set("iTime", radians(frameCount));
  pg.shader(shader);
  pg.rect(0, 0, pg.width, pg.height);
  pg.endDraw();
  image(pg, 0, 0, width, height);
  println(frameCount / 60);
}
