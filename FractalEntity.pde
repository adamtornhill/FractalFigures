import java.util.*;

// TODO: consider injecting a size metric!

class FractalEntity {
   private String name; 
   private List<FractalPart> parts = new ArrayList<FractalPart>();
   
   public FractalEntity(String name) {
     this.name = name;
   }
   
   public void add(FractalPart part) {
     parts.add(part);
   }
   
   public int draw(boolean adjustText) {
      sortPartsBySize();
     
      rect(0, 0, fractalWidth, fractalHeight);
      drawFractals(0, fractalWidth, fractalHeight);
      
      fill(10);
      int adjustment = adjustText ? 30 : 15;
      int fontSize = 14;
      int textXplacement = offset - (fractalWidth / 2);
      
      textSize(fontSize);
      text(name, textXplacement, fractalHeight + adjustment);
      
      return fractalWidth; // TODO: return the whole box
  }
  
  private class FractalComparator implements Comparator<FractalPart> {
    @Override
    public int compare(FractalPart o1, FractalPart o2) {
        // sort in descending order
        final Float f2 = o2.fraction;
        final Float f1 = o1.fraction;
        
        return f2.compareTo(f1);
    }
  }
  
  private void sortPartsBySize() {
    Collections.sort(parts, new FractalComparator());
  }

  private void drawFractals(int fi, float xleft, float yleft) {
    if (fi >= parts.size()) {
      return; // terminate the recursion
    }
   
    pushMatrix();
    
    FractalPart fractal = parts.get(fi);
    Author author = fractal.author;
    author.activateInDrawing();
    
    if ((fi % 2) == 0) {
      float yLen = yleft;
      float xLen = calcFractalSide(yLen, fractal.fraction);
    
      rect(0,0,xLen,yLen);
      translate(xLen, 0);
      drawFractals(++fi, xleft - xLen, yleft); // doesn't consume Y
    }
    else {
      float xLen = xleft;
      float yLen = calcFractalSide(xLen, fractal.fraction);
    
      rect(0,0,xLen,yLen);
      translate(0, yLen);
      drawFractals(++fi, xleft, yleft - yLen); // doesn't consume X
    }
    popMatrix();
  }
  
  private float calcFractalSide(float knownSide, float fractal) {
    float area = fractalWidth * fractalHeight;
    return (fractal * area) / knownSide;
  }
}
