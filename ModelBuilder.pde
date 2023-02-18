String[] ReadInputLines(File csvFile)
{
  return loadStrings(csvFile.getAbsolutePath());
}

class BuiltModel {
  private Map<String, Author> _authors;
  Map<String, FractalEntity> _entities;
  
  public BuiltModel(Map<String, Author> a, Map<String, FractalEntity> e) {
    _authors = a;
    _entities = e;
  }
  
  public Map<String, Author> authors() {
    return _authors;
  }
  
  public Map<String, FractalEntity> entities() {
    return _entities;
  }
}

int asInt(String raw) {
  return Integer.parseInt(trim(raw));
}


BuiltModel buildModelFromMetrics(File metricsFile) {
  Map<String, Author> authors = new HashMap<String, Author>();
  Map<String, FractalEntity> entities = new HashMap<String, FractalEntity>();
    
  String[] metricsAsLines = ReadInputLines(metricsFile);
  
  // Skip the heading (first line)
  for (int i=1; i < metricsAsLines.length; i++) {
    String [] chars=split(metricsAsLines[i],',');
    String entityName = chars[0];
    String author = chars[1];
    int authorRevs = asInt(chars[2]);
    int totalRevs = asInt(chars[3]);
    float fraction = (float)authorRevs / (float) totalRevs;
    
    String[] parts = split(entityName, "/");
    String shortName = parts[parts.length - 1];
    
    Author a = authors.get(author);
    if (a == null) {
      a = makeColoredAuthorFor(author);
      authors.put(author, a);
    }
    
    FractalPart part = new FractalPart(fraction, a);
    FractalEntity entity = entities.get(entityName);
    
    if (entity == null) {
      entity = new FractalEntity(shortName);
      entities.put(entityName, entity);
    }
    
    entity.add(part);
  }
  
  return new BuiltModel(authors, entities);
}

Author makeColoredAuthorFor(String authorName) {
  int authorColor = makeRandomColor();
  
  return new Author(authorName, authorColor);
}

int makeRandomColor() {
  float goldenRatioConjugate = 0.618033988749895;
  float hrand = random(1.0) + goldenRatioConjugate;
  hrand %= 1;
  
  colorMode(HSB);
  return color(map(hrand, 0.0, 1.0, 0.0, 360.0), random(500), random(500));
}
