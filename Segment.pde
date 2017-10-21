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
  protected int wOld, xOld;

  Segment(Controller _c, String track, int fieldId)
  {
    c = _c;
    String field = _c.a.Tracks.get(track).Fields[fieldId];
    Object obj = _c.a.Tracks.get(track).obj;
    String aniKey = "aniSegment" + int(random(1000)); // hacky

    ani = new Ani(obj, _c.a.frames, 0.0, field, 200, Ani.LINEAR);
    ani.setPlayMode(Ani.FORWARD);
    ani.noRepeat();

    easings = c.a.gui.addScrollableList(aniKey)
      .setCaptionLabel("Easings")
      .setGroup("tg"+track)
      .setPosition(0, 25*fieldId)
      .setSize(int(_c.a.wWidth*_c.a.wRight), 50)
      .setItems(EasingNames).setBarHeight(15)
      .onDrag(new CallbackListener() 
    {
      public void controlEvent(CallbackEvent theEvent) 
      {   
        Segment seg = c.Segments.get(theEvent.getController().getName());
        
        if (seg.pos == 1)
        {        
          int newXPos = int(map(c.a.mouseX, 0, c.a.wWidth, 0, theEvent.getController().getParent().getWidth()));
          int newWidth = seg.wOld - newXPos;          
          //println(newXPos, newWidth, seg.wOld);
          seg.easings.setPosition(newXPos, theEvent.getController().getPosition()[1]);
          seg.easings.setWidth(newWidth);
        }
        if (seg.pos == 2)
        {
          int newXPos = c.a.mouseX - int(theEvent.getController().getWidth()/2);
          seg.easings.setPosition(newXPos, theEvent.getController().getPosition()[1]);
        }
        if (seg.pos == 3)
        {
          int newWidth =  theEvent.getController().getPointer().x();
          seg.easings.setWidth(newWidth);
        }
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
        println("clicking");

        c.Segments.get(theEvent.getController().getName()).ani.setEasing(easing[int(theEvent.getController().getValue())]);
      }
    }
    );
    c.Segments.put(aniKey, this);
    //println(c.Segments.size());
  }


  // hmm lets think for a moment
  // basically in the callback (on drag, on click?) get the mouse position, determine in which third it is (i.e. start, mid, end)
  // send that and the segmentKey down to a handler
}