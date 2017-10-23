/*
hmm got a number of bugs to work out
- adding an ani once isPlaying, object being drawn disappears. . 
- when draggin master timeline immediatly; nullpointer in controller line 248
- when draggin master timeline after play, but without ani; 'map(0,0,0,0,1) gets called which returns NaN'
- 'no public this method' error for ani resume

AAARGH
  so. . the mysterious disappereance has to do with the ani sequence, for some reason. . 
  very much inclined to ditch the sequence HOWEVER
  that does mean Id need to handwrite a custom seek functionality (which isnt such an issue really since v2 already had that, more or less)
  bigger issue is actually how to update the anis so that they have the proper begin value!?
  especially considering I want to have multiple segments per track, i.e.
  per track segments need to check if some came before, and if so,  use that end value as their begin value
  and the first ani needs to grab the object value, which actually is even a bigger issue perhaps BECAUSE
  since the ani is on a delay, it sets the begin value right from the get go, i.e. on master start. . 
  
  honestly all things consider I might want to rethink how the ani are handled, e.g. in v2 it was all dynamic fired on triggers
  which had the advantage of not having to think about begin value
  tho question is, is a scrollable timeline than still possible?!
  
  bleeehhhh this is starting to become more complicated than anticipated. . 
  


*/

Animator window;

PVector xy = new PVector(256, 256); 
float rWidth = 25;
float rHeight = 80;
Circle circle = new Circle(width/2, height, 10);

void settings()
{
  size(512, 512);
}

void setup()
{
  window = new Animator(this, 2, 728, 512);

  window.newTrack("rWidth", -width, width); 
  //window.newTrack("rHeight");
  //window.newTrack(circle, "R", 0, 400);
  //window.newTrack("rWidth", "rHeight", -200, 200, -350, 800);
  //window.newTrack(circle, "X", "Y", -200, width, -350, 800);
  //window.newTrack("x", "y");
  //window.newTrack(this.xy, "x");
  //window.newTrack(this.xy, "y");
}

void draw()
{
  background(128);
  rectMode(CENTER);
  rect(xy.x, xy.y, rWidth, rHeight);
  //circle.display();
}

class Circle
{
  float X, Y, R; 
  Circle(float x, float y, float r)
  {
    X = x;
    Y = y;
    R = r;
  }

  void display()
  {
    noStroke();
    ellipse(X, Y, R, R);
  }
}