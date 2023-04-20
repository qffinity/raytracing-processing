class ViewPlane {
  int w, h, size;
  ViewPlane(int wid, int hei, int s) {
    w = wid;
    h = hei;
    size = s;
  }
}

class World {
  ViewPlane viewplane;
  PColor background;
  ArrayList<GeoObject> objects = new ArrayList<GeoObject>();
  World(int w, int h, int s, PColor bg) {
    viewplane = new ViewPlane(w, h, s);
    background = bg;
    objects.add(new Sphere(new PVector(0, 0, 0), 50, nonSpecMat(new PColor(1.0, 0.0, 0.0), 0.0)));
    //objects.add(new Sphere(new PVector(-200, 0, 0), 50, nonSpecMat(new PColor(0.0, 1.0, 0.0), 0.0)));
    //objects.add(new Sphere(new PVector(200, 0, 0), 50, nonSpecMat(new PColor(0.0, 0.0, 1.0), 0.0)));
    //objects.add(new Plane(new PVector(0, -100, 0), new PVector(0, 1, 0.2), nonSpecMat(new PColor(0.5, 1.0, 0.5), 0.0)));
    //objects.add(new Sphere(new PVector(300, 100, 100), 20, nonSpecMat(new PColor(1.0, 1.0, 1.0), 10.0)));
  }
}
