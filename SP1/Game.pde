import java.util.Random;

class Game
{
  boolean Death = false;
  private Random rnd;
  private int width;
  private int height;
  private int[][] board;
  private Keys keys;
  private int playerLife;
          int playerMax = 100;
          //player 2 life
          int player2Life;
          int player2Max = 100;
  private Dot player;
  //Player2
  private Dot player2;
  private Dot[] enemies;
  //Food
  private Dot[] food;
  
   
  Game(int width, int height, int numberOfEnemies, int edible)
  {
    if(width < 10 || height < 10)
    {
      throw new IllegalArgumentException("Width and height must be at least 10");
    }
    if(numberOfEnemies < 0)
    {
      throw new IllegalArgumentException("Number of enemies must be positive");
    } 
    this.rnd = new Random();
    this.board = new int[width][height];
    this.width = width;
    this.height = height;
    keys = new Keys();    
    player = new Dot(0,0,width-1, height-1);
    player2 = new Dot(0,0, width-1, height-1);
    enemies = new Dot[numberOfEnemies];
    food = new Dot[edible];
    for(int i = 0; i < edible; i++)
    {
      food[i] = new Dot(int(random(0,25)), int(random(0,25)), int(random(0,25)), int(random(0,25)));
    }
    for(int i = 0; i < numberOfEnemies; ++i)
    {
      enemies[i] = new Dot(width-1, height-1, width-1, height-1);
    }
    
    this.playerLife = playerMax;
    this.player2Life = player2Max;
  }
  
  public int getWidth()
  {
    return width;
  }
  
  public int getHeight()
  {
    return height;
  }
  int getPlayer2Life(){
    return player2Life;
  }
  
  public int getPlayerLife()
  {
    return playerLife;
  }
  
  public void onKeyPressed(char ch)
  {
    keys.onKeyPressed(ch);
  }
  public void onKeyPressed2(char key_)
  {
    keys.onKeyPressed2(key_);
  }
  public void onKeyReleased2(char key_){
    keys.onKeyReleased2(key_);
  }
  
  public void onKeyReleased(char ch)
  {
    keys.onKeyReleased(ch);
  }
  
  public void update()
  {
    if(Death != true){
    updatePlayer2();
    updatePlayer();
    updateEnemies();
    updateFood();
    checkForCollisions();
    clearBoard();
    populateBoard();
    } else 
    {
     if (player2Life > playerLife){
      
      textAlign(CENTER);
      text("Game over, player2 wins", 450, 500);
     } else {
      textAlign(CENTER);
      text("Game over, player1 wins", 450, 500);
     }
    }
  }
  
  
  
  public int[][] getBoard()
  {
    //ToDo: Defensive copy?
    return board;
  }
  
  private void clearBoard()
  {
    for(int y = 0; y < height; ++y)
    {
      for(int x = 0; x < width; ++x)
      {
        board[x][y]=0;
      }
    }
  }
  void updatePlayer2()
    {
    //Update player2
    if(keys.arrowUp() && !keys.arrowDown())
    {
      player2.moveUp();
    }
    if(keys.arrowLeft() && !keys.arrowRight())
    {
      player2.moveLeft();
    }
    if(keys.arrowDown() && !keys.arrowUp())
    {
      player2.moveDown();
    }
    if(keys.arrowRight() && !keys.arrowLeft())
    {
      player2.moveRight();
    }  
  }
  private void updatePlayer()
  {
    //Update player
    if(keys.wDown() && !keys.sDown())
    {
      player.moveUp();
    }
    if(keys.aDown() && !keys.dDown())
    {
      player.moveLeft();
    }
    if(keys.sDown() && !keys.wDown())
    {
      player.moveDown();
    }
    if(keys.dDown() && !keys.aDown())
    {
      player.moveRight();
    }  
  }
  
  private void updateEnemies()
  {
    for(int i = 0; i < enemies.length; ++i)
    {
      //Should we follow or move randomly?
      //2 out of 3 we will follow..
      if(rnd.nextInt(3) < 2)
      {
        //We follow
        int dx = player.getX() - enemies[i].getX();
        int dy = player.getY() - enemies[i].getY();
        int dx2 = player2.getX() - enemies[i].getX();
        int dy2 = player2.getY() - enemies[i].getY();
        if(dx+dy > dx2+dy2){
          dx = dx2;
          dy = dy2;
        }
        if(abs(dx) > abs(dy))
        {
          if(dx > 0)
          {
            //Player is to the right
            enemies[i].moveRight();
          }
          else
          {
            //Player is to the left
            enemies[i].moveLeft();
          }
        }
        else if(dy > 0)
        {
          //Player is down;
          enemies[i].moveDown();
        }
        else
        {//Player is up;
          enemies[i].moveUp();
        }
      }
      else
      {
        //We move randomly
        int move = rnd.nextInt(4);
        if(move == 0)
        {
          //Move right
          enemies[i].moveRight();
        }
        else if(move == 1)
        {
          //Move left
          enemies[i].moveLeft();
        }
        else if(move == 2)
        {
          //Move up
          enemies[i].moveUp();
        }
        else if(move == 3)
        {
          //Move down
          enemies[i].moveDown();
        }
      }
      
    }
  }
   private void updateFood()
  {
    for(int i = 0; i < food.length; ++i)
    {
      //2 out of 3 we will move away
      if(rnd.nextInt(3) < 2)
      {
        //run away 
        int dx = player.getX() - food[i].getX();
        int dy = player.getY() - food[i].getY();
        int dx2 = player.getX() - food[i].getX();
        int dy2 = player.getY() - food[i].getY();
        if(dx+dy > dx2+dy2){
          dx = dx2;
          dy = dy2;
        }
        if(abs(dx) > abs(dy))
        {
          if(dx > 0)
          {
            //Player is to the right
            food[i].moveLeft();
          }
          else
          {
            //Player is to the left
            food[i].moveRight();
          }
        }
        else if(dy > 0)
        {
          //Player is down;
          food[i].moveUp();
        }
        else
        {//Player is up;
          food[i].moveDown();
        }
      }
      else
      {
        //We move randomly
        int move = rnd.nextInt(4);
        if(move == 0)
        {
          //Move right
          food[i].moveRight();
        }
        else if(move == 1)
        {
          //Move left
          food[i].moveLeft();
        }
        else if(move == 2)
        {
          //Move up
          food[i].moveUp();
        }
        else if(move == 3)
        {
          //Move down
          food[i].moveDown();
        }
      }
    }
  }
  
  private void populateBoard()
  {
    //Insert player
    board[player2.getX()][player2.getY()] = 4;
    board[player.getX()][player.getY()] = 1;
    //Insert enemies
    for(int i = 0; i < enemies.length; ++i)
    {
      board[enemies[i].getX()][enemies[i].getY()] = 2;
    }
    //Insert Food
    for(int i = 0; i < food.length; ++i)
    {
      board[food[i].getX()][food[i].getY()] = 3; //Green color, referenced in main class
    }
  }
  
   
  private void checkForCollisions()
  {
    //Check food collisions
    
    for(int i = 0; i < food.length; i++)
    {
      if(food[i].getX() == player.getX() && food[i].getY() == player.getY())
      {
        //Increase lifepoints because of collision
        playerLife = playerLife < 99?playerLife+1:playerMax;
        
        //Move food to random location
        food[i].y=food[i].randomY();
        food[i].x=food[i].randomX();       
      } else if (food[i].getX() == player2.getX() && food[i].getY() == player2.getY())
      {
        //Increase lifepoints because of collision
        player2Life = player2Life < 99?player2Life+1:player2Max;
        //Move food to random location
        food[i].y=food[i].randomY();
        food[i].x=food[i].randomX();        
      }
      
    }
    //Check enemy collisions
    for(int i = 0; i < enemies.length; ++i)
    {
      if(enemies[i].getX() == player.getX() && enemies[i].getY() == player.getY())
      {
        //We have a collision
        --playerLife;
        if (playerLife < 1)
        {
          Death = true;
        }
      }
      //player 2 collision
      if(enemies[i].getX() == player2.getX()&&enemies[i].getY() == player2.getY()){
        --player2Life;
        
          if (player2Life < 1)
          {
            Death = true;
          }
        
      }
    }
  }          
    
    
    
}
