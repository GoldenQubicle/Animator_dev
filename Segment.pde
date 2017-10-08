abstract class Segment extends Animator
{

  protected float Duration;
  protected float Start;
  protected float End;   
  protected ScrollableList easings;
  protected Ani ani;
  abstract void moveStart();
  abstract void moveEnd();
  abstract void moveWhole();
}

private class cp5Segment extends Segment
{
  cp5Segment(ScrollableList _eas)
  {
    super();
    this.easings = _eas;
  }
  void moveStart() 
  {
  }
  void moveEnd() 
  {
  }
  void moveWhole() 
  {
  }
  void setEasing(float easing)
  {
    this.easings.setValue(easing);
  }
  float getEasing()
  {
    return this.easings.getValue();
  }
}

private class aniSegment extends Segment
{
  aniSegment() 
  {

  }
  
  Ani create (Object obj, int frames, String field, float value, int _k) 
  {
    ani = new Ani(obj, frames, 0.0, field, value, Ani.LINEAR);
    ani.setPlayMode(Ani.FORWARD);
    ani.noRepeat();
    return ani;
    //controller.aniSegments.put(_k, this);
  }
  void moveStart() 
  {
  }

  void moveEnd() 
  {
  }

  void moveWhole() 
  {
  }
}