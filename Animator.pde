import controlP5.*;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import java.util.*;
import java.lang.reflect.*;

private class Animator extends PApplet
{   
  private PApplet parent;
  private ControlP5 gui;
  protected Controller controller;   
  private float Length, wLeft, wRight;
  private boolean isPlaying = false;
  private int wWidth, wHeight, cHeight;
  private Ani master;
  private int frames;
  private Map <String, Object> tracks = new HashMap<String, Object>();
  private Map <String, float[]> minmax = new HashMap<String, float[]>();

  Animator(PApplet _p, float _l, int _w, int _h)
  { 
    super();
    parent = _p;   
    Length = _l;
    wWidth = _w;
    wHeight = _h;    
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
    frames = int(Length*60);
    wLeft = .02;
    wRight = .96;
  }; 

  public void settings()
  {
    size(wWidth, wHeight);
  }

  public void setup()
  {
    cHeight = 26;
    gui = new ControlP5(this); 
    controller = new Controller(this);
    Ani.init(parent);
    Ani.setDefaultTimeMode(Ani.FRAMES);
    Ani.noAutostart();
    playBackControls();
    newTracks();
  }


  void playBackControls()
  {
    gui.addGroup("playback").setPosition(int((wWidth*wLeft)), wHeight/2-cHeight/2).setSize(int((wWidth*wRight)), cHeight).setBackgroundColor(color(255, 50)).disableCollapse();
    master = new Ani(controller, frames, 0.0, "needleX", ((wWidth*wLeft)+(wWidth*wRight)), Ani.LINEAR);
    master.setPlayMode(Ani.FORWARD);
    master.noRepeat();
  }

  public void draw()
  {
    background(128);
    controller.scrollTimeLine(mouseX, mouseY, mousePressed);
    //controller.characterdesign();
  } 


  void keyPressed()
  {
    if (key == ' ')
    {
      controller.playpause();
    }
  }

  public void newTracks()
  {
    // dddaaaaa yeah need to refactor and beforehand have a think how to go about handling different control schemes
    // as in, I want to be able to set slider, slider2d, and have boolean toggles for stroke/fill, ect

    int spacing = 10;
    int trackHeight = 25;
    int tPosY = wHeight/2 + cHeight + spacing;
    int cPosY = 10;
    // object animation tracks
    for (String obj : tracks.keySet())
    {
      gui.addGroup("Track "+obj).setPosition(int(wWidth*wLeft), tPosY).setSize(int(wWidth*wRight), trackHeight).setBackgroundColor(color(255, 50)).disableCollapse();
      gui.addButton(obj + "add").setCaptionLabel(" +").setId(obj.hashCode()).setPosition(-15, 0).setSize(15, 15).setGroup("Track " + obj)
        .onClick(new CallbackListener() 
      {
        public void controlEvent(CallbackEvent theEvent) 
        {
          String track = theEvent.getController().getParent().getName();          
          Segment seg = new Segment(controller, track);
        }
      }
      );   
      tPosY += (trackHeight + spacing*2);
    }

    //object cp5 controls - slider for now 
    for (String obj : tracks.keySet())
    {
      gui.addGroup("Control "+obj).setPosition(int(wWidth*wLeft), cPosY).setSize(int((wWidth/2)), trackHeight).setBackgroundColor(color(255, 50)).disableCollapse();
      gui.addSlider(obj).setGroup("Control "+obj).setPosition(5, 5).setSize(int((wWidth/2)*wRight), 10)
        .onChange(new CallbackListener()
      {
        public void controlEvent(CallbackEvent theEvent) 
        {
          if (theEvent.getAction()==ControlP5.ACTION_BROADCAST)
          {
            Object obj = tracks.get(theEvent.getController().getName());
            Class cls = obj.getClass();
            for (int i = 0; i < cls.getDeclaredFields().length; i++)
            {
              if (cls.getDeclaredFields()[i].getName().equals(theEvent.getController().getName()))
              {
                float value = theEvent.getController().getValue();
                Field field = cls.getDeclaredFields()[i];
                field.setAccessible(true);
                try 
                {
                  field.set(obj, value);
                } 
                catch(Exception e) {
                  println(e);
                }
              }
            }
          }
        }
      }
      );

      if (minmax.containsKey(obj))
      {
        gui.get(Slider.class, obj).setRange(minmax.get(obj)[0], minmax.get(obj)[1]);
      }

      cPosY += (trackHeight + spacing*2);
    }
  }


  void newTrack(Object obj, String field, float min, float max)
  {
    tracks.put(field, obj);
    float [] mm = new float[]{min, max};
    minmax.put(field, mm);
  }

  void newTrack( String field, float min, float max)
  {
    tracks.put(field, parent);
    float [] mm = new float[]{min, max};
    minmax.put(field, mm);
  }
  
  void newTrack(Object obj, String field)
  {    
    tracks.put(field, obj);
  }

  void newTrack(String field)
  {    
    tracks.put(field, parent);
  }
}