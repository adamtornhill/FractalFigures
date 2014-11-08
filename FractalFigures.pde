// Copyright (C) 2014 Adam Tornhill
//
// Distributed under the GNU General Public License v3.0,
// see http://www.gnu.org/licenses/gpl.html

import java.util.Calendar;

// Usage: You need to provide two files: one with the entity-effort metrics and 
//        one with the color to use for each author in the metrics file.
//        Both files must be on the documented CSV format (error handling is 
//        (almost) non-existent.
//
// While the sketch is running, press one of the following options:
// s       : saves the sketch to a timestamped file.
// <space> : re-draws the sketch with new author colors.
//

void setup() {
  size(1200,1200);
  
  selectInput("Select a file with author colors:", "authorFileSelected");
}

File authorFile = null;

void authorFileSelected(File selection) {
  // Don't care if the user didn't provide a color mapping => we'll generate random colors 
  // as a fallback.
  authorFile = selection;
  selectInput("Select a file with ownership metrics:", "metricsFileSelected"); 
}

File metricsFile = null;

void metricsFileSelected(File selection) {
  if (selection != null) {
    metricsFile = selection;
    loop();
  } 
}

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
  
  BuiltModel model = buildModelFromMetrics(metricsFile, authorFile);
  int usedHeight = presentAuthorColorsFor(model.authors());
  presentFractalsFor(model.entities(), usedHeight);
  
  // Performance: the fractals are heavy => do not re-draw
  noLoop();
}
  
void presentFractalsFor(Map<String, FractalEntity> entities, int usedHeight){
  int usedWidth = 0;
  int xcount = 0;
  
  for(String entityName : entities.keySet()) {
    pushMatrix();
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
  // END 
}

int presentAuthorColorsFor(Map<String, Author> authors) {
  int usedHeight = 0;
  int acount = 0;
  for (String authorName : authors.keySet()) {
    Author author = authors.get(authorName);
    author.activateInDrawing();
    
    rect(10, heightOffset + 10*acount, 10, 10);
    usedHeight += 10;
   
    int fontSize = 14;
      
    textSize(fontSize);
    fill(0);
    text(authorName, 30, heightOffset + 10*acount + 10);
    usedHeight += 10;
    
    ++acount;
  }
  
  return usedHeight + heightOffset;
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

