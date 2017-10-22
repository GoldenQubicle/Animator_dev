private class Controller
{
  Animator a;
  private Map<String, Segment>Segments;
  private int needleX, needleY, needleH;
  private int trackHeight = 25;
  private int cPosY = 10;
  private int spacing = 10;
  private int tPosY, itemSelected;
  private  AniSequence seq;

  Controller(Animator _a)
  {
    a = _a;
    Segments = new HashMap<String, Segment>();
    needleX = int(a.wWidth*a.wLeft);
    needleY = int(a.wHeight/2);
    needleH = a.cHeight/2;
    itemSelected = 0 ;
  }

  void setupTracks()
  {
    tPosY = a.wHeight/2 + a.cHeight + spacing;

    for (Track t : a.Tracks.values())
    {
      trackGroup(t.Key, t.Fields);
      switch(t.control)
      {
      case SLIDER:
        addSlider(t.Key, t.Fields[0]);       
        break;
      case SLIDER2D:
        addSlider2D(t.Key, t.Fields[0], t.Fields[1]);
        break;
      case COLOR:
        break;
      }
      tPosY += (trackHeight*t.Fields.length + spacing*2);
      cPosY += (trackHeight + spacing*2);
    }
  }       

  void addSlider(String target, String field)
  {
    a.gui.addGroup(target)
      .setPosition(int(a.wWidth*a.wLeft), cPosY)
      .setSize(int((a.wWidth/2)), trackHeight)
      .setBackgroundColor(color(255, 50))
      .disableCollapse();    

    a.gui.addSlider(field)
      .setGroup(target)
      .setPosition(5, 5)
      .setSize(int((a.wWidth/2)*a.wRight), 10)
      .setValue(getTargetValue(target, field))
      .plugTo(a.Tracks.get(target).obj, field);

    segmentSelector(target, field);

    if (a.minmax.containsKey(target))
    {
      a.gui.get(Slider.class, field)
        .setRange(a.minmax.get(target)[0], a.minmax.get(target)[1]);
    }
  }

  void addSlider2D(String target, String field_1, String field_2)
  {
    a.gui.addGroup(target)
      .setPosition(int(a.wWidth*a.wLeft), cPosY)
      .setSize(int((a.wWidth/4)), int(a.wWidth/4)) // BAAAD dont make this depenend on window width!
      .setBackgroundColor(color(255, 50))
      .disableCollapse();

    a.gui.addSlider2D(target+"2d")
      .setGroup(target).setPosition(5, 5)
      .setSize(int((a.wWidth/4)*a.wRight), int((a.wWidth/4)*a.wRight))
      .setValue(getTargetValue(target, field_1), getTargetValue(target, field_2))   
      .onChange(new CallbackListener()
    {
      public void controlEvent(CallbackEvent theEvent) 
      {
        if (theEvent.getAction()==ControlP5.ACTION_BROADCAST)
        {
          String target = theEvent.getController().getParent().getName();
          float value1 = theEvent.getController().getArrayValue()[0];
          float value2 = theEvent.getController().getArrayValue()[1];
          setTargetValue(target, a.Tracks.get(target).Fields[0], value1);
          setTargetValue(target, a.Tracks.get(target).Fields[1], value2);
          ;
        }
      }
    }
    );    
    segmentSelector(target, field_1);
    segmentSelector(target, field_2);

    if (a.minmax.containsKey(target))
    {
      a.gui.get(Slider2D.class, target+"2d")
        .setMinMax(a.minmax.get(target)[0], a.minmax.get(target)[2], a.minmax.get(target)[1], a.minmax.get(target)[3]);
    }
  }

  void segmentSelector(String target, String field)
  {
    String [] items = new String[] {"no segments"};
    a.gui.addScrollableList(target + "seg" + field)
      .setGroup(target)
      .setPosition(int((a.wWidth/2))+50, 5)
      .addItems(items)
      .onClick(new CallbackListener() 
    {
      public void controlEvent(CallbackEvent theEvent) 
      {
        if (theEvent.getController().getValue() != itemSelected && theEvent.getController().getValue() > 0)
        {

          for (Segment seg : Segments.values())
          {
            seg.easings.setColor(ControlP5.THEME_CP52014);
          }                     

          itemSelected = int(theEvent.getController().getValue());
          ScrollableList segments = a.gui.get(ScrollableList.class, theEvent.getController().getName());
          Map <String, Object>item = segments.getItem(itemSelected); 
          Segment seg = Segments.get(item.get("name"));

          a.gui.getController(seg.Field).setValue(seg.ani.getEnd()); // be aware this is NOT going to work for slider2D
                
          seg.easings.setColorBackground(ControlP5.RED);
          seg.easings.setColorForeground(ControlP5.RED);
          seg.ani.setEnd(getTargetValue(seg.trackKey, seg.Field));
        } else if (theEvent.getController().getValue() == 0)
        {
          itemSelected = int(theEvent.getController().getValue());

          for (Segment seg : Segments.values())
          {
            seg.easings.setColor(ControlP5.THEME_CP52014);
          }
        }
      }
    }
    );
  }

  void trackGroup(String target, String[] fields)
  {   
    String trackGroup = "tg"+target;

    a.gui.addGroup(trackGroup)
      .setPosition(int(a.wWidth*a.wLeft), tPosY)
      .setSize(int(a.wWidth*a.wRight), trackHeight*fields.length)
      .setBackgroundColor(color(255, 50))
      .disableCollapse();

    for (int i = 0; i < fields.length; i++)
    {
      addButton(trackGroup, fields[i], i);
    }
  }

  void addButton(String trackGroup, String field, int id)
  {
    a.gui.addButton(trackGroup + field + "add")
      .setCaptionLabel(" +").setPosition(-15, 25*id)
      .setSize(15, 15).setGroup(trackGroup)
      .setId(id)
      .onClick(new CallbackListener() 
    {
      public void controlEvent(CallbackEvent theEvent) 
      {        
        String target = theEvent.getController().getParent().getName().substring(2); 
        int fieldId = theEvent.getController().getId();
        Segment seg = new Segment(a.controller, target, fieldId);        
        a.gui.get(ScrollableList.class, target + "seg" + seg.Field).addItem(seg.aniKey, seg);
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
      seq.pause();
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
      seq.seek(map(mX, a.wWidth*a.wLeft, a.wWidth*a.wRight, 0, 1));
    }
    if (a.master.isEnded())
    {
      a.isPlaying = false;
    }
  }

  void createSeq()
  {
    seq = new AniSequence(a.parent);
    seq.beginSequence();
    seq.beginStep();

    for (Segment segment : Segments.values())
    {
      seq.add(segment.ani);
    }
    seq.endStep();
    seq.endSequence();
  }

  void playpause()
  {
    if (!a.master.isPlaying() && !a.isPlaying)
    {
      createSeq();
      a.isPlaying = true;
      a.master.start();
      seq.start();
    } else if (a.master.isPlaying() && a.isPlaying)
    {
      a.master.pause();
      seq.pause();
    } else if (!a.master.isPlaying() && a.isPlaying) 
    {
      a.master.resume();
      seq.resume();
    }
  }
}