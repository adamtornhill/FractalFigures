class Author {
  private String _name;
  private Integer authorColor;

  public Author(String name, Integer authorColor) {
    this._name = name;
    this.authorColor = authorColor;
  } 
  
  public String name() {
    return _name;
  }
  
  public void activateInDrawing() {
    fill(authorColor); 
  }
}
