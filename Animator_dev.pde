/*
 TODO fix the 'no public this method' error for ani resume, prolly some additional logic checks and/or hard reset



so current thinking on how to actually edit the segment value
add a scrollable list to track control which contains segments
select segment from it => it lights up and timeline jumps to proper place
then and only then is the anisegment value able to be editted
this supposes there's also a way to de-select, possible by an empty entry in scrollable list (or on collapse?!)

moreover this idea could be extended to trackcontrol themselves
say for instance there > 5 color wheels. Instead of having all 5 individually on screen
I could have 1 color wheel with 2 scrollable list next to it
first I select which variable I want (i.e. which track) and once selected tracks lights up, and second list fills
then from second list I select actual segment to edit

of course there're halve a dozen ways to go about 
however the (two tiered) concept of scrollable list(s) next to controls has potential

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