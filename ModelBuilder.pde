String[] ReadInputLines(String csvFileName)
{
  return loadStrings(csvFileName);
}

class BuiltModel {
  private Map<String, Author> _authors; // TODO: not needed?
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

BuiltModel buildModelFromMetrics(String metricsFileName) {
  Map<String, Author> authors = new HashMap<String, Author>();
  Map<String, FractalEntity> entities = new HashMap<String, FractalEntity>();
  
  String[] metricsAsLines = ReadInputLines(metricsFileName);
  
  for (int i=0; i < metricsAsLines.length; i++) {
    String [] chars=split(metricsAsLines[i],',');
    String entityName = chars[0];
    String author = chars[1];
    int authorRevs = Integer.parseInt(chars[2]);
    int totalRevs = Integer.parseInt(chars[3]);
    double fraction = (double)authorRevs / (double) totalRevs;
    
    String[] parts = split(entityName, "/");
    String shortName = parts[parts.length - 1];
    
    Author a = authors.get(author);
    if (a == null) {
      a = new Author(author);
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
