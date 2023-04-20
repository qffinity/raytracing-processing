class HitInfo {
  Material material = new Material(world.background, 0.0, 0.0, world.background);
  boolean didHit = false;
  PVector hitPoint, normal;
  float dist;
}

class Material {
  PColor MColor;
  float specularity;
  float emissionStrength;
  PColor emissionColor;
  Material(PColor c, float s, float e, PColor ec) {
    MColor = c;
    specularity = s;
    emissionStrength = e;
    emissionColor = ec;
  }
}

Material nonSpecMat(PColor c, float s) {
  return new Material(c, 0, s, c);
}

abstract class GeoObject {
  Material material;

  GeoObject(Material m) {
    material = m;
  }

  HitInfo getHitInfo(Ray ray) {
    return new HitInfo();
  }
}

class Plane extends GeoObject {
  PVector point, normal;
  Plane(PVector p, PVector n, Material m) {
    super(m);
    point = p;
    normal = n.normalize();
  }

  HitInfo getHitInfo(Ray ray) {
    HitInfo hitinfo = new HitInfo();
    PVector diff = PVector.sub(point, ray.origin);
    float dist = diff.dot(normal) / ray.dir.dot(normal);

    if (dist > 0) {
      hitinfo.didHit = true;
      hitinfo.dist = dist;
      hitinfo.hitPoint = PVector.add(ray.origin, PVector.mult(ray.dir, dist));
      hitinfo.normal = normal;
      hitinfo.material = material;
    }
    return hitinfo;
  }
}

class Sphere extends GeoObject {
  PVector center;
  float radius;
  Sphere(PVector c, float r, Material m) {
    super(m);
    center = c;
    radius = r;
  }

  HitInfo getHitInfo(Ray ray) {
    HitInfo hitinfo = new HitInfo();
    float a = ray.dir.magSq();
    PVector diff = PVector.sub(ray.origin, center);
    float b = 2*diff.dot(ray.dir);
    float c = diff.magSq() - radius*radius;
    float discrim = b*b - 4*a*c;

    if (discrim >= 0) {
      float dist = (-b - sqrt(discrim)) / (2*a);
      if (dist > 0) {
        hitinfo.didHit = true;
        hitinfo.dist = dist;
        hitinfo.hitPoint = PVector.add(ray.origin, PVector.mult(ray.dir, dist));
        hitinfo.normal = PVector.sub(hitinfo.hitPoint, center);
        hitinfo.normal.normalize();
        hitinfo.material = material;
      }
    }
    return hitinfo;
  }
}
