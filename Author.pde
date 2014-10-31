int makeRandomColor() {
  float goldenRatioConjugate = 0.618033988749895;
  float hrand = random(1.0) + goldenRatioConjugate;
  hrand %= 1;
  
  colorMode(HSB);
  return color(map(hrand, 0.0, 1.0, 0.0, 360.0), random(500), random(500));
}

class Author {
  private String _name;
  private int authorColor;
 
  public Author(String name) {
    this._name = name;
    authorColor = makeRandomColor(); 
  } 
  
  public String name() {
    return _name;
  }
  
  public void activateInDrawing() {
     fill(authorColor); 
  }
}
