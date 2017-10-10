private class Track
{
  private cp5type control;
  private String field, field2;
  private Object obj;

  Track(cp5type control, String field, Object obj)
  {
    this.control = control;
    this.field = field;
    this.obj = obj;
  }

  Track(cp5type control, String field, String field2, Object obj)
  {
    this.control = control;
    this.field = field;
    this.field2 = field2;
    this.obj = obj;
  }
}


private enum cp5type 
{
  SLIDER, SLIDER2D, COLOR;
};