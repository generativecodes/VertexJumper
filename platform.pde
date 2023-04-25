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

final float wPlatform = 106;
final float hPlatform = 500;
final float dPlatform = 106;

class platform extends phyEntity {

  float rotatingR = 0;
  boolean reverse;

  platform(PVector position, float speedZ) {
    super(position, wPlatform, hPlatform, dPlatform);
    this.velocity.z = speedZ;
    if ( speedZ >= 0)
      this.setColor(backwardsPlatformCol);
    else
      this.setColor(forwardsPlatformCol);

    this.position.y+=250;
  }

  platform(PVector position, float speedZ, float rotatingR, boolean reverse) {
    super(position, wPlatform, hPlatform, dPlatform);
    this.velocity.z = speedZ;
    if ( speedZ >= 0)
      this.setColor(backwardsPlatformCol);
    else
      this.setColor(forwardsPlatformCol);
    this.rotatingR = rotatingR; //rotates arround initial position with that radius
    this.reverse = reverse;
    this.position.y+=250;
  }

  void show() {
    pushMatrix();
    translate(position.x, position.y, position.z);
    stroke(colorStatus);
    strokeWeight(1);
    fill(bg);
    box(sizeX, sizeY, sizeZ);
    popMatrix();
    if (colorStatus!=colorIntent) adjustColor();
    noStroke();
    strokeWeight(0.5);
  }
}
