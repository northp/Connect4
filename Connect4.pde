int cols = 7; // number of columns
int rows = 6; // number of rows
int space = 100; // space representing a slot for the red and blue pieces (100 high and100 wide)

int [][]board = new int [cols+1][rows+1];// create array bigger than board. board will make up column indices 1-7 (0 and 8 will be off the board)
color yellow = color(255, 205, 0); // colour of board

boolean redPlayer = true;
color red = color(255, 0, 0); //player one will be red
color blue = color(0, 0, 255); // player two will be blue


// a function to (re)-initialise the board, setting every board position equal to 0, an open space.
void setup()
{
  size(900, 800);
  ellipseMode(CORNER);
  for (int i = 0; i <= cols; i++)
  {
    for (int j = 0; j <= rows; j++)
    {
      board[i][j] = 0;
    }
  }
}

void draw()
{  
  
  // if function checkWin() == 0, the game is still running.
  // if function checkWin() == 1, Red player Wins.
  // if function checkWin() == 2, Blue player Wins.
  // if function checkWin() == 3, the game is a draw.
  
  if (checkWin()==0)
  {
    continuePlaying();
  } else if (checkWin()==1)
  {
    redWins();
  } else if (checkWin()==2)
  {
    blueWins();
  } else if (checkWin()==3)
  {
    stalemate();
  }
}

// run this function in draw() if Red player wins.
// prints a victory message for Red player on-screen
void redWins()
{
  background(0);
  fill(red);
  textSize(50);
  text("Red Wins! Press Space to restart...", 50, height/2);
}

// run this function in draw() if Blue player wins.
// prints a victory message for Blue player on-screen
void blueWins()
{
  background(0);
  fill(blue);
  textSize(50);
  text("Blue Wins! Press Space to restart...", 50, height/2);
}

// run this function in draw() if there is a draw
// prints a stalemate message on-screen
void stalemate()
{
  background(0);
  fill(yellow);
  textSize(50);
  text("Stalemate! Press Space to restart...", 50, height/2);
}

// run this function in draw() if the game is still running
// this function re-runs the drawPiece() function (explained below this function), 
// and rebuilds the board display for the players.
// This function also allows for animation of pieces over the slots, depending on 
// where the player hovers the mouse, and also depending on which coour will drop next.
void continuePlaying()
{
  background(0);
  fill(yellow);
  quad(0, 800, 100, 700, 800, 700, 900, 800);// a quadrilateral to draw the base of the Connect-4 board
  drawPiece();
  int hover = mouseX/space; // this will return a value to represent the column over which the player is hovering (eg 1-7).
  if (redPlayer == true && hover != 0 && hover != cols+1)
  {
    noStroke();
    fill(red);
    ellipse(mouseX-(space/2), 0*space, space, space);
    //ellipse(hover*space, 0*space, space, space);
  } else if (redPlayer != true && hover != 0 && hover != cols+1)
  {
    noStroke();
    fill(blue);
    ellipse(mouseX-(space/2), 0*space, space, space);
    //ellipse(hover*space, 0*space, space, space);
  }
}

// a function to colour the board whether positions are filled or empty.
// Colours empty spaces (0) black, red (1) filled positions red, blue (2) filled positions blue.
void drawPiece()
{

  for (int i = 1; i <= cols; i++)
  {
    for (int j = 1; j <= rows; j++)
    {
      stroke(yellow);
      fill(yellow);
      rect(i*space, j*space, space, space);
      if (board[i][j]==0)
      {
        fill(0);
        ellipse(i*space, j*space, space, space);
      } else if (board[i][j]==1)
      {
        fill(red);
        ellipse(i*space, j*space, space, space);
      } else if (board[i][j]==2)
      {
        fill(blue);
        ellipse(i*space, j*space, space, space);
      }
    }
  }
}

// this function listens for a particular Key being pressed, the spacebar.
// once the spacebar is pressed, this triggers a board reset.
// This acts as the reset function I spoke about in my draft proposal.
void keyPressed()
{
  if (key == ' ')
  {
    // resetboard and set redPlayer to true
    redPlayer = true;
    setup();
  }
}

// allows a player to drop a piece into an empty slot when the mouse is clicked.
void mousePressed()
{
  if (checkWin()==0) //can only drop a piece if there is no winner yet (ie checkWin() == 0)
  {
    int position = mouseX/space;

    if (position>0 && position<8)//check that player is clicking on board
    {
      // need to check board[position][rows] then board[position][rows-1] until the index is not equal to 0
      for (int j = rows; j > 0; j--)
      {
        if ((board[position][j]==0) && (redPlayer == true))
        {
          // player one's turn, play red
          board[position][j]=1;
          redPlayer = !redPlayer;
          break;
        } 
        if ((board[position][j]==0) && (redPlayer == false))
        {
          // player two's turn, play blue
          board[position][j]=2;
          redPlayer = !redPlayer;
          break;
        }
      }
    }
  }
}

// this function returns an integer to determine whether the game is still playing (0), 
// if Red player wins (1) or if Blue player wins (2).
// It also determines a draw or stalemate by returning an integer value of 3.
// This searches for a victory condition (four in a row), whether vertically, horizontally or diagonally.
// I have coded this function so that it only has a staring index within the first half of the board (the value of col divided by 2).
// This is so that when searching on a particular index plus the following three, it does not throw an out of bounds exception and crash.
int checkWin()
{
  int winner = 0;
  int rowNum = rows;
  int colNum = cols;

  while (rowNum > 0)
  {
    for (int i = 1; (i<=(cols+1)/2); i++)
    {
      if (board[i][rowNum]==1 && board[i+1][rowNum]==1 && board[i+2][rowNum]==1 && board[i+3][rowNum]==1)
      {
        winner = 1;
      }
      if (board[i][rowNum]==2 && board[i+1][rowNum]==2 && board[i+2][rowNum]==2 && board[i+3][rowNum]==2)
      {
        winner = 2;
      }
      // diagonal 1
      if (board[i][rowNum]==1 && board[i+1][rowNum-1]==1 && board[i+2][rowNum-2]==1 && board[i+3][rowNum-3]==1)
      {
        winner = 1;
      }
      // diagonal 1
      if (board[i][rowNum]==2 && board[i+1][rowNum-1]==2 && board[i+2][rowNum-2]==2 && board[i+3][rowNum-3]==2)
      {
        winner = 2;
      }
      // diagonal 2
      if (board[((cols)/2)+i][rowNum]==1 && board[((cols)/2)+i-1][rowNum-1]==1 && board[((cols)/2)+i-2][rowNum-2]==1 && board[((cols)/2)+i-3][rowNum-3]==1)
      {
        winner = 1;
      }
      // diagonal 2
      if (board[((cols)/2)+i][rowNum]==2 && board[((cols)/2)+i-1][rowNum-1]==2 && board[((cols)/2)+i-2][rowNum-2]==2 && board[((cols)/2)+i-3][rowNum-3]==2)
      {
        winner = 2;
      }
    }
    rowNum--;
  }

  while (colNum > 0)
  {
    for (int j = 1; (j<=(rows+1)/2) && (colNum > 0); j++)
    {
      if (board[colNum][j]==1 && board[colNum][j+1]==1 && board[colNum][j+2]==1 && board[colNum][j+3]==1)
      {
        winner = 1;
      }
      if (board[colNum][j]==2 && board[colNum][j+1]==2 && board[colNum][j+2]==2 && board[colNum][j+3]==2)
      {
        winner = 2;
      }
    }
    colNum--;
  }

  // stalemate has been reached
  if (isBoardFull()==1 && winner==0)
  {
    winner = 3;
  }
  return winner;
}

// a function to check if the board is completely filled.
// If no index in the board has a value of 0, the board is completely filled.
int isBoardFull()
{
  int boardIsFull = 1;

  for (int i = 1; i <= cols; i++)
  {
    for (int j = 1; j <= rows; j++)
    {
      if (board[i][j]==0)
      {
        boardIsFull = 0;
      }
    }
  }

  return boardIsFull;
}
