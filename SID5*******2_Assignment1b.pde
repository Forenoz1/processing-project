ArrayList<Ball> balls = new ArrayList();
boolean flag = false;
ArrayList<PImage> imgs = new ArrayList();

void setup() {
  size(1200, 800, P3D);
  smooth();
  set_imgs();
  mousePressed();
}

void draw() {
  background(0);
  set_walls();
  flag = true;
  for (Ball ball: balls) {
    ball.move();
    ball.collision();
    ball.checkWalls();
    ball.checkStop();
    ball.display();
  }
}

void set_imgs() {
  PImage img1 = loadImage(sketchPath() + "/data/a.jpg");
  PImage img2 = loadImage(sketchPath() + "/data/b.jpg");
  PImage img3 = loadImage(sketchPath() + "/data/c.jpg");
  PImage img4 = loadImage(sketchPath() + "/data/d.jpg");
  imgs.add(img1);
  imgs.add(img2);
  imgs.add(img3);
  imgs.add(img4);
}

void set_walls() {
  stroke(255);
  line(0, 0, -800, width, 0, -800);
  line(0, 0, -800, 0, height, -800);
  line(0, height, -800, width, height, -800);
  line(width, height, -800, width, 0, -800);

  line(0, 0, -800, 0, 0, 0);
  line(width, 0, -800, width, 0, 0);
  line(0, height, -800, 0, height, 0);
  line(width, height, -800, width, height, 0);
}

void mousePressed() {
  if (balls.size() >= 0 && flag == true) {
    balls.add(new Ball(mouseX, mouseY));
  }
}

class Ball {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float radius;
  float threshold;
  PShape shapeB;
  int randomTexture = (int)random(0, 4);
  float randomSpinningR = random(1,6);
  int startSpinning;
  
  Ball(float x, float y) {
    position = new PVector(x, y, 0);
    velocity = new PVector(random(-10, 10), random(-20, 5), random(-10, -5));
    acceleration = new PVector(0, 0.98, 0);
    radius = 70;
    threshold = 0.004;
  }
  
  void display() {
    fill(255);
    noStroke();
    pushMatrix();
    translate(position.x, position.y, position.z);
    shapeB = createShape(SPHERE, radius);
    shapeB.setTexture(imgs.get(randomTexture));
    rotate();
    shape(shapeB);
    popMatrix();
  }
  
  void rotate() {
    pushMatrix();
    resetMatrix();
    float stopPositionY = position.y;
    popMatrix();

    if (velocity.mag() <= 0.9 && stopPositionY >= height - radius) {
      rotateX(startSpinning * randomSpinningR / 80);
    } else {
      rotateX(startSpinning * randomSpinningR / 80);
      startSpinning++;
    }
    
  }
  
  void move() {
    if (velocity.x > threshold) {
        velocity.x -= threshold;
    } else if (velocity.x < -threshold) {
        velocity.x += threshold;
    }
    if (velocity.z > threshold) {
        velocity.z -= threshold;
    } else if (velocity.z < -threshold) {
        velocity.z += threshold;
    }
    velocity.add(acceleration);
    position.add(velocity);
  }
  
  void checkWalls() {
    if (position.x > width - radius) {
      position.x = width - radius;
      velocity.x *= -0.8;
    } else if (position.x < radius) {
      position.x = radius;
      velocity.x *= -0.8;      
    }
    if (position.y > height - radius) {
      position.y = height - radius;
      velocity.y *= -0.95;
    } else if (position.y < radius) {
      position.y = radius;
      velocity.y *= -0.95;      
    }
    if (position.z > -radius) {
      position.z = -radius;
      velocity.z *= -0.8;
    } else if (position.z < -800 + radius) {
      position.z = -800 + radius;
      velocity.z *= -0.8;      
    }
  }
  
  void checkStop() {
    if (abs(velocity.x) <= threshold) {
      velocity.x = 0;
    }
    if (abs(velocity.y) <= threshold) {
      velocity.y = 0;
    }
    if (abs(velocity.z) <= threshold) {
      velocity.z = 0;
    }
  }
  
  void collision() {
    for (int i = 0; i < balls.size() - 1; i++) {
      Ball ball1 = (Ball)balls.get(i);
      for (int j = i + 1; j < balls.size(); j++) {
        Ball ball2 = (Ball)balls.get(j);
        if (PVector.dist(ball1.position, ball2.position) < (ball1.radius + ball2.radius)) {
          twoBallsCollision(ball1, ball2);
        }
      }
    }
  }
  
  void twoBallsCollision(Ball b1, Ball b2) {
    // position
    PVector direction = PVector.sub(b1.position, b2.position);
    float distance = direction.mag();
    float placementDis = (b1.radius + b2.radius - distance) / 2;
    PVector placement = direction.normalize().mult(placementDis);
    b1.position.add(placement);
    b2.position.sub(placement);
    
    // velocity
    PVector temp = b1.velocity.copy();
    b1.velocity = b2.velocity;
    b2.velocity = temp;
  }
}
