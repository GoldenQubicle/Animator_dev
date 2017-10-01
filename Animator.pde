import controlP5.*;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

private class Animator extends PApplet
{   
  PApplet parent;
  ControlP5 gui;
  Controller contrls;   
  float Length;
  boolean isPlaying = false;
  int wWidth, wHeight;
  int needleX, needleH;
  Ani master;
  int frames;
  float seek;

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
    Ani.init(parent);
    Ani.setDefaultTimeMode(Ani.FRAMES);
    Ani.noAutostart();
    contrls = new Controller();

    //newTrack(rect, "rWidth");
    timeLine();
  }

  public void draw()
  {
    background(128);
    stroke(2);
    line(needleX, 20, needleX, needleH);

    if (mouseX > needleX-15 && mouseX < needleX+15 && mousePressed && master.isPlaying())
    {
      noStroke();
      rect(needleX-5, 20, 10, needleH-20); 
      master.pause();
      seek = master.getSeek();
      println(master.getSeek());
    } else if (mouseX > needleX-15 && mouseX < needleX+15)
    {
      noStroke();
      fill(255, 64);
      rect(needleX-5, 20, 10, needleH-20);
    } else if ( mousePressed)
    {
      master.seek(map(mouseX, wWidth*.05, wWidth*.95, 0, 1));
      println(int(map(mouseX, wWidth*.05, wWidth*.95, 0, frames)));
    }

    if (master.isEnded())
    {
      isPlaying = false;
    }
  } 


  void keyPressed()
  {
    if (key == ' ')
    {
      if (!master.isPlaying() && !isPlaying)
      {
        isPlaying = true;
        master.start();
      } else if (master.isPlaying() && isPlaying)
      {
        master.pause();
      } else if (!master.isPlaying() && isPlaying) 
      {
        master.resume();
      }
    }
  }

  void timeLine()
  {
    gui.addGroup("timeLine").setPosition(int((wWidth*.05)), 15).setSize(int((wWidth*.9)), 150).setBackgroundColor(color(255, 50)).disableCollapse();
    master = new Ani(this, frames, 0.0, "needleX", wWidth*.95, Ani.LINEAR);
    master.setPlayMode(Ani.FORWARD);
    master.noRepeat();
  }

  void newTrack(Object obj, String field)
  {    
    String tg = "track " + field;   
    gui.addGroup(tg).setId(tg.hashCode()).setPosition(int((wWidth*.05)), 10).setSize(int((wWidth*.9)), 50).setBackgroundColor(color(255, 50)).disableCollapse();
    gui.addButton(" +").setPosition(5, 5).setSize(15, 15).setGroup(tg); 


    //ani = new Ani(obj, Length, 0.0, field, 200.0, Ani.LINEAR);
    //ani.setPlayMode(Ani.FORWARD);
    //ani.noRepeat();
  }
}