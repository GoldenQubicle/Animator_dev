/*
So I just realized, in order to send down a boolean variable for toggle I either need to:
 1) send down an extra argument indicating the variable data type, or
 2) determine the variable data type by reflection
 
 Since I want to keep things as simple as possible, 2) is the option to go with. 
 However, it means I need to perform a check after the initial call, and then pass something down to the track object
 
 Anyway, to get things up and running here's a neato todo list, prioritized?!
 - track control gui initialisation | done for now 14-10 ~except placement for mutliple 2d sliders need to be figured out!!!
 - segment handling
 - ani sequence
 - rendering
 
 
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