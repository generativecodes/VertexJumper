/*
 * VertexJumper - a 3D Jump'n'Run game written in Java Processing.
 * Copyright (C) 2023 Miro-K. Hofmann.
 *
 * This file is part of VertexJumper.
 *
 * VertexJumper is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * VertexJumper is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with VertexJumper.  If not, see <https://www.gnu.org/licenses/>.
 *
 * Author: Miro-K. Hofmann
 * Date: April 25, 2023
 */


// Global variables
// -----------------
PVector screenCenter;  // center of the screen
ArrayList<phyEntity> entities;  // list of physical entities in the game
ArrayList<phyEntity> platforms;  // list of physical entities in the game
ArrayList<phyEntity> walls;  // list of physical entities in the game
player pl;  // player object
platform p1;  // platform object
terrain terra;  // terrain object
color bg, playerCol, npc, backwardsPlatformCol, forwardsPlatformCol;  // colors used in the game
boolean gameStarted = false;  // flag to indicate if game is started
boolean gamePaused = false;  // flag to indicate if game is paused
float lastPlatformZ = 0;
float platformSpawnThreshold = 300;
int platformsGenerated = 0;
int difficultyIncreaseInterval = 1;
float difficulty;
int highscore = 0;
int screenshotCount = 0;


// Setup function
// --------------
void setup() {
  size(420, 600, P3D);  // set window size and rendering mode
  screenCenter = new PVector(width/2, height/2, 0);  // initialize screen center
  bg = color(#0F2047);  // set background color
  playerCol = color(#FF2E63);  // set player color
  backwardsPlatformCol = color(#8F94FB);  // set platform color
  forwardsPlatformCol = color(#21E6C1);  // set platform color
  background(  #581845  );  // set background color

  entities = new ArrayList();  // initialize list of entities
  pl = new player(new PVector(width/2, width/2, 0), 0.08, 4.2);  // create player object
  entities.add(pl);  // add player object to entity list
  level0();  // initialize level
  terra = new terrain(3);  // create terrain object
  initTerrain();  // initialize terrain
  difficulty = 3;
}
// Main draw function
// ------------------
void draw() {
  if (gameStarted && !gamePaused) {  // if game is started and not paused
    background( #581845 );  // set background color
    lights();  // turn on lights
    setupLighting();  // set up lighting
    view(1);  // set view transformation
    updatePhyEntities(entities);  // update physical entities
    displayTerrain();  // display terrain
    terra.show();  // display terrain
    terra.move();  // move terrain
    updateTerrain();  // update terrain

    updatePhyEntities(entities);
    spawnPlatformsIfNeeded();
    if (pl.position.y > height) {  // if the player falls down
      resetGame();  // restart the game
    }
  } else {
    displayMenu();  // display menu if game not started or paused
  }
  displayHighscore();  // display highscore on screen
  displayScore();  // display current score on screen
}

// Display the menu when the game is not started or paused
// --------------------------------------------------------
void displayMenu() {
  background(bg);  // set background color
  textAlign(CENTER, CENTER);
  textSize(24);
  fill(255);
  if (!gameStarted) {
    text("VertexJumper", width/2, height/2 - 50);  // display game title
    text("Press ENTER to Start", width/2, height/2);  // display start message
    if (highscore > 0) {
      text("Last Highscore: " + highscore, width/2, height/2 + 40);  // display last highscore
    }
  } else if (gamePaused) {
    text("Game Paused", width/2, height/2 - 50);  // display pause message
    text("Press P to Resume", width/2, height/2);  // display resume message
  }
}
// Initialize the terrain
// ----------------------
int cols, rows;
int scl = 20;
int w = 420;
int h = 5000;
float flying = 0;
float[][] ter;

void initTerrain() {
  cols = w / scl;  // calculate number of columns
  rows = h / scl;  // calculate number of rows
  ter = new float[cols][rows];  // initialize terrain data
}

// Update the terrain with noise
// -----------------------------
void updateTerrain() {
  flying -= 0.09;  // update flying variable
  fill(4, 92, 93, 240);  // set fill color
  float yoff = flying;
  for (int y = 0; y < rows; y++) {
    float xoff = 0;
    for (int x = 0; x < cols; x++) {
      ter[x][y] = map(noise(xoff, yoff), 0, 1, -40, 40);  // update terrain data with noise
      xoff += 0.2;
    }
    yoff += 0.2;
  }
}

// Display the terrain
// --------------------
void displayTerrain() {
  stroke(forwardsPlatformCol);  // set stroke color
  fill(bg);  // set fill color
  for (int y = 0; y < rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {
      vertex(x*scl, ter[x][y] +3.1*(height/4)  +terra.terrain[x][y]/4, y*scl - h +600);  // set vertex position
      vertex(x*scl, ter[x][y+1] +3.1*(height/4)+terra.terrain[x][y+1]/4, (y+1)*scl - h +600);  // set vertex position
    }
    endShape();
  }
}

// Set up lighting
// ---------------
void setupLighting() {
  ambientLight(255, 0, 0);
  spotLight(144, 20, 0, width/2 + pl.position.x, 0, pl.position.z, 0, 1, 0, PI/2, 2);  // set spotlight
}

// View transformation
// --------------------
void view(int n) {
  switch(n) {
  case 1:
    translate(0, 50, 0);  // translate to new position
    rotateX(-PI/8);  // rotate view
    break;
  }
  println(entities.size());  // print frame rate
}

// Key press events
// -----------------
void keyPressed() {
  switch (key) {
  case 'w':
  case UP:
    pl.jump();  // player jumps when w key or up arrow is pressed
    break;
  case 'a':
  case LEFT:
    pl.left(true);  // player moves left when a key or left arrow is pressed
    break;
  case 'd':
  case RIGHT:
    pl.right(true);  // player moves right when d key or right arrow is pressed
    break;
  case ENTER:
    if (!gameStarted) gameStarted = true;  // start game when enter key is pressed
    break;
  case 'p':
  case 'P':
    gamePaused = !gamePaused;  // pause or resume game when p key is pressed
    break;
  case 's':  // take a screenshot when 's' key is pressed
  case 'S':
    saveFrame("screenshot-#####.png");  // save the current frame as a PNG file
    screenshotCount++;  // increment the screenshot count
    break;
  }
}

// Key release events
// -------------------
void keyReleased() {
  switch (key) {
  case 'a':
  case LEFT:
    pl.left(false);  // stop player from moving left when a key or left arrow is released
    break;
  case 'd':
  case RIGHT:
    pl.right(false);  // stop player from moving right when d key or right arrow is released
    break;
  }
}

void displayScore() {
  textAlign(RIGHT, TOP);
  textSize(24);
  fill(255);
  if (gamePaused) {
    text("Score: " + platformsGenerated, width - 10, 10);
  } else {
    text("Score: " + platformsGenerated, width - 12, -40);
  }
}

void displayHighscore() {
  textAlign(LEFT, TOP);
  textSize(24);
  fill(255);
  if (gamePaused) {
    text("Highscore: " + highscore, 10, 10);
  } else {
    text("Highscore: " + highscore, 12, -40);
  }
}

void resetGame() {
  gameStarted = false;
  gamePaused = false;
  entities = new ArrayList();  // reinitialize the entities list
  platforms = new ArrayList();  // reinitialize the platforms list
  walls = new ArrayList();  // reinitialize the walls list
  pl = new player(new PVector(width/2, width/2, 0), 0.08, 4.2);
  entities.add(pl);
  lastPlatformZ = 0;
  level0();
  terra = new terrain(3);
  initTerrain();
  difficulty = 3;
  platformsGenerated = 0;
  flying = 0;  // reset the flying variable for terrain generation
}
