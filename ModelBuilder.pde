String[] ReadInputLines(File csvFile)
{
  return loadStrings(csvFile.getAbsolutePath());
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

int asInt(String raw) {
  return Integer.parseInt(trim(raw));
}

Map<String, Integer> readAuthorColorsFrom(File authorColorsFile) {
  
  Map<String, Integer> authorColors = new HashMap<String, Integer>();
  String[] colorConfigLines = ReadInputLines(authorColorsFile);
  
  for (int i=0; i < colorConfigLines.length; i++) {
    String [] chars=split(colorConfigLines[i],',');
    String author = chars[0];
    int r = asInt(chars[1]);
    int g = asInt(chars[2]);
    int b = asInt(chars[3]);
    
    authorColors.put(author, color(r,g,b));
  }
  
  return authorColors;
}

BuiltModel buildModelFromMetrics(File metricsFile, File authorColorsFile) {
  Map<String, Author> authors = new HashMap<String, Author>();
  Map<String, FractalEntity> entities = new HashMap<String, FractalEntity>();
  
  Map<String, Integer> authorColors = readAuthorColorsFrom(authorColorsFile);
  
  String[] metricsAsLines = ReadInputLines(metricsFile);
  
  // Skip the heading (first line)
  for (int i=1; i < metricsAsLines.length; i++) {
    String [] chars=split(metricsAsLines[i],',');
    String entityName = chars[0];
    String author = chars[1];
    int authorRevs = asInt(chars[2]);
    int totalRevs = asInt(chars[3]);
    double fraction = (double)authorRevs / (double) totalRevs;
    
    String[] parts = split(entityName, "/");
    String shortName = parts[parts.length - 1];
    
    Author a = authors.get(author);
    if (a == null) {
      a = makeColoredAuthorFrom(author, authorColors.get(author));
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

Author makeColoredAuthorFrom(String authorName, Integer authorColor) {
  if (authorColor != null) {
    return new Author(authorName, authorColor);
  }
  
  return new Author(authorName, color(0, 0, 0));
}
