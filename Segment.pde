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

  Segment(Controller _c, String track)
  {
    c = _c;
    String field = track.substring(6, track.length());
    Object obj = _c.a.tracks.get(field);
    String k = track + random(1000);

    ani = new Ani(obj, _c.a.frames, 0.0, field, 200, Ani.LINEAR);
    ani.setPlayMode(Ani.FORWARD);
    ani.noRepeat();

    c.a.gui.addScrollableList(k).setGroup(track).setPosition(0, 0).setSize(int(_c.a.wWidth*_c.a.wRight), 50).setItems(EasingNames).setBarHeight(15)
      .onClick(new CallbackListener() 
    {
      public void controlEvent(CallbackEvent theEvent) 
      {   
        c.Segments.get(theEvent.getController().getName()).ani.setEasing(easing[int(theEvent.getController().getValue())]);
      }
    }
    );

    c.Segments.put(k, this);
  }
}