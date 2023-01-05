import processing.sound.*; //<>//

Button btnPlay;
Button btnLadderboard;
Button btnQuit;
Button btnRetry;
Button btnMenu;
Textbox txtName;
SoundFile eatSound;


Table ladderboardData;
ArrayList<Coordinate> snakeCoordinate;
Coordinate foodCoordinate;

PImage[] images;
String[] fileNames = {
  "HeadUp.png", "HeadDown.png", "HeadLeft.png", "HeadRight.png",
  "TailUp.png", "TailDown.png", "TailLeft.png", "TailRight.png",
  "Body.png", "Food.png"
};
String playerName = "";
boolean isGameOver = false;
int onScreen = 1;
int direction = 3;  
int score = 0;
int velocity = 10;
int boxSize = 20;

void setup() {
  size(800, 800);
  surface.setTitle("Snake Game");
  
  eatSound = new SoundFile(this, "blip.wav");
  
  try {
    ladderboardData = loadTable("assets/LadderboardData.csv", "header");
  }
  catch(NullPointerException ex) {
    if(ladderboardData == null) {
      Table table = new Table();
      table.addColumn("Name");
      table.addColumn("Score");
      saveTable(table, "assets/LadderboardData.csv");
    }
  }
  ladderboardData.sort("Score");
  
  snakeCoordinate = new ArrayList<Coordinate>();
  snakeCoordinate.add(new Coordinate(0, width/(20*2)));
  foodCoordinate = new Coordinate(20, 20);
  
  btnPlay = new Button("Play", 280, height/3 + 40, 250, 40);
  btnLadderboard = new Button("Ladderboard", 280, height/3 + 100, 250, 40);
  btnQuit = new Button("Quit", 280, height/3 + 250, 250, 40);
  btnRetry = new Button("Retry", 280, height/2, 250, 40);
  btnMenu = new Button("Menu", 280, height/2 + 50, 250, 40);
  txtName = new Textbox("", 280, height/2, 250, 40);
  
  images = new PImage[10];
  for (int i = 0; i < 10; i++) {
    images[i] = loadImage("assets/" + fileNames[i]);
  }
}

void draw() {
  if (onScreen == 1) {
    menuPanel();
  } else if (onScreen == 2) {
    gamePanel();
  } else if (onScreen == 3) {
    ladderboardPanel();
  }
  onClick();
}

void mousePressed() {
  txtName.Pressed(); 
}

void keyPressed() {
  if (onScreen != 1) {
    if (key == ESC) {
      key = 0;
      onScreen = 1;
    }
  } 
  
  if (keyCode == UP) {
    direction = 0;
  } else if (keyCode == DOWN) {
    direction = 1;
  } else if (keyCode == LEFT) {
    direction = 2;
  } else if (keyCode == RIGHT) {
    direction = 3;
  }
  
  if(txtName.keyPressed(key, keyCode)) {
    playerName = txtName.getText();
  }
}

void menuPanel() {
  background(0);
  fill(255);
  textSize(40);
  textAlign(CENTER);
  text("SNAKE GAME", width/2, height/3);
  btnPlay.draw();
  btnLadderboard.draw();
  btnQuit.draw();
}

void ladderboardPanel() {
  background(0);
  fill(255);
  textSize(40);
  textAlign(CENTER);
  text("LADDERBOARD", width/2, height/7);
  textSize(16);
  fill(192);
  
  //Ladderboard Table
  int startX = 200;
  int startY = height/5;
  int counter = 0;
  
  rect(startX, startY, 400, 500);
  fill(220);
  
  //Ladderboard Header
  rect(startX, startY, 400, 50);
  fill(0);
  text("Name", startX + 120, startY + 30);
  text("Score", startX + 270, startY + 30);
  
  //Ladderboard Body
  if(ladderboardData.getRowCount() == 0) {
    return; 
  }
  
  for(int i = ladderboardData.getRowCount() - 1; i < ladderboardData.getRowCount(); i--) {
    if(counter == ladderboardData.getRowCount() || counter == 10) {
      break; 
    }
    
    if(i < 0) {
      i = 0; 
    }
    
    for(int j = 0; j < ladderboardData.getColumnCount(); j++) {
      text(ladderboardData.getString(i, j), startX + 120, startY + 80);
      startX += 150;
    }
    startX = 200;
    startY += 40;
    counter++;
  }
}

void gamePanel() {
  background(226, 135, 67);
  
  //If player name is empty
  if(playerName != "") { 
    textAlign(LEFT);
    textSize(24);
    fill(0);
    text("Score : " + score, 0, 20);
    
    //If game is not over
    if(!isGameOver) { 
      createSnake();
      createFood();
      
      if(frameCount % velocity == 0) {
        snakeDirection();
        snakeCollide();
        randomFood();
      }
    }
    else {
      gameOverPanel(); 
    }
  }
  else {
    //To show textbox name
    fill(0);
    rect(200, height/2-100, 400, 200);
    fill(255);
    textSize(24);
    textAlign(RIGHT);
    text("Type your name", 440, height/2 - 20);
    textAlign(LEFT);
    txtName.draw();
  }
}

void gameOverPanel() {
  fill(0);
  rect(200, 200, 400, 400);
  fill(255);
  textSize(24);
  textAlign(CENTER);
  text("GAME OVER", 400, 280);
  text("Player : " + playerName, 400, 310);
  text("Your Score : " + score, 400, 340);
  btnRetry.draw();
  btnMenu.draw();
}

void onClick() {
  //Clickable object manager
  if(onScreen == 1) {
    if (btnPlay.isPressed()) {
      onScreen = 2;
      return;
    } else if (btnLadderboard.isPressed()) {
      onScreen = 3;
      return;
    } else if (btnQuit.isPressed()) {
      exit();
    }
  }
  else if(onScreen == 2) {
    if(isGameOver) {
      if (btnRetry.isPressed()) {
        onScreen = 2;
        clearGame();
        return;
      } else if (btnMenu.isPressed()) {
        addLadderboard();
        ladderboardData.sort("Score");
        onScreen = 1;
        clearGame();
        return;
      }
    }
  }
}

void createSnake() {
  for (int i = 0; i < snakeCoordinate.size(); i++) {
    //If index is zero, the image is head part
    if (i == 0) {
      if(direction == 0) {
        image(images[0], snakeCoordinate.get(i).getX() * boxSize, snakeCoordinate.get(i).getY() * boxSize, boxSize, boxSize);
      }
      else if(direction == 1) {
        image(images[1],  snakeCoordinate.get(i).getX() * boxSize, snakeCoordinate.get(i).getY() * boxSize, boxSize, boxSize);
      }
      else if(direction == 2) {
        image(images[2],  snakeCoordinate.get(i).getX() * boxSize, snakeCoordinate.get(i).getY() * boxSize, boxSize, boxSize);
      }
      else if(direction == 3) {
        image(images[3],  snakeCoordinate.get(i).getX() * boxSize, snakeCoordinate.get(i).getY() * boxSize, boxSize, boxSize);
      }
    }
    //If last index, the image is tail part
    else if(i == snakeCoordinate.size() - 1) {
      if(direction == 0) {
        image(images[4],  snakeCoordinate.get(i).getX() * boxSize, snakeCoordinate.get(i).getY() * boxSize, boxSize, boxSize);
      }
      else if(direction == 1) {
        image(images[5],  snakeCoordinate.get(i).getX() * boxSize, snakeCoordinate.get(i).getY() * boxSize, boxSize, boxSize);
      }
      else if(direction == 2) {
        image(images[6],  snakeCoordinate.get(i).getX() * boxSize, snakeCoordinate.get(i).getY() * boxSize, boxSize, boxSize);
      }
      else if(direction == 3) {
        image(images[7],  snakeCoordinate.get(i).getX() * boxSize, snakeCoordinate.get(i).getY() * boxSize, boxSize, boxSize);
      }
    }
    //If snake length is greater than 1, the image is body part
    else if(snakeCoordinate.size() > 2) {
      if(direction == 0) {
        image(images[8],  snakeCoordinate.get(i).getX() * boxSize, snakeCoordinate.get(i).getY() * boxSize, boxSize, boxSize);
      }
      else if(direction == 1) {
        image(images[8],  snakeCoordinate.get(i).getX() * boxSize, snakeCoordinate.get(i).getY() * boxSize, boxSize, boxSize);
      }
      else if(direction == 2) {
        image(images[8],  snakeCoordinate.get(i).getX() * boxSize, snakeCoordinate.get(i).getY() * boxSize, boxSize, boxSize);
      }
      else if(direction == 3) {
        image(images[8],  snakeCoordinate.get(i).getX() * boxSize, snakeCoordinate.get(i).getY() * boxSize, boxSize, boxSize);
      }
    }
  }
}

void createFood() {
  image(images[9], foodCoordinate.getX() * boxSize, foodCoordinate.getY() * boxSize, boxSize, boxSize);
}

void randomFood() {
  //If snake head is collide with the food
  if(snakeCoordinate.get(0).getX() == foodCoordinate.getX() && 
     snakeCoordinate.get(0).getY() == foodCoordinate.getY()) {
    eatSound.play();
    score += 1; //Increase score
    
    //If snake size is increase, the speed will increase
    if(snakeCoordinate.size() % 2 == 0 && velocity >= 3) {
      velocity -= 1; 
    }
    foodCoordinate.setX((int)random(0, 40));
    foodCoordinate.setY((int)random(0, 40));
  }
  else {
    snakeCoordinate.remove(snakeCoordinate.size() - 1);
  }
}

void snakeCollide() {
  int headX = snakeCoordinate.get(0).getX();
  int headY = snakeCoordinate.get(0).getY();
  
  //If snake head collide the bounds
  if(headX < 0 || headY < 0 || 
     headX >= width/20 || headY >= height/20) {
     isGameOver = true;
  }
  
  //If snake head collide itself
  for(int i = 1; i < snakeCoordinate.size(); i++) {
    if(headX == snakeCoordinate.get(i).getX() &&
       headY == snakeCoordinate.get(i).getY()) {
       isGameOver = true;
    }
  }
}

void snakeDirection() {
  //Direction manager
  if(direction == 0) {
    snakeCoordinate.add(0, new Coordinate(snakeCoordinate.get(0).getX(), snakeCoordinate.get(0).getY() - 1)); 
  }
  else if(direction == 1) {
    snakeCoordinate.add(0, new Coordinate(snakeCoordinate.get(0).getX(), snakeCoordinate.get(0).getY() + 1)); 
  }
  else if(direction == 2) {
    snakeCoordinate.add(0, new Coordinate(snakeCoordinate.get(0).getX() - 1, snakeCoordinate.get(0).getY())); 
  }
  else if(direction == 3) {
    snakeCoordinate.add(0, new Coordinate(snakeCoordinate.get(0).getX() + 1, snakeCoordinate.get(0).getY())); 
  }
}

void addLadderboard() {
  TableRow newRow = ladderboardData.addRow();
  newRow.setString("Name", playerName);
  newRow.setInt("Score", score);
  saveTable(ladderboardData, "assets/LadderboardData.csv"); 
}

void clearGame() {
  isGameOver = false;
  playerName = "";
  score = 0;
  velocity = 10;
  snakeCoordinate.clear();
  snakeCoordinate.add(new Coordinate(0, width/(20*2)));
  foodCoordinate = new Coordinate(20, 20);
  txtName.setText("");
  direction = 3;
}
