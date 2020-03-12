/*
         
         Breakout! (Space-Themed!)
         
   Story:
   You have three fighter ships to destroy a hostile UFO heading for Earth at lightspeed!
   You have to blast the UFO away in one volley, or else it will regenerate and you will
   have to try again! Because you are battling an alien starcraft at lightspeed, if your 
   fighter ship does not constantly return to the mothership after blasting bits of the 
   UFO away, it may become lost to the stars beyond, so be sure to move the mothership 
   around to stay close to your fighter ship.
   
   Controls: 
   1.) To move the paddle use the left and right arrow keys.
   2.) To pause the game, press 'p'
   3.) To reset the game, press 'r' or the reset button under the play button
   
   Gameplay:
   The ball will speed up gradually over time, about once every 4.5 seconds.
   
   Other stuff:
   I threw in a couple end screens for whether or not the player destroys the UFO.
   Because of this, I'd appreciate it if you could play the game by winning and losing to see
   both screens. :)
   
   (...or just fiddle with my code to force a win, that works too...)
   
*/

import controlP5.*;

ControlP5 cp5;
controlP5.Button play, reset, playAgain;
ControlFont font, sfont, efont;
Textlabel score, lives, endMsg, endMsg2;

boolean playing;
PShader backgroundShader;
PImage wallTiles, boxTiles;
Box[] walls, boxes;
Ball ball;
Paddle paddle;

boolean lost, won;
int UFOparts;
int numLives = 3;
float time;

void setup() {
  size(500, 500, P2D); // No touchy! Size is hardcoded now
  won = false;
  lost = false;
  UFOparts = 64; 
  time = 0;
  playing = false;
  
  /* Fonts! */
  cp5 = new ControlP5(this);
  font = new ControlFont(createFont("Modern No. 20", 50, true));  // For the buttons
  sfont = new ControlFont(createFont("Modern No. 20", 30, true)); // For the score and life counter
  efont = new ControlFont(createFont("Modern No. 20", 25, true)); // For the end screens
  
  play = cp5.addButton("PLAY").setPosition(100, 198).setSize(295, 100);
  play.getCaptionLabel().setFont(font);
  play.setColorBackground(color(120, 10, 10));
  play.setColorForeground(color(160, 10, 10));
  play.setColorActive(color(160, 40, 40));
  
  reset = cp5.addButton("RESET").setPosition(210, 302).setSize(75, 30);
  reset.setFont(new ControlFont(createFont("Modern No. 20", 20, true)));
  
  playAgain = cp5.addButton("PLAYAGAIN").setPosition(165, 302).setSize(150, 30);
  playAgain.setFont(new ControlFont(createFont("Modern No. 20", 20, true)));
  playAgain.getCaptionLabel().setText("Play Again?");
  playAgain.hide();
  
  score = cp5.addTextlabel("Score");
  lives = cp5.addTextlabel("Lives");
  endMsg = cp5.addTextlabel("End Message");
  endMsg2 = cp5.addTextlabel("End Message 2");

  backgroundShader = loadShader("woah.glsl");
  boxTiles = loadImage("alien.jpg");
  wallTiles = loadImage("starry.jpg");
  
  walls = new Box[3];
  walls[0] = new Box(0, 0, 50, 500, true, true, wallTiles);
  walls[1] = new Box(450, 0, 50, 500, true, true, wallTiles);
  walls[2] = new Box(50, 0, 400, 50, true, true, wallTiles);
  
  int num = 0;
  boxes = new Box[UFOparts];
  for (int x = 50; x < 450; x += 50) {
    for (int y = 150; y < 350; y += 25) {
      boxes[num] = new Box(x, y, 50, 25, true, false, boxTiles);
      num++;
    }
  }
  
  paddle = new Paddle(new PVector(250, height), 200);
  ball = new Ball(new PVector(251, 400), 25);
  
}

void startOver() {
  
}

void draw() {
  if (!lost && !won) { // If you're still playing...
    backgroundShader.set("resolution", width, height);
    //backgroundShader.set("mouse", ball.c.x/(width*1.0), 1 - ball.c.y/(height*1.0));
    backgroundShader.set("time", time);
    filter(backgroundShader);
    
    noStroke();
    for (Box wall : walls) wall.draw();
    for (Box box : boxes) box.draw();
    
    // If not paused, move things around
    if (playing) {
      time += 0.01;
      paddle.update();
      ball.update();
      ball.collisionCheck(walls);
      ball.collisionCheck(boxes);
      ball.collisionCheck(paddle);
    }
    
    // Draw the things that move
    paddle.draw();
    ball.draw();
    
    showScore();
    showLives();
    
    // If the ball goes below the screen, start again
    if (ball.c.y > height + ball.d/2) {
      numLives--;
      score.hide();
      lives.hide();
      setup();
    }
    // If you destroy the UFO, go to the win screen
    if (ball.score == UFOparts) {
      won = true;
      endScreen();
    }
    // If all your ships are lost to space, go to the lose screen
    if (numLives == 0) {
      lost = true;
      endScreen();
    }
  }
}

void showScore() {
  score.setText("Parts Destroyed: " + ball.score + "/" + UFOparts);
  score.setPosition(50, 10).setColorValue(color(250, 250, 0)).setFont(sfont);
}

void showLives() {
  lives.setText("Ships: " + numLives);
  lives.setPosition(330, 10).setColorValue(color(250, 250, 0)).setFont(sfont);
}
void endScreen() {
  PImage endImg;
  if (won) endImg = loadImage("earth.jpg");  // Winning endscreen
  else endImg = loadImage("darksky.jpg");        // Losing endscreen
  image(endImg, 0, 0);
  play.hide();
  score.hide();
  lives.hide();
  playAgain.show();
  numLives = 3;
  if (won) {
    fill(96);
    rect(125, 200, 225, 140);
    endMsg.setText("You Won!").setColor(color(255, 215, 0)).setFont(font);
    endMsg.setPosition(130, 200).setSize(100, 50);
    endMsg2.setText("The Earth was saved.").setColor(color(255, 215, 0)).setFont(efont);
    endMsg2.setPosition(130, 260).setSize(100, 50);
  }
  else {
    endMsg.setText("Game Over").setColor(color(255, 255, 255)).setFont(font);
    endMsg.setPosition(125, 200).setSize(100, 50);
    endMsg2.setText("The Earth was destroyed.").setColor(color(255, 255, 255)).setFont(efont);
    endMsg2.setPosition(112, 260).setSize(100, 50);
  }
}

void PLAY() {
  if (!lost && !won) {
    play.hide();
    reset.hide();
    playing = true;
  }
}

void RESET() {
  if (!lost && !won) {
    reset.hide();
    score.hide();
    lives.hide();
    play.hide();
    numLives = 3;
    setup();
  }
}

void PLAYAGAIN() {
  reset.hide();
  score.hide();
  lives.hide();
  play.hide();
  playAgain.hide();
  endMsg.hide();
  endMsg2.hide();
  numLives = 3;
  setup();
}

void keyPressed() {
  if (!lost && !won) {
    if (key == 'p') {
      if (playing) { 
        play.show();
        reset.show();
        playing = false;
      }
      else {
        play.hide();
        reset.hide();
        playing = true;
      }
    }
    else if (key == 'r') {
      play.hide();
      reset.hide();
      score.hide();
      lives.hide();
      numLives = 3;
      setup();
    }
  }
  paddle.keyPressed();
}

void keyReleased() {
  paddle.keyReleased();
}
