public class Storage{
  PVector position;
  float time;
  
  public Storage (float t, float x, float y) {
    time = t;
    position = new PVector (x,y);
  }
} 