// Copyright (C) 2014 Adam Tornhill
//
// Distributed under the GNU General Public License v3.0,
// see http://www.gnu.org/licenses/gpl.html

import java.util.Calendar;

// Usage: Prove a CSV file with the entity fragmentation.
// In the current version that information must be stored in
// the file data.csv (yes, I know - I'll fix it sometime).
//
// While the sketch is running, press one of the following options:
// s       : saves the sketch to a timestamped file.
// <space> : re-draws the sketch with new author colors.
//

void setup() {
  size(1200,1200);
}

int fractalWidth = 100;
int fractalHeight = 100;
int offset = 60;

void draw() {
  background(230);
  
  BuiltModel model = buildModelFromMetrics("data.csv");
  presentAuthorColorsFor(model.authors());
  presentFractalsFor(model.entities());
}
  
void presentFractalsFor(Map<String, FractalEntity> entities){
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

void presentAuthorColorsFor(Map<String, Author> authors) {
  int acount = 0;
  for (String authorName : authors.keySet()) {
    Author author = authors.get(authorName);
    author.activateInDrawing();
    
    rect(10, 10*acount, 10, 10);
   
    int fontSize = 14;
      
    textSize(fontSize);
    fill(0);
    text(authorName, 30, 10*acount + 10);
    
    ++acount;
  }
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

