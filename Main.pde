Animator window;

PVector xy = new PVector(256, 256);
float rWidth = 100; 
float rHeight = 100;

void settings()
{
  size(512, 512);
}

void setup()
{
  window = new Animator(this, 2, 728, 200);
  window.newTrack(this, "rWidth"); 
}



void draw()
{
  background(128);
  rectMode(CENTER);
  rect(xy.x, xy.y, rWidth, rHeight);
}

void mousePressed()
{
  //window.newTrack(this, "rHeight");
}