Animator window;
rectangle rect = new rectangle();

void settings()
{
  size(512, 512);
}

void setup()
{
  window = new Animator(this, 10, 728,200);

}


void draw()
{
  background(128);
  rect.display();
}



class rectangle
{
  PVector xy = new PVector(256, 256);; 
  float rWidth = 100; 
  float rHeight = 100;

  rectangle()
  {
  }
  void display()
  {
    rectMode(CENTER);
    rect(xy.x, xy.y, window.needleX*.5, rHeight);
  }
}