class Ball {
  PVector c, v;
  Box[] walls, boxes;
  float d, t, speed;
  int score, lives;
  
  Ball(PVector center, float diameter) {
    c = center;
    d = diameter;
    v = new PVector(0, 1); // Go down at start;
    speed = 2;
    score = 0;
  }
  
  void update() {
    t = time * 100;
    if ((int)t % 300 == 0) {
      speed *= 1.1; // Speed up ball over time
    }
    c.x += v.x * speed;
    c.y += v.y * speed;
  }
  
  void draw() {
    PShape circle = createShape(ELLIPSE, c.x, c.y, d, d);
    circle.setFill(color(255, 255, 0));
    shape(circle);
  }
  
  void collisionCheck(Box[] boxes) {
    for (Box b : boxes) { // For all the boxes...
      if (boxCollide(b)) { // .. if the ball is touching a circle...
        boolean xBound = c.x < b.tl.x || c.x > (b.tl.x + b.wh.x); // .. and it's on the left or right of the box...
        boolean yBound = c.y < b.tl.y || c.y > (b.tl.y + b.wh.y); // .. and it's above or below the box...
        if (b.isWall) { // .. and if it is a wall
          // .. flip the vector...
          if (xBound) v.x *= -1; 
          if (yBound) v.y *= -1;
        }
        else if (b.alive) { // .. and if it's a unhit box...
          // .. flip the vector...
          if (xBound) v.x *= -1;
          if (yBound) v.y *= -1;
          b.alive = false; // ... and kill the box.
          score++;
        }
      }
    }
  }  
  
  void collisionCheck(Paddle p) {
    float xDist = (p.c.x - c.x) * (p.c.x - c.x);
    float yDist = (p.c.y - c.y) * (p.c.y - c.y);
    float dist = sqrt(xDist + yDist);
    boolean collided = dist < ((d/2) + (p.d/2));
    if (collided) { // If the paddle is touching the ball
      PVector n = new PVector(p.c.x - c.x, p.c.y - c.y).normalize();
      v = new PVector(v.x - 2 * v.dot(n) * n.x, v.y - 2 * v.dot(n) * n.y);
    }
  }
  
  boolean boxCollide(Box b) {
    float DeltaX = c.x - max(b.tl.x, min(c.x, b.tl.x + b.wh.x));
    float DeltaY = c.y - max(b.tl.y, min(c.y, b.tl.y + b.wh.y));
    return (DeltaX * DeltaX + DeltaY * DeltaY) < (d/2 * d/2);
  }
  
}
