class Box {
  
  PVector tl, wh, imgSrc;
  boolean alive, isWall;
  PImage img;
  
  Box(float tlx, float tly, float w, float h, boolean state, boolean isWall, PImage img) {
    tl = new PVector(tlx, tly);
    wh = new PVector(w, h);
    alive = state;
    this.isWall = isWall;
    this.img = img;
  }
  
  void draw() {
    if (alive) {
      rect(tl.x, tl.y, wh.x, wh.y);
      copy(img, (int)tl.x, (int)tl.y, (int)wh.x, (int)wh.y, (int)tl.x, (int)tl.y, (int)wh.x, (int)wh.y);
    }
  }
  
  PVector centerPos() {
    return new PVector(tl.x + (wh.x/2), tl.y + (wh.y/2));
  }
  
}
