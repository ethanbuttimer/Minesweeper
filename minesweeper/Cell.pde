// Cell class

class Cell {
  int i;
  int j;
  int x;
  int y;
  int w;
  int neighborCount;
  int revealedCount;
  int flagCount;
  boolean bomb;
  boolean flagged;
  boolean revealed;
  PImage flagImg;
  PImage bombImg;
  
  Cell(int i_, int j_, int w_) {
    i = i_;
    j = j_;
    w = w_;
    x = i * w;
    y = j * w;
    neighborCount = 0;    
    bomb = false;
    flagged = false;
    revealed = false;
  }
   
  void show() {
    stroke(50);
    strokeWeight(3);
    fill(150);
    rect(x, y, w, w);
    stroke(255);
    strokeWeight(2);
    line(x+2, y+1, x+w-2, y+1);
    line(x+1, y+2, x+1, y+w-2);
    stroke(0);
    line(x+2, y-1, x+w-2, y-1);
    line(x-1, y+2, x-1, y+w-2);
    strokeWeight(3);
    if (flagged) {
      flagImg = loadImage("handyboi.png");
      image(flagImg, x+1, y+1, w, w);
    }
    if (revealed) {
      fill(200);
      stroke(50);
      rect(x-1, y-1, w+1, w+1);
      if (bomb) {
        bombImg = loadImage("chungus.jpeg");
        image(bombImg, x+1, y+1, w, w);
      } else {
        if (neighborCount > 0) {
          textAlign(CENTER);
          fill(0);
          text(neighborCount, x + w * 0.5, y + w * 0.65);
        }
      }
    }
  }
  
  void countBombs() {
    if (bomb) {
      neighborCount = -1;
      return;
    }
    int total = 0;
    for (int xoff = -1; xoff <= 1; xoff++) {
      int celli = i + xoff;
      if (celli < 0 || celli >= cols) continue;
  
      for (int yoff = -1; yoff <= 1; yoff++) {
        int cellj = j + yoff;
        if (cellj < 0 || cellj >= rows) continue;
  
        Cell neighbor = grid[celli][cellj];
        if (neighbor.bomb) {
          total++;
        }
      }
    }
    neighborCount = total;
  }
  
  int countFlags() {
    int total = 0;
    for (int xoff = -1; xoff <= 1; xoff++) {
      int celli = i + xoff;
      if (celli < 0 || celli >= cols) continue;
  
      for (int yoff = -1; yoff <= 1; yoff++) {
        int cellj = j + yoff;
        if (cellj < 0 || cellj >= rows) continue;
  
        Cell neighbor = grid[celli][cellj];
        if (neighbor.flagged) {
          total++;
        }
      }
    }
    return total;
  }
  
  boolean contains(int x_, int y_) {
    return (x_ > x && x_ < x + w && y_ > y && y_ < y + w);
  }
  
  int reveal() {
    int numRevealed = 1;
    revealed = true;
    if (neighborCount == 0) {
      // flood fill time
      numRevealed += floodFill();
    }
    return numRevealed;
  }
  
  int floodFill() {
    int numRevealed = 0;
    for (int xoff = -1; xoff <= 1; xoff++) {
      int celli = i + xoff;
      if (celli < 0 || celli >= cols) continue;
  
      for (int yoff = -1; yoff <= 1; yoff++) {
        int cellj = j + yoff;
        if (cellj < 0 || cellj >= rows) continue;
  
        Cell neighbor = grid[celli][cellj];
        if (!neighbor.revealed && !neighbor.flagged) {
          numRevealed += neighbor.reveal();
        }
        if (neighbor.bomb && !neighbor.flagged) {
          return -1;
        }
      }
    }
    return numRevealed;
  }
}
