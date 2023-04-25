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

final float wPlayer = 20;
final float hPlayer = 40;
final float dPlayer = 20;

class player extends phyEntity {
  float power;
  int jumpCount;

  player(PVector position, float descending, float power) {
    super(position, wPlayer, hPlayer, dPlayer);
    this.descending = descending;
    this.power = power;
    this.setColor(playerCol);
  }

  void update(ArrayList<phyEntity> entities) {
    this.show();
    int obstacle = 6;
    this.falling = true;
    for (phyEntity e : entities) {
      if (e instanceof platform) {
        platform p = (platform) e;
        obstacle = platformCollision(p);
      }
      if (e instanceof wall) {
        wall w = (wall) e;
        obstacle = wallCollision(w);
      }
    }
    if (!falling) jumpCount = 0;
    this.move(obstacle);
  }

  int platformCollision(platform p) {
    int obstacle = 6;
    float[] overlapps = checkAABBCollision(p, this);
    //p.colorStatus = p.colorStatus-20;
    if (overlapps != null) {
      if (this.velocity.y > 0) {
        obstacle = 5;
        this.position.y -= overlapps[1];
        this.falling = false;
      } else if (this.velocity.y < 0) {
        obstacle = 4;
        this.position.y += overlapps[1];
      } else {
        if (this.velocity.x > 0) {
          obstacle = 3;
          this.position.x -= overlapps[0];
        } else if (this.velocity.x < 0) {
          obstacle = 2;
          this.position.x += overlapps[0];
        } else {
          if (this.velocity.z > 0) {
            obstacle = 1;
            this.position.z -= overlapps[2];
          } else if (this.velocity.z < 0) {
            obstacle = 0;
            this.position.z += overlapps[2];
          }
        }
      }
    }
    return obstacle;
  }

  int wallCollision(wall p) {
    int obstacle = 6;
    float[] overlapps = checkAABBCollision(p, this);
    //p.colorStatus = p.colorStatus-20;
    if (overlapps != null) {
      if (this.position.z < p.position.z) {
        obstacle = 1;
        this.position.z -= overlapps[2];
      } else if (this.position.z > p.position.z) {
        obstacle = 0;
        this.position.z += overlapps[2];
      }
    }
    return obstacle;
  }

  float[] checkAABBCollision(phyEntity p, player pl) {
    float[] overlapps = new float[3];
    if (abs(p.position.x - pl.position.x) < p.sizeX/2 + pl.sizeX/2)
    {
      overlapps[0] = abs(abs(p.position.x - pl.position.x) - (p.sizeX/2 + pl.sizeX/2));
      //check the Y axis
      if (abs(p.position.y - pl.position.y) < p.sizeY/2 + pl.sizeY/2)
      {
        overlapps[1] = abs(abs(p.position.y - pl.position.y) - (p.sizeY/2 + pl.sizeY/2));
        //check the Z axis
        if (abs(p.position.z - pl.position.z) < p.sizeZ/2 + pl.sizeZ/2)
        {
          overlapps[2] = abs(abs(p.position.z - pl.position.z) - (p.sizeZ/2 + pl.sizeZ/2));
          return overlapps;
        }
      }
    }
    return null;
  }

  void jump() {
    if (jumpCount<2) {
      this.velocity.y = 0;
      this.acceleration.y-=this.power;
      jumpCount++;
    }
  }

  void left(boolean start) {
    if (start)
      this.acceleration.x-=this.power/3;
    else
      this.acceleration.x+=this.power/3;
  }

  void right(boolean start) {
    if (start)
      this.acceleration.x+=this.power/3;
    else
      this.acceleration.x-=this.power/3;
  }
}
