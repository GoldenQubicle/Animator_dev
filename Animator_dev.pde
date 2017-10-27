/*
TODO
 - probably need a method in main animator which - somehow - checks and syncs with the frame rate of the main sketch?!
 - initial track field value
 
 
 USAGE
 - size of original sketch needs to be put in settings()
 - initialisation & newTracks goes in setup()
 
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

void keyPressed()
{
  if (key == 'e')
  {
    //export(); // saveguard
  }
}

void export()
{
  String [] animator = loadStrings("Animator.pde");
  String [] controller = loadStrings("Controller.pde");
  String [] segment = loadStrings("Segment.pde");
  String [] track = loadStrings("Track.pde");    
  
  int lines = animator.length + controller.length + segment.length + track.length;
  int lineIndex = 0;  
  
  String [] finalFile = new String [lines];  
  
  ArrayList<String[]> classFiles = new ArrayList<String[]>();   
  classFiles.add(animator);
  classFiles.add(controller);
  classFiles.add(segment);
  classFiles.add(track);  
  
  for (String[] file : classFiles)
  {
    for (String line : file)
    {
     finalFile[lineIndex] = line;
     lineIndex++;
    }
  }
  
  saveStrings("data//Animator_v1.pde", finalFile);    
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