import controlP5.*;
import de.looksgood.ani.*;
import java.util.*;

private class Animator extends PApplet
{   
  private PApplet parent;
  private ControlP5 gui;
  protected Controller controller;   
  private float Length, wLeft, wRight;
  private boolean isPlaying = false;
  private int wWidth, wHeight, cHeight;
  private Ani master, ani;
  private int frames;
  private Map <String, Object> tracks = new HashMap<String, Object>();
  
  Animator(){};

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

  void newTracks()
  {
    int spacing = 10;
    int trackHeight = 25;
    int posY = wHeight/2 + cHeight + spacing;

    for (String obj : tracks.keySet())
    {
      gui.addGroup(obj).setPosition(int(wWidth*wLeft), posY).setSize(int(wWidth*wRight), trackHeight).setBackgroundColor(color(255, 50)).disableCollapse();
      gui.addButton(obj + "add").setCaptionLabel(" +").setId(obj.hashCode()).setPosition(-15, -2).setSize(15, 15).setGroup(obj)
        .onClick(new CallbackListener() 
      {
        public void controlEvent(CallbackEvent theEvent) 
        {
          controller.addSegment(theEvent.getController().getName(), frames, 200);
        }
      }
      );           
      posY += (trackHeight + spacing*2);
    }
  }

    void newTrack(Object obj, String field)
    {    
      tracks.put(field, obj);
    }
  }