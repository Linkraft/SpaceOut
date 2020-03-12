class Paddle {
  PVector c;
  PImage img;
  float d;
  int speed = 4;
  int xoffset = 0;
  int yoffset = 75;
  int step = 0;
  boolean left = false;
  
  Paddle(PVector center, float diameter) {
    c = center;
    d = diameter;
    c.y += yoffset;
  }
  
  void update() {
    if (step == 0) c.x += 0;           // Don't move
    else if (step == -1) c.x -= speed; // Move left
    else if (step == 1) c.x += speed;  // Move right
    
    if (c.x < 120) c.x = 120;          // Left bound of paddle
    else if (c.x > 380) c.x = 380;     // Right bound of paddle
  }
  
  void draw() {
    PShape circle = createShape(ELLIPSE, c.x, c.y, d, d);
    circle.setFill(color(180));
    shape(circle);
  }
  
  void move(boolean movement) {
    if (movement) { // If movement is allowed, then move
      if (left) step = -1;
      else step = 1;
    }
    else step = 0;
  }
  
  void keyPressed() { // Move right or left
    if (key == CODED) {
      if (keyCode == RIGHT) left = false;
      if (keyCode == LEFT) left = true;
      move(true);
    }
  }
  
  void keyReleased() { // Stop moving
    move(false);
  }
  
}
