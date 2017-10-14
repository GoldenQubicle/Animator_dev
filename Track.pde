private class Track
{
  private cp5type control;
  private String Field, Field2, Key;
  private Object obj;

  Track(cp5type control, String field, Object obj, String hk)
  {
    this.control = control;
    this.Field = field;
    this.obj = obj;
    this.Key = hk;
  }

  Track(cp5type control, String field, String field2, Object obj, String hk)
  {
    this.control = control;
    this.Field = field;
    this.Field2 = field2;
    this.obj = obj;
    this.Key = hk;
  }
}

private enum cp5type 
{
  SLIDER, SLIDER2D, COLOR;
};