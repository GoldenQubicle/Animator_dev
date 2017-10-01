abstract class Track
{
  protected String name;  
  protected float width;
  protected float height;
  protected ArrayList<aniSegment>Segments;
  protected Button add;
  protected Button delete;   
  protected Group track; 
}

class trackGroup extends Track
{
  trackGroup(String field)
  {
    name = field;
    //track = gui.add
  } 
 
}