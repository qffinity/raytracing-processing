class Ray {
  PVector origin, dir;
  Ray (PVector o, PVector d) {
    origin = o;
    dir = d;
  }
}

class Tracer {
  int max_bounces;

  Tracer (int m) {
    max_bounces = m ;
  }

  PColor trace(int x, int y) {
    PColor incomingLight = new PColor(0.0, 0.0, 0.0);
    PVector point = sampler.sample(x, y);
    Ray ray = projection.createRay(point);
    HitInfo closestHit = new HitInfo();
    PColor rayColor = new PColor(1, 1, 1);
    for (int i = 0; i < max_bounces; i++) {
      closestHit = rayCollision(ray);
      if (closestHit.didHit) {
        Material hitMaterial = closestHit.material;
        ray.origin = closestHit.hitPoint;
        ray.dir = randomHemisphere(closestHit.normal);
        PColor emittedLight = hitMaterial.emissionColor;
        emittedLight.multS(hitMaterial.emissionStrength);
        emittedLight.multC(rayColor);
        incomingLight.addC(emittedLight);
        rayColor.multC(hitMaterial.MColor);

        float p = max(rayColor.r, max(rayColor.g, rayColor.b));
        if (random(1.0) > p) {
          break;
        }
        rayColor.multS(1/p);
      } else {
        break;
      }
    }
    return incomingLight;
  }

  PColor pixelColor(int x, int y) {
    PColor pixcolor = new PColor(0, 0, 0);
    for (int i = 0; i < sampler.samples; i++) {
      pixcolor.addC(trace(x, y));
    }
    pixcolor.multS(1/sampler.samples);
    return pixcolor;
  }
  
  HitInfo rayCollision(Ray ray) {
    HitInfo closestHit = new HitInfo();
    closestHit.dist = Float.MAX_VALUE;
    for (GeoObject o : world.objects) {
      HitInfo hi = o.getHitInfo(ray);
      if (hi.didHit && hi.dist < closestHit.dist) {
       closestHit = hi;
      }
    }
    return closestHit;
  }
}


class Sampler {
  int samples;
  Sampler (int s) {
    samples = s;
  }
  PVector sample(int x, int y) {
    PVector point =  new PVector(0.0, 0.0);
    point.x = x - world.viewplane.w / 2 + random(1.0);
    point.y = y - world.viewplane.h / 2 + random(1.0);
    return point;
  }
}

class PColor {
  float r, g, b;
  PColor(float red, float green, float blue) {
    r = red;
    g = green;
    b = blue;
  }
  PColor addC(PColor c) {
    r += c.r;
    g += c.g;
    b += c.b;
    return this;
  }
  PColor multC(PColor c) {
    r *= c.r;
    g *= c.g;
    b *= c.b;
    return this;
  }
  PColor multS(float s) {
    r *= s;
    g *= s;
    b *= s;
    return this;
  }
}

PColor fromColor(color c) {
  return new PColor(red(c), green(c), blue(c));
}

float randomValNorm() {
  float theta = 2*PI*random(1.0);
  float rho = sqrt(-2*log(random(1.0)));
  return rho*cos(theta);
}

PVector randomDirection() {
  PVector dir = new PVector(randomValNorm(), randomValNorm(), randomValNorm());
  return dir.normalize();
}
PVector randomHemisphere(PVector norm) {
  PVector dir = randomDirection();
  return dir.mult(Math.signum(PVector.dot(dir, norm)));
}
