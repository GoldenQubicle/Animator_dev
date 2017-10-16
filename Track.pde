private class Track
{
  private cp5type control;
  private String Key;
  private String [] Fields;
  private Object obj;

  Track(cp5type control, String[] fields, Object obj, String hk)
  {
    // TODO: type check fields in order to setup different track type (i.e. toggle for bool)    
    this.control = control;
    this.Fields = fields;
    this.obj = obj;
    this.Key = hk;
  }
}

private enum cp5type 
{
  SLIDER, SLIDER2D, COLOR;
};