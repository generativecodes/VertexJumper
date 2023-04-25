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

class phyEntity {

  color colorStatus, colorIntent;

  PVector position, velocity, acceleration;
  float sizeX, sizeY, sizeZ, descending;

  boolean sphere, moving = true, falling = true;

  phyEntity(PVector position, float w, float h, float d) {
    this.position = position;
    this.sphere = false;
    sizeX = w;
    sizeY = h;
    sizeZ = d;
    velocity = new PVector(0, 0, 0);
    acceleration = new PVector(0, 0, 0);
    colorStatus = colorIntent = color(bg);
  }

  phyEntity(PVector position, float r) {
    this.position = position;
    this.sphere = true;
    sizeX = r;
    sizeY = sizeZ = 0;
    velocity = new PVector(0, 0, 0);
    acceleration = new PVector(0, 0, 0);
  }

  void update() {
    this.show();
    if (this.moving) this.move();
  }

  void show() {
    pushMatrix();
    translate(position.x, position.y, position.z);
    fill(colorStatus);
    noStroke();
    if (sphere) {
      sphere(sizeX);
    } else {
      box(sizeX, sizeY, sizeZ);
    }
    popMatrix();
    if (colorStatus!=colorIntent) adjustColor();
  }

  void move( int obstacles) {
    if (this.falling) acceleration.y += this.descending;
    velocity.add(acceleration);
    processObstacles(obstacles);
    acceleration.mult(0);
    position.add(velocity);
  }
  void move( ) {
    if (this.falling) acceleration.y += this.descending;
    velocity.add(acceleration);
    acceleration.mult(0);
    position.add(velocity);
  }

  void setColor(color c) {
    colorIntent = colorStatus = c;
  }


  //HELP FUNCTIONS -- not nice to read
  void adjustColor() {
    //changes colors 1 Step in intendet direction
    float statusR = red(colorStatus);
    float intentR = red(colorIntent);
    float statusG = green(colorStatus);
    float intentG = green(colorIntent);
    float statusB = blue(colorStatus);
    float intentB = blue(colorIntent);
    if (statusR<intentR)
      statusR++;
    else if (statusR>intentR)
      statusR--;
    if (statusG<intentG)
      statusG++;
    else if (statusG>intentG)
      statusG--;
    if (statusB<intentB)
      statusB++;
    else if (statusB>intentB)
      statusB--;
    colorStatus = color(statusR, statusG, statusB);
  }

  void processObstacles(int obstacle) {
    switch(obstacle) {
    case 0: //obstacle is forwards
      if (acceleration.z < 0 || velocity.z < 0) {
        acceleration.z = 0;
        velocity.z = 0;
      }
      break;
    case 1: //obstacle is backwards
      if (acceleration.z > 0 || velocity.z > 0) {
        acceleration.z = 0;
        velocity.z = 0;
      }
      break;
    case 2: //obstacle is right
      if (acceleration.x > 0 || velocity.x > 0) {
        acceleration.x = 0;
        velocity.x = 0;
      }
      break;
    case 3: //obstacle is left
      if (acceleration.x < 0 || velocity.x < 0) {
        acceleration.x = 0;
        velocity.x = 0;
      }
      break;
    case 4: //obstacle is up
      if (acceleration.y < 0 || velocity.y < 0) {
        acceleration.y = 0;
        velocity.y = 0;
      }
      break;
    case 5: //obstacle is down
      if (acceleration.y > 0 || velocity.y > 0) {
        acceleration.y = 0;
        velocity.y = 0;
      }
      break;
    default:
    }
  }
}

void updatePhyEntities(ArrayList<phyEntity> entities) {
  phyEntity temp = null;
  for (phyEntity e : entities) {
    e.update();
    if (e instanceof player) {
      player p = (player) e;
      p.update(entities);
    }
    if (e.position.z > 300) {
      e = temp;
    }
  }
  entities.remove(temp);
}
