/*
TODO
- initial track field value


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