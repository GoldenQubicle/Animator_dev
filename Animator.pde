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
  private Map <String, Track> Tracks = new HashMap<String, Track>();
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
    cHeight = 26;
  }; 

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
    playBackControls();
    controller.setupTracks();
  }

  /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   T R A C K  I N I T I A L I S A T I O N  M E T H O D S
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

  // slider control with default value 100, assumes variable is in parent sketch
  void newTrack(String field)  
  {   
    String fields [] = new String [] {field};
    Track track = new Track(cp5type.SLIDER, fields, parent, "track" + Tracks.size());
    Tracks.put(track.Key, track);
  }

  // slider control with default value 100, variable in custom object class 
  void newTrack(Object obj, String field)
  {    
    String fields [] = new String [] {field};
    Track track = new Track(cp5type.SLIDER, fields, obj, "track" + Tracks.size());
    Tracks.put(track.Key, track);
  }

  // slider control with custom min and max values, assumes variable is in parent sketch
  void newTrack(String field, float min, float max)
  {
    String fields [] = new String [] {field};
    Track track = new Track(cp5type.SLIDER, fields, parent, "track" + Tracks.size());
    Tracks.put(track.Key, track);   
    float [] mm = new float[]{min, max};
    minmax.put(track.Key, mm);
  }

  // slider control with custom min and max values, variable in custom object class 
  void newTrack(Object obj, String field, float min, float max)
  {
    String fields [] = new String [] {field};
    Track track = new Track(cp5type.SLIDER, fields, obj, "track" + Tracks.size());
    Tracks.put(track.Key, track);
    float [] mm = new float[]{min, max};
    minmax.put(track.Key, mm);
  }

  // slider2D controls with default values 100, assumes variable is in parent sketch
  void newTrack(String field_1, String field_2)
  {
    String fields [] = new String [] {field_1, field_2};
    Track track = new Track(cp5type.SLIDER2D, fields, parent, "track" + Tracks.size());
    Tracks.put(track.Key, track);
  }

  // slider2D controls with default values 100, variable in custom object class 
  void newTrack(Object obj, String field_1, String field_2)
  {
    String fields [] = new String [] {field_1, field_2};
    Track track = new Track(cp5type.SLIDER2D, fields, obj, "track" + Tracks.size());
    Tracks.put(track.Key, track);
  }

  // slider2D controls with custom min and max values, assumes variable is in parent sketch
  void newTrack(String field_1, String field_2, float min_1, float max_1, float min_2, float max_2)  
  {
    String fields [] = new String [] {field_1, field_2};
    Track track = new Track(cp5type.SLIDER2D, fields, parent, "track" + Tracks.size());
    Tracks.put(track.Key, track);
    float [] mm = new float[]{min_1, max_1, min_2, max_2};
    minmax.put(track.Key, mm);
  }

  // slider2D controls with custom min and max values, variable in custom object class
  void newTrack(Object obj, String field_1, String field_2, float min_1, float max_1, float min_2, float max_2)
  {
    String fields [] = new String [] {field_1, field_2};
    Track track = new Track(cp5type.SLIDER2D, fields, obj, "track" + Tracks.size());
    Tracks.put(track.Key, track);
    float [] mm = new float[]{min_1, max_1, min_2, max_2};
    minmax.put(track.Key, mm);
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
  } 

  //public void controlEvent(CallbackEvent theEvent)
  //{

  //  float pX = theEvent.getController().getPointer().x();     
  //  //println(pX); // okay so the issue here is that as soon as mousePressed callback event is no longer being active. . . .
  //  // i.e. here I need to grab the delta X, i.e. from pointer to the relevant seciotn point, and pass on into a controller method, and put that into draw()

  //  //println(theEvent.getController().getParent().getName());
  //  if (theEvent.getController().getName().contains("aniSegment"))
  //  {
  //    String segmentKey = theEvent.getController().getName();
  //    Segment seg = controller.Segments.get(segmentKey);
  //    //println(theEvent.getController().getWidth(), theEvent.getController().getAbsolutePosition()[0]);
  //    float section = theEvent.getController().getWidth()/3;

  //    float start = theEvent.getController().getPosition()[0];
  //    float mid1 = section; 
  //    float mid2 = section+section;
  //    float end = theEvent.getController().getWidth();

  //    //float pX = theEvent.getController().getPointer().x();     
  //    //println(pX); // okay so the issue here is that as soon as mousePressed the 
  //    //seg.easings.setPosition(pX, theEvent.getController().getPosition()[1]);    

  //    if ( pX >= start && pX <= mid1 && mousePressed)
  //    {
  //      //println("left start at " + pX);   
  //      line(theEvent.getController().getAbsolutePosition()[0], theEvent.getController().getAbsolutePosition()[1], theEvent.getController().getAbsolutePosition()[0], height/2);
  //    }
  //    if (pX >= mid1 && pX <= mid2)
  //    {
  //      println("mid section");
  //      //line(theEvent.getController().getAbsolutePosition()[0]+(theEvent.getController().getWidth()/2), theEvent.getController().getAbsolutePosition()[1], theEvent.getController().getAbsolutePosition()[0]+(theEvent.getController().getWidth()/2), height/2);
  //    }
  //    if (pX >= mid2 && pX <= end)
  //    {
  //      println("right end");
  //      //line(theEvent.getController().getAbsolutePosition()[0]+theEvent.getController().getWidth(), theEvent.getController().getAbsolutePosition()[1], theEvent.getController().getAbsolutePosition()[0]+theEvent.getController().getWidth(), height/2);
  //    }
  //    //println(theEvent.getController().getPointer().x(), theEvent.getController().getWidth());
  //    //println("segment check" + theEvent.getController().getName());
  //  }
  //}

  void keyPressed()
  {
    if (key == ' ')
    {
      controller.playpause();
    }
  }
}