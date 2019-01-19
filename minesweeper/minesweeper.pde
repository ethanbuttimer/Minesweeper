// Minesweeper
// Based on code by Daniel Shiffman of Coding Train

import processing.sound.*;
SoundFile lossNoise;
SoundFile winNoise;
SoundFile flagNoise;
SoundFile deflagNoise;

Cell[][] grid;
int cols;
int rows;
int w = 50;
int totalBombs = 2;
int revealedCount = 0;
int flagCount = 0;
int timeStart;
int timeEnd;
boolean bombHit = false;
PImage winnerImg;

void setup() {
  size(801, 801);
  cols = floor(width / w);
  rows = floor(height / w);
  grid = new Cell[cols][rows];
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      grid[i][j] = new Cell(i, j, w);
    }
  }
  lossNoise = new SoundFile(this, "roblox-death-sound_1.mp3");
  winNoise = new SoundFile(this, "SMALL_CROWD_APPLAUSE.mp3");
  flagNoise = new SoundFile(this, "Swoosh-flag.mp3");
  deflagNoise = new SoundFile(this, "Swoosh-deflag.mp3");

  // Pick totalBombs spots
  ArrayList<int[]> options = new ArrayList<int[]>();

  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      int[] option = new int[2];
      option[0] = i;
      option[1] = j;
      options.add(option);
    }
  }


  for (int n = 0; n < totalBombs; n++) {
    int index = floor(random(options.size()));
    int[] choice = options.get(index);
    int i = choice[0];
    int j = choice[1];
    // Deletes that spot so it's no longer an option
    options.remove(index);
    grid[i][j].bomb = true;
  }


  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      grid[i][j].countBombs();
    }
  }

}

void gameOver() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      grid[i][j].revealed = true;
    }
  }
  bombHit = true;
}

void keyPressed() {
   if (key == CODED) {
      if (keyCode == UP) {
         for (int i = 0; i < cols; i++) {
         for (int j = 0; j < rows; j++) {
            if (grid[i][j].contains(mouseX, mouseY) && !grid[i][j].revealed) {
               if (grid[i][j].flagged) {
                  grid[i][j].flagged = false;
                  flagCount--;
                  println("/" + flagCount + "/");
                  deflagNoise.play();
               }
               else {
                  grid[i][j].flagged = true;
                  flagCount++;
                  println("/" + flagCount + "/");
                  flagNoise.play();
               }
            }
         }     
         }
      }
   }
}
    
void mousePressed() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if (grid[i][j].contains(mouseX, mouseY)) {
        if (grid[i][j].revealed) {
          if (grid[i][j].countFlags() == grid[i][j].neighborCount) {
            int n = grid[i][j].floodFill();
            if (n == -1) {
              gameOver();
            }
            else {
              revealedCount += n;
              println(revealedCount);
            }
          }
        }
        else {    
          revealedCount += grid[i][j].reveal();
          println(revealedCount);
          if (grid[i][j].bomb) {
          gameOver();
          }
        }
      }
    }
  }
}
  
void draw() {
  background(255);
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      grid[i][j].show();
    }
  }
  if (flagCount == totalBombs && revealedCount == (cols * rows) - totalBombs) {
    fill(0,30,200);
    stroke(200,150,0);
    rect(width / 2 - 100, height / 2 - 30, 180, 60);
    textAlign(CENTER);
    fill(200,150,0);
    textSize(32);
    text("Well Done!", width / 2 - 7, height / 2 + 12);
    winNoise.play();
    noLoop();
  }
  if (bombHit) {
    fill(30);
    stroke(200, 0,0);
    rect(width / 2 - 100, height / 2 - 30, 180, 60);
    textAlign(CENTER);
    fill(200, 0,0);
    textSize(30);
    text("You Lose :(", width / 2 - 7, height / 2 + 12);
    lossNoise.play();
    noLoop(); 
  }
}
