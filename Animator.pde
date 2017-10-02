import controlP5.*;
import de.looksgood.ani.*;
import java.util.*;

private class Animator extends PApplet
{   
  private PApplet parent;
  private ControlP5 gui;
  private Controller controller;   
  private float Length;
  private boolean isPlaying = false;
  private int wWidth, wHeight;
  private Ani master, ani;
  private int frames;
  
  Animator(PApplet _p, float _l, int _w, int _h)
  { 
    super();
    parent = _p;   
    Length = _l;
    wWidth = _w;
    wHeight = _h;    
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
    frames = int(Length*60);
    
  }
; public void settings()
  {
    size(wWidth, wHeight);
  }

  public void setup()
  {
    gui = new ControlP5(this); 
    controller = new Controller(this);
    Ani.init(parent);
    Ani.setDefaultTimeMode(Ani.FRAMES);
    Ani.noAutostart();
    playBackControls();
  }

  void playBackControls()
  {
    int h = 50; 
    gui.addGroup("playback").setPosition(int((wWidth*.05)), wHeight/2-h/2).setSize(int((wWidth*.9)), h).setBackgroundColor(color(255, 50)).disableCollapse();
    master = new Ani(controller, frames, 0.0, "needleX", wWidth*.95, Ani.LINEAR);
    master.setPlayMode(Ani.FORWARD);
    master.noRepeat();
   
    
  }

  public void draw()
  {
    background(128);
    controller.scrollTimeLine(mouseX, mouseY, mousePressed);
  } 


  void keyPressed()
  {
    if (key == ' ')
    {
      controller.playpause();
    }
  }


  void newTrack(Object obj, String field)
  {    
    String tg = "track " + field;   
    gui.addGroup(tg).setId(tg.hashCode()).setPosition(int((wWidth*.05)), 10).setSize(int((wWidth*.9)), 50).setBackgroundColor(color(255, 50)).disableCollapse();
    gui.addButton(" +").setPosition(5, 5).setSize(15, 15).setGroup(tg); 

    ani = new Ani(obj, frames, 0.0, field, 200.0, Ani.LINEAR);
    ani.setPlayMode(Ani.FORWARD);
    ani.noRepeat();
    controller.aniSegments.put(tg.hashCode(), ani);
  }
}