public PVector up = new PVector(0.00424, 1.0, 0.00764);

class Projection {
  PVector w, u, v;
  PVector eye, lookAt;
  float distance;

  Projection(PVector e, PVector l, float fov) {
    eye = e;
    lookAt = l;
    distance = world.viewplane.h / 2 / tan(radians(fov));
  }

  Ray createRay(PVector point) {
    return new Ray(eye, lookAt);
  }

  void computeUVW() {
    w = PVector.sub(eye, lookAt);
    w.normalize();

    u = w.cross(up);
    u.normalize();

    v = u.cross(w);
    v.normalize();
  }
}

class Orthographic extends Projection {
  Orthographic(PVector e, PVector l, float fov) {
    super(e, l, fov);
    computeUVW();
  }

  Ray createRay(PVector point) {
    Ray ray = new Ray(eye, PVector.sub(lookAt, eye));
    ray.origin.add(world.viewplane.size * point.x, world.viewplane.size * point.y);
    ray.dir.normalize();
    return ray;
  }
}

class Perspective extends Projection {
  Perspective(PVector e, PVector l, float fov) {
    super(e, l, fov);
    computeUVW();
  }

  Ray createRay(PVector p) {
    Ray ray = new Ray(eye, PVector.sub( PVector.add(PVector.mult(u, p.x), PVector.mult(v, p.y)), PVector.mult(w, distance)));
    ray.dir.normalize();
    return ray;
  }
}
