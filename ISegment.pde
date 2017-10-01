abstract class Segment
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

class cp5Segment extends Segment
{
  cp5Segment(ScrollableList _eas)
  {
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

class aniSegment extends Segment
{
  aniSegment() 
  {
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