/*
Thank you to Brent Wasilow for his playlist on Youtube for how to get started on this project,
 and Sebastian Lague for the explanation of reflections and light
 */

public static final int samples_per_pixel = 10;
public static final int w = 400;
public static final int h = 275;

public World world;
public Tracer tracer;
public Sampler sampler;
public Projection projection;

void settings() {
  size(w, h);
}

void setup() {
  colorMode(RGB, 1);
  background(1);

  world = new World(w, h, 1, new PColor(1.0, 0.0, 0.0));
  tracer = new Tracer(10);
  sampler = new Sampler(samples_per_pixel);
  projection = new Perspective(new PVector(0, 0, 100), new PVector(0.0, 0.0, 0.0), 30);
}

void draw() {
  loadPixels();
  int i = 0;
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      PColor pc = tracer.pixelColor(x, h - y);
      pixels[i] = color(pc.r, pc.g, pc.b);
      i++;
    }
  }
  updatePixels();
  println("done!");
  noLoop();
}
