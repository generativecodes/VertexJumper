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

void level0() {
  float speed = 3;
  //for (int i = 0; i < 24; i++) {
  for (int i = 0; i < 60; i++) {
    platform p = new platform(new PVector(width/2 + map(sin((PI/(40-i))*i), -1, 1, -100, 100), (height/3)*2, -dPlatform*i), speed);
    entities.add(p);
    if (i%10 == 9) {
      wall w = new wall(new PVector(width/2 + map(sin((PI/(40-i))*i), -1, 1, -100, 100), (height/3)*2 -10, -dPlatform*i), speed);
      entities.add(w);
    }
    lastPlatformZ = p.position.z+300;
  }
  //for (int i = 0; i < 40; i++) {
  //  if (i%14==1) {
  //    platform p = new platform(new PVector(width/2 + map(sin((PI/(40-i))*i*2)/2, -1, 1, -100, 100), (height/3)*2, -dPlatform*i*1), speed);
  //    entities.add(p);
  //  }
  //}
}

void spawnPlatformsIfNeeded() {
  phyEntity temp = null;
  boolean spawnNewPlatform = false;
  for (phyEntity e : entities) {
    if (e instanceof platform && e.position.z > platformSpawnThreshold && e.velocity.z > 0) {
      spawnNewPlatform = true;
      temp = e;
      break;
    }
  }
  if (spawnNewPlatform) {
    //  platformSpawnThreshold += random(-10, 10); // Reduced the added value to control the gap
    //  if(platformSpawnThreshold<300) platformSpawnThreshold = 300;
    generatePlatform(difficulty);
    int score = platformsGenerated;
    if (score > highscore) {
      highscore = score;
    }
  }
  entities.remove(temp);
}

void generatePlatform(float difficulty) {
  float xPos = random(width/4, 3 * width/4);
  float yPos = (height/3)*2 + random(-difficulty, difficulty)*10;
  float zPos = lastPlatformZ-wPlatform;
  float speedZ = difficulty;
  float rotatingR = 0.1;
  boolean reverse = random(1) < 0.01;

  // reverse ?
  //if (reverse){
  //  zPos = 300;
  //  speedZ *= -0.1;
  //  yPos = (height/3)*2 - 40;
  //}


  PVector position = new PVector(xPos, yPos, zPos);
  platform newPlatform = new platform(position, speedZ, rotatingR, reverse);
  entities.add(newPlatform);

  // Update the last platform's position

  if (!reverse) lastPlatformZ = zPos;

  // Add a wall with a certain probability based on the difficulty
  if (random(1) < difficulty * 0.01 || reverse) {
    wall newWall = new wall(new PVector(xPos, yPos - 10, zPos), speedZ);
    entities.add(newWall);
  }

  // Increase the difficulty as before
  platformsGenerated++;
  //if (platformsGenerated % difficultyIncreaseInterval == 0) {
  difficulty += 2 ;
  //}
}
