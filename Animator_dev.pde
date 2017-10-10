Animator window;

PVector xy = new PVector(256, 256); 
float rWidth = 100;
float rHeight = 100;
Circle circle = new Circle(width/2, height, 10);

void settings()
{
  size(512, 512);
}

void setup()
{
  window = new Animator(this, 2, 728, 512);
  
  //window.newTrack("rWidth", -width, width); 
  window.newTrack("rHeight");
  //window.newTrack(circle, "R", 0, 400);
  window.newTrack("rWidth", "rHeight");
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