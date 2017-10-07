import controlP5.*;
import de.looksgood.ani.*;
import java.util.*;

private class Animator extends PApplet
{   
  private PApplet parent;
  private ControlP5 gui;
  private Controller controller;   
  private float Length, wLeft, wRight;
  private boolean isPlaying = false;
  private int wWidth, wHeight, cHeight;
  private Ani master, ani;
  private int frames;
  private Map <String, Object> tracks = new HashMap<String, Object>();

  Animator(PApplet _p, float _l, int _w, int _h)
  { 
    super();
    parent = _p;   
    Length = _l;
    wWidth = _w;
    wHeight = _h;    
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
    frames = int(Length*60);
    wLeft = .01;
    wRight = .98;
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
      String tg = "track " + obj;   
      gui.addGroup(tg).setId(tg.hashCode()).setPosition(int(wWidth*wLeft), posY).setSize(int(wWidth*wRight), trackHeight).setBackgroundColor(color(255, 50)).disableCollapse();
      //gui.addButton(" +").setPosition(5, 5).setSize(15, 15).setGroup(tg); 

      ani = new Ani(tracks.get(obj), frames, 0.0, obj, 200.0, Ani.LINEAR);
      ani.setPlayMode(Ani.FORWARD);
      ani.noRepeat();
      controller.aniSegments.put(tg.hashCode(), ani);
      posY += (trackHeight + spacing*2);
    }
  }

  void newTrack(Object obj, String field)
  {    
    tracks.put(field, obj);
  }
}