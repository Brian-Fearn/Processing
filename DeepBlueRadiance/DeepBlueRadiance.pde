PGraphics pg;

ArrayList<Mover> particles = new ArrayList<Mover>();

int nParticles = 6000; 
float angleNoise = 0.00;
float noiseScale = 0.01;
boolean randomizeInitAngles = false;
color lightPurple = color(245, 235, 255);
color white = color(255);
color offWhite = color(255, 250, 215);
color bgColor = white; // lightPurple;
color fillColor = color(255, 245, 125);
float shadeFrequency = 1.0;
float shadeMultiplier = 0; // set to 0 for rings rather than spiral 
float shadePower = 1; // higher means more contrast between dark and light
float rotationFrequency = 0.4;
float baseNoiseExpansionSpeed = 1.5;
float noiseExpansionMix = 0.6; // 0 to expand in circular rings, 1 to make the expansion "noisy"
float radiusRange = 9; // how big can circles get?
float circleAlpha = 3.5;
long rSeed;
int blendType = SUBTRACT;

void setup() {
  size(900, 900, P2D);
  rSeed = (long) random(1000000000);
  randomSeed(rSeed);
  noiseSeed(rSeed);
  pg = createGraphics(1080, 1080, P2D);
  pg.smooth(8);
  pg.beginDraw();
  pg.blendMode(blendType);
  for (int i = 0; i < nParticles; i++) {
    float th = randomizeInitAngles ? random(2 * PI) : 2 * PI * i / nParticles;
    particles.add(new Mover(new PVector(pg.width / 2, pg.height / 2), th));
  }
  pg.fill(255, 225, 105, 10);
  pg.noStroke();
  pg.endDraw();
}

void draw() {
  pg.beginDraw();
  if (frameCount == 1) {
      pg.background(bgColor);
  }
  for (Mover p : particles) {
    p.update();
    p.show();
  }
  pg.endDraw();
  image(pg, 0, 0, width, height);
  println(frameRate);
}

void mouseClicked() {
  pg.save(this.getClass().getName() + rSeed + ".png");
}

class Mover {
  
  PVector pos;
  float th;
  color c;
  
  Mover(PVector pos, float th) {
    this.pos = pos;
    this.th = th;
    this.c = color(fillColor);
  }
  
  void update() {
    th += 0.01 * cos(radians(frameCount * rotationFrequency)) + random(-angleNoise, angleNoise);;
    PVector p = pos.copy();
    float t = pow(0.5 * (1 + sin(radians(frameCount * 0.5) + th)), 1);
    float vn = noise(p.x * noiseScale, p.y * noiseScale) * baseNoiseExpansionSpeed;
    float v = 0.1 + 0.9 * t; 
    v = lerp(v, vn, noiseExpansionMix);
    pos.add(PVector.fromAngle(th).mult(v));
  }
  
  void show() {
    float ft = random(0.0) + 1.0 * pow(0.5 * (1 + sin(radians(frameCount * shadeFrequency) + th * shadeMultiplier)), shadePower);
    pg.fill(c, circleAlpha);
    if (pos.x > 0 && pos.x < pg.width && pos.y > 0 && pos.y < pg.height) {
      pg.circle(pos.x, pos.y, 1 + radiusRange * ft * pow(dist(pos.x, pos.y, pg.width / 2, pg.height / 2) / pg.width, 1));
    }
  }
  
}
