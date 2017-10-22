private class Segment
{
  Controller c;
  Easing[] easing = { Ani.LINEAR, Ani.QUAD_IN, Ani.QUAD_OUT, Ani.QUAD_IN_OUT, Ani.CUBIC_IN, Ani.CUBIC_IN_OUT, Ani.CUBIC_OUT, Ani.QUART_IN, Ani.QUART_OUT, Ani.QUART_IN_OUT, Ani.QUINT_IN, Ani.QUINT_OUT, Ani.QUINT_IN_OUT, Ani.SINE_IN, Ani.SINE_OUT, Ani.SINE_IN_OUT, Ani.CIRC_IN, Ani.CIRC_OUT, Ani.CIRC_IN_OUT, Ani.EXPO_IN, Ani.EXPO_OUT, Ani.EXPO_IN_OUT, Ani.BACK_IN, Ani.BACK_OUT, Ani.BACK_IN_OUT, Ani.BOUNCE_IN, Ani.BOUNCE_OUT, Ani.BOUNCE_IN_OUT, Ani.ELASTIC_IN, Ani.ELASTIC_OUT, Ani.ELASTIC_IN_OUT};
  String[] EasingNames = {"LINEAR", "QUAD_IN", "QUAD_OUT", "QUAD_IN_OUT", "CUBIC_IN", "CUBIC_IN_OUT", "CUBIC_OUT", "QUART_IN", "QUART_OUT", "QUART_IN_OUT", "QUINT_IN", "QUINT_OUT", "QUINT_IN_OUT", "SINE_IN", "SINE_OUT", "SINE_IN_OUT", "CIRC_IN", "CIRC_OUT", "CIRC_IN_OUT", "EXPO_IN", "EXPO_OUT", "EXPO_IN_OUT", "BACK_IN", "BACK_OUT", "BACK_IN_OUT", "BOUNCE_IN", "BOUNCE_OUT", "BOUNCE_IN_OUT", "ELASTIC_IN", "ELASTIC_OUT", "ELASTIC_IN_OUT"};

  protected float Duration;
  protected float Start;
  protected float End;   
  protected ScrollableList easings;
  protected Ani ani;
  protected int pos = 0;
  protected int wOld, xOld, pX;
  private String aniKey, trackKey, Field;

  Segment(Controller _c, String track, int fieldId)
  {
    c = _c;
    trackKey = track;
    aniKey = trackKey + " segment" + c.a.Tracks.get(trackKey).getSegId();

    Object obj = _c.a.Tracks.get(trackKey).obj;
    Field = _c.a.Tracks.get(trackKey).Fields[fieldId];

    ani = new Ani(obj, Duration, Start, Field, 200, Ani.LINEAR);
    ani.setPlayMode(Ani.FORWARD);
    ani.noRepeat();

    easings = c.a.gui.addScrollableList(aniKey)
      .setCaptionLabel("Easings")
      .setGroup("tg"+trackKey)
      .setPosition(0, 25*fieldId)
      .setSize(int(_c.a.wWidth*_c.a.wRight), 50)
      .setItems(EasingNames).setBarHeight(15)
      .onDrag(new CallbackListener() 
    {
      public void controlEvent(CallbackEvent theEvent) 
      {   
        Segment seg = c.Segments.get(theEvent.getController().getName());
        int trackWidth =  theEvent.getController().getParent().getWidth();
        if (seg.pos == 1)
        {        
          int mX = int(map(c.a.mouseX, 0, c.a.wWidth, int((c.a.wWidth*c.a.wLeft)), trackWidth));
          int newXPos = constrain(mX - seg.pX, 0, trackWidth) ;
          int newWidth = (seg.wOld - newXPos) + seg.xOld; 
          seg.easings.setPosition(newXPos, theEvent.getController().getPosition()[1]);
          seg.easings.setWidth(newWidth);
        }
        if (seg.pos == 2)
        {
          int mX = int(map(c.a.mouseX, 0, c.a.wWidth, int((c.a.wWidth*c.a.wLeft)), theEvent.getController().getParent().getWidth()));
          int newXPos = constrain(mX - seg.wOld/2, 0, trackWidth-seg.wOld) ;
          seg.easings.setPosition(newXPos, theEvent.getController().getPosition()[1]);
        }
        if (seg.pos == 3)
        {
          int mX = theEvent.getController().getPointer().x() - seg.pX;
          int newWidth = constrain(seg.wOld + mX, 0, trackWidth-seg.xOld);
          seg.easings.setWidth(newWidth);
        }
        updateAni(seg, trackWidth);
      }
    }
    )
    .onRelease(new CallbackListener() 
    {
      public void controlEvent(CallbackEvent theEvent) 
      {
      }
    }
    )
    .onClick(new CallbackListener() 
    {
      public void controlEvent(CallbackEvent theEvent) 
      {   
        c.Segments.get(theEvent.getController().getName()).ani.setEasing(easing[int(theEvent.getController().getValue())]);
      }
    }
    );
    c.Segments.put(aniKey, this);
  }

  void updateAni(Segment seg, int trackWidth)
  {
    Start = int(map(seg.easings.getPosition()[0], 0, trackWidth, 0, c.a.frames));
    End = int(map(seg.easings.getPosition()[0]+seg.easings.getWidth(), 0, trackWidth, 0, c.a.frames));
    Duration = End - Start;
    ani.setDelay(Start);
    ani.setDuration(Duration);
  }
}