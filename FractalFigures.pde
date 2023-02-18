// Copyright (C) 2014 Adam Tornhill
//
// Distributed under the GNU General Public License v3.0,
// see http://www.gnu.org/licenses/gpl.html

import java.util.Calendar;

// Usage: Launch the sketch and it will prompt you for a file with entity-effort metrics (CSV).
// Each author is assigned a random color.
//
// While the sketch is running, press one of the following options:
// s       : saves the sketch to a timestamped file.
// <space> : re-draws the sketch with new author colors.
//

void setup() {
  size(1200,1200);
  
  selectInput("Select a file with ownership metrics:", "metricsFileSelected"); 
}

File metricsFile = null;

void metricsFileSelected(File selection) {
  if (selection != null) {
    metricsFile = selection;
    loop();
  } 
}

// This sketch if a proof of concept, and never meant to scale.
// Limit to just a few entities so that it at least looks nice.
int maximumEntitiesInSketch = 20;

int fractalWidth = 100;
int fractalHeight = 100;
int offset = 60;
int heightOffset = 10;

void draw() {
  if (metricsFile == null) {
    noLoop();
    return;
  }
  
  background(255);
  
  BuiltModel model = buildModelFromMetrics(metricsFile);
  int usedHeight = presentAuthorColorsFor(model.authors());
  presentFractalsFor(model.entities(), usedHeight);
  
  // Performance: the fractals are heavy => do not re-draw
  noLoop();
}
  
void presentFractalsFor(Map<String, FractalEntity> entities, int usedHeight){
  int usedWidth = 0;
  int xcount = 0;
  
  for(String entityName : entities.keySet()) {
    pushMatrix(); // Note: cannot push more than 32. This is safe as long as maximumEntitiesInSketch is lower. 
    int myXOffset = usedWidth + offset;
    if ((myXOffset + fractalWidth) > width) {
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
}

int presentAuthorColorsFor(Map<String, Author> authors) {
  int usedHeight = 0;
  int acount = 0;
  final int verticalSpace = 14;
  for (String authorName : authors.keySet()) {
    Author author = authors.get(authorName);
    author.activateInDrawing();
    
    final int yPosition = heightOffset + verticalSpace * acount;
    rect(10, yPosition, 10, 10);
    usedHeight += verticalSpace;
   
    int fontSize = 14;
      
    textSize(fontSize);
    fill(0);
    text(authorName, 30, yPosition + 10);
    
    ++acount;
  }
  
  return usedHeight + 20;
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
