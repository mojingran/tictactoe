import processing.net.*;
int[][] grid;
Client myClient;
color red=#FC0808;
color green=#08FC53;
boolean itsMyTurn=false;

void setup() {
  size(300, 400);
  grid = new int[3][3];
  strokeWeight(3);
  textAlign(CENTER, CENTER);
  textSize(50);
  
  myClient = new Client(this,"127.0.0.1",1234);
}

void draw() {
  if(itsMyTurn)
  background(green);
else background(red);
  //draw dividing lines
  stroke(0);
  line(0, 100, 300, 100);
  line(0, 200, 300, 200);
  line(100, 0, 100, 300);
  line(200, 0, 200, 300);

  //draw the x's and o's
  int row = 0;
  int col = 0;
  while (row < 3) {
    drawXO(row, col);
    col++;
    if (col == 3) {
      col = 0;
      row++;
    }
  }

  //draw mouse coords
  fill(0);
  text(mouseX + "," + mouseY, 150, 350);
  
  if(myClient.available()>0){
   String incoming = myClient.readString(); 
   int r=int(incoming.substring(0,1));
   int c=int(incoming.substring(2,3));
   grid[r][c]=2;
   itsMyTurn=true;
  }
}


void drawXO(int row, int col) {
  pushMatrix();
  translate(row*100, col*100);
  if (grid[row][col] == 1) {
    ellipse(50, 50, 90, 90);
  } else if (grid[row][col] == 2) {
    line (10, 10, 90, 90);
    line (90, 10, 10, 90);
  }
  popMatrix();
}


void mouseReleased() {
  //assign the clicked-on box with the current player's mark
  int row = (int)mouseX/100;
  int col = (int)mouseY/100;
  if (itsMyTurn&&grid[row][col] == 0)
    grid[row][col] = 1;
    myClient.write(row + "," + col);
    itsMyTurn=false;
}
