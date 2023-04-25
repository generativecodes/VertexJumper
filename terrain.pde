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

class terrain {

  PShape terra;


  int cols, rows;
  int scl = 20;
  int w_3 = 420;
  int w = w_3*3;
  int h_real = 5000;
  int cameraSpace = 600;
  int h = h_real + cameraSpace;
  float flying = 0;
  float [][] terrain;

  float speed;

  PVector position;

  terrain(float speed) {
    terra = createShape();
    position = new PVector(0, 0, 0);
    cols = w / scl;
    rows = h/ scl;
    terrain = new float[cols][rows];

    this.speed = speed;
    float zoff = flying;
    for (int z = 0; z < rows; z++) {
      float xoff = 0;
      for (int x = 0; x < cols; x++) {
        terrain[x][z] = map(noise(xoff, zoff), 0, 1, -150, 150);
        xoff += 0.2;
      }
      zoff += 0.09;
    }

    for (int z = 0; z < rows-1; z++) {
      terra.beginShape(TRIANGLE_STRIP);
      for (int x = 0; x < cols; x++) {
        float valley = 0;
        if (x<cols / 2) valley = x*x;
        else valley = (cols-x)*(cols-x);
        terra.vertex(x*scl -w_3 + position.x, terrain[x][z]   + valley + position.y, z*scl     -1500  + position.z);
        terra.vertex(x*scl -w_3 + position.x, terrain[x][z+1] + valley + position.y, (z+1)*scl -1500  + position.z);
        //rect(x*scl, y*scl, scl, scl);
      }
      terra.endShape();
    }
  }

  void addTerrain() {
    for (int z = rows-2; z >=0; z--) {
      for (int x = 0; x < cols; x++) {
        terrain[x][z+1] = terrain[x][z];
      }
    }
    float xoff=0;
    for (int x = 0; x < cols; x++) {
      terrain[x][0] = map(noise(xoff, flying), 0, 1, -150, 150);
      xoff+=0.2;
    }
    flying-=0.09;
    this.position.z+=scl;
  }

  void show() {

    fill(bg);
    stroke(#8F94FB);
    strokeWeight(0.2);
    for (int z = 0; z < rows-1; z++) {
      beginShape(TRIANGLE_STRIP);
      for (int x = 0; x < cols; x++) {
        float valley = 0;
        if (x<cols / 2) valley = x*x;
        else valley = (cols-x)*(cols-x);
        if(valley > width + 200)valley = width +200;
        vertex(x*scl -w_3 + position.x, terrain[x][z]   + valley + position.y, z*scl     -h_real  - position.z);
        vertex(x*scl -w_3 + position.x, terrain[x][z+1] + valley + position.y, (z+1)*scl -h_real  - position.z);
        //rect(x*scl, y*scl, scl, scl);
      }
      endShape();
    }
    //shape(terra, 0, 0);
  }

  void move() {
    position.z -= speed;
    if(position.z<=-scl) addTerrain();
  }
}
