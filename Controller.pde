private class Controller
{
  Animator a;
  private Map<String, Segment>Segments;
  private int needleX, needleY, needleH;
  private int trackHeight = 25;
  private int cPosY = 10;
  private int spacing = 10;
  private int tPosY;
  private PFont font;
  Ani ani;

  Controller(Animator _a)
  {
    a = _a;
    Segments = new HashMap<String, Segment>();
    needleX = int(a.wWidth*a.wLeft);
    needleY = int(a.wHeight/2);
    needleH = a.cHeight/2;
    font = createFont("Symbola.ttf", 128);
  }


  void setupTracks()
  {
    tPosY = a.wHeight/2 + a.cHeight + spacing;

    for (Track t : a.Tracks.values())
    {
      timeLine(t.Key);
      switch(t.control)
      {
      case SLIDER:
        addSlider(t.Key, t.Field);
        break;
      case SLIDER2D:
        addSlider2D(t.Key, t.Field, t.Field2);
        break;
      case COLOR:
        break;
      }
      tPosY += (trackHeight + spacing*2);
      cPosY += (trackHeight + spacing*2);
    }
  }       

  void addSlider2D(String target, String field_1, String field_2)
  {
    //println(target, field_1, field_2);
    a.gui.addGroup("Control "+ target).setPosition(int(a.wWidth*a.wLeft), cPosY).setSize(int((a.wWidth/4)), int(a.wWidth/4)).setBackgroundColor(color(255, 50)).disableCollapse();
    a.gui.addSlider2D(target).setGroup("Control "+ target).setPosition(5, 5).setSize(int((a.wWidth/4)*a.wRight), int((a.wWidth/4)*a.wRight)).setValue(getTargetValue(target, field_1), getTargetValue(target, field_2))
      .onChange(new CallbackListener()
    {
      public void controlEvent(CallbackEvent theEvent) 
      {
        if (theEvent.getAction()==ControlP5.ACTION_BROADCAST)
        {
          String target = theEvent.getController().getName();
          float value1 = theEvent.getController().getArrayValue()[0];
          float value2 = theEvent.getController().getArrayValue()[1];
          setTargetValue(target, a.Tracks.get(target).Field, value1);
          setTargetValue(target, a.Tracks.get(target).Field2, value2);
          ;
        }
      }
    }
    );
    if (a.minmax.containsKey(target))
    {
      a.gui.get(Slider2D.class, target).setMinMax(a.minmax.get(target)[0], a.minmax.get(target)[2], a.minmax.get(target)[1], a.minmax.get(target)[3]);
    }
  }

  void addSlider(String target, String field)
  {
    a.gui.addGroup("Control "+ target).setCaptionLabel(field).setPosition(int(a.wWidth*a.wLeft), cPosY).setSize(int((a.wWidth/2)), trackHeight).setBackgroundColor(color(255, 50)).disableCollapse();
    a.gui.addSlider(target).setCaptionLabel("").setGroup("Control "+ target).setPosition(5, 5).setSize(int((a.wWidth/2)*a.wRight), 10).setValue(getTargetValue(target, field))
      .onChange(new CallbackListener()
    {
      public void controlEvent(CallbackEvent theEvent) 
      {
        if (theEvent.getAction()==ControlP5.ACTION_BROADCAST)
        {
          String target = theEvent.getController().getName();
          String field = a.gui.get(Group.class, theEvent.getController().getParent().getName()).getCaptionLabel().getText();
          float value = theEvent.getController().getValue();
          setTargetValue(target, field, value);
        }
      }
    }
    );

    if (a.minmax.containsKey(target))
    {
      a.gui.get(Slider.class, target).setRange(a.minmax.get(target)[0], a.minmax.get(target)[1]);
    }
  }

  void timeLine(String target)
  {
    a.gui.addGroup("Track "+ target).setPosition(int(a.wWidth*a.wLeft), tPosY).setSize(int(a.wWidth*a.wRight), trackHeight).setBackgroundColor(color(255, 50)).disableCollapse();
    a.gui.addButton(target + "add").setCaptionLabel(" +").setPosition(-15, 0).setSize(15, 15).setGroup("Track " + target)
      .onClick(new CallbackListener() 
    {
      public void controlEvent(CallbackEvent theEvent) 
      {
        String target = theEvent.getController().getName();    
        target = target.substring(0, target.length()-3);
        Segment seg = new Segment(a.controller, target);
      }
    }
    );
  }

  float getTargetValue(String target, String field)
  {
    float targetValue = 0;
    try
    {
      Field f = a.Tracks.get(target).obj.getClass().getDeclaredField(field);
      f.setAccessible(true);
      targetValue = f.getFloat(a.Tracks.get(target).obj);
    } 
    catch(Exception e)
    {
      println(e, "in getter");
    }   
    return targetValue;
  }

  void setTargetValue(String target, String field, float value)
  {
    Object obj = a.Tracks.get(target).obj;
    Class cls = obj.getClass();
    for (int i = 0; i < cls.getDeclaredFields().length; i++)
    {
      if (cls.getDeclaredFields()[i].getName().equals(field))
      {        
        Field f = cls.getDeclaredFields()[i];
        f.setAccessible(true);
        try 
        {
          f.set(obj, value);
        } 
        catch(Exception e)
        {
          println(e, "in setter");
        }
      }
    }
  }

  void scrollTimeLine(float mX, float mY, boolean mP) 
  {        
    a.stroke(2);
    a.line(needleX, needleY-needleH, needleX, needleY+needleH);
    if (mX > needleX-20 && mX < needleX+20 && mP && a.master.isPlaying() && (mY > needleY-needleH && mY < needleY+needleH))
    {
      a.master.pause();
      for (Segment segment : Segments.values())
      {
        segment.ani.pause();
      }
    }
    if (mX > needleX-20 && mX < needleX+20 && (mY > needleY-needleH && mY < needleY+needleH))
    {
      a.noStroke();
      a.fill(255, 64);
      a.rect(needleX-5, needleY-needleH, 10, needleH*2);
    }
    if (mP && (mX > needleX-35 && mX < needleX+35) && (mY > needleY-needleH && mY < needleY+needleH))
    {      
      a.noStroke();
      a.fill(255, 128);
      a.rect(needleX-5, needleY-needleH, 10, needleH*2);

      a.master.seek(map(mX, a.wWidth*a.wLeft, a.wWidth*a.wRight, 0, 1));
      for (Segment segment : Segments.values())
      {
        segment.ani.seek(map(mX, a.wWidth*a.wLeft, a.wWidth*a.wRight, 0, 1));
      }
    }
    if (a.master.isEnded())
    {
      a.isPlaying = false;
    }
  }

  void playpause()
  {
    if (!a.master.isPlaying() && !a.isPlaying)
    {
      a.isPlaying = true;
      a.master.start();
      for (Segment segment : Segments.values())
      {
        segment.ani.start();
      }
    } else if (a.master.isPlaying() && a.isPlaying)
    {
      a.master.pause();
      for (Segment segment : Segments.values())
      {
        segment.ani.pause();
      }
    } else if (!a.master.isPlaying() && a.isPlaying) 
    {
      a.master.resume();
      for (Segment segment : Segments.values())
      {
        segment.ani.resume();
      }
    }
  }
}