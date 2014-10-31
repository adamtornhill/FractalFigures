// Copyright (C) 2013 Adam Tornhill
//
// Distributed under the GNU General Public License v3.0,
// see http://www.gnu.org/licenses/gpl.html

import java.util.Calendar;

void setup() {
  size(1200,1200);
}

int fractalWidth = 100;
int fractalHeight = 100;
int offset = 60;

double[] fractals = {0.8, 0.1, 0.05, 0.02, 0.01, 0.01, 0.01};

double[] fractals2 = {0.3, 0.2, 0.15, 0.1, 0.1, 0.05, 0.05, 0.03, 0.02};

double[] fractals3 = {0.4, 0.2, 0.2, 0.2};

double[] fractals4 = {0.05, 0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,
0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05};

double[] fractals5 = {0.6, 0.4};

void draw() {
  background(230);
  
  //drawFractal(fractals, "Major Developer", 0);
  //drawFractal(fractals2, "Many, balanced", 1);
  //drawFractal(fractals3, "Few, balanced", 2); 
  //drawFractal(fractals4, "Collective Chaos", 3); 
  //drawFractal(fractals5, "Balance", 4);
 
  // NEW
  BuiltModel model = buildModelFromMetrics("data.csv");
  
  Map<String, Author> authors = model.authors();
  
  int acount = 0;
  for (String authorName : authors.keySet()) {
    Author author = authors.get(authorName);
    author.activateInDrawing();
    
    rect(10, 10*acount, 10, 10);
    // -
      int fontSize = 14;
      
      textSize(fontSize);
      fill(0);
      text(authorName, 30, 10*acount + 10);
    // -
    
    ++acount;
  }
  
  Map<String, FractalEntity> entities = model.entities();
  
  int usedWidth = 0;
  int usedHeight = offset;
  int xcount = 0;
  
  for(String entityName : entities.keySet()) {
    pushMatrix();
    int myXOffset = usedWidth + offset;
    if ((myXOffset + fractalWidth) > width) {
      println("new line for " + entityName);
      myXOffset = offset;
      usedWidth = 0;
      usedHeight += fractalHeight + offset;
      xcount = 0;
    }
    translate(myXOffset, usedHeight); // Y in case we've too many
  
    FractalEntity entity = entities.get(entityName);
    usedWidth += entity.draw(xcount % 2 == 0);
    usedWidth += offset;
    ++xcount;
    
    popMatrix();
  }
  // END 
  
  // Performance: the fractals are heavy => do not re-draw
  noLoop();
}

void keyReleased() {
  if (key == 's') {
    saveFrame("map_" + timestamp() + ".png");
    return;
  }
  
  // re-draw for all other keys:
  loop();
}

String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}

void drawFractal(double[] fractalsToDraw, String name, int order) {
  pushMatrix();
  int myOffset = offset*order + offset;
  translate(fractalWidth*order + myOffset, offset); // Y in case we've too many
  rect(0, 0, fractalWidth, fractalHeight);
  drawFractals(0, fractalsToDraw, fractalWidth, fractalHeight);
  
  fill(0);
  text(name, 0, fractalHeight + 15);

  popMatrix();
}

void drawFractals(int fi, double[] fractalsToDraw, int xleft, int yleft) {
  if (fi >= fractalsToDraw.length)
    return; // terminate the recursion
 
  pushMatrix();
  
  float goldenRatioConjugate = 0.618033988749895;
  float hrand = random(1.0) + goldenRatioConjugate;
  hrand %= 1;
  
  colorMode(HSB);
  fill(map(hrand, 0.0, 1.0, 0.0, 360.0), random(500), random(500));
  
  double fractal = fractalsToDraw[fi];
  
  if ((fi % 2) == 0) {
    int yLen = yleft;
    int xLen = calcFractalSide(yLen, fractal);
  
    //fill(255,fi*20,0);
    rect(0,0,xLen,yLen);
    translate(xLen, 0);
    drawFractals(++fi, fractalsToDraw, xleft - xLen, yleft); // doesn't consume Y
  }
  else {
    int xLen = xleft;
    int yLen = calcFractalSide(xLen, fractal);
  
    //fill(0,fi*20,255);
    rect(0,0,xLen,yLen);
    translate(0, yLen);
    drawFractals(++fi, fractalsToDraw, xleft, yleft - yLen); // doesn't consume X
  }
  popMatrix();
}

int calcFractalSide(int knownSide, double fractal) {
  int area = fractalWidth * fractalHeight;
  return (int) (fractal * area) / knownSide;
}
