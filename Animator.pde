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
  private int needleX, needleH;
  private Ani master, ani;
  private  int frames;

  Animator(PApplet _p, float _l, int _w, int _h)
  { 
    super();
    parent = _p;   
    Length = _l;
    wWidth = _w;
    wHeight = _h;    
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
    needleX = int(wWidth*.05);
    needleH = 150;
    frames = int(Length*60);
  }

  public void settings()
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
    // master timeline setup
    gui.addGroup("timeLine").setPosition(int((wWidth*.05)), 15).setSize(int((wWidth*.9)), 150).setBackgroundColor(color(255, 50)).disableCollapse();
    master = new Ani(this, frames, 0.0, "needleX", wWidth*.95, Ani.LINEAR);
    master.setPlayMode(Ani.FORWARD);
    master.noRepeat();
  }

  public void draw()
  {
    background(128);
    controller.scrollTimeLine(mouseX, mousePressed);
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