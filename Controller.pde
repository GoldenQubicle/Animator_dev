private class Controller
{
  Animator a;
  private Map<String, Segment>Segments;

  private int needleX, needleY, needleH;
  private PFont font;
  Ani ani;

  Controller(Animator _a)
  {
    a = _a;
    Segments = new HashMap<String, Segment>();
    needleX = int(a.wWidth*a.wLeft);
    needleY = int(a.wHeight/2);
    needleH = a.cHeight/2;
    font = createFont("Symbola.ttf", 128);
  }

  //void characterdesign()
  //{
  //  fill(255);
  //  a.textFont(font);
  //  char play = 0x23F5;
  //  char pause = 0x23F8;
  //  char stop = 0x23F9;
  //  char begin = 0x23EE;
  //  char end = 0x23ED;
  //  char nextFrame = 0x23E9; 
  //  char prevFrame = 0x23EA;
  //  char control[] = {play, pause, stop, begin, end, nextFrame, prevFrame};
  //  String controls = new String(control);
  //  a.text(controls, 0, a.wHeight/2);


  //  // basic shapes - button class?!
  //  a.triangle(0, 0, 40, 40, 0, 80);
  //  a.rect(0,0,17,80);    
  //}


  void scrollTimeLine(float mX, float mY, boolean mP) 
  {        
    a.stroke(2);
    a.line(needleX, needleY-needleH, needleX, needleY+needleH);
    if (mX > needleX-20 && mX < needleX+20 && mP && a.master.isPlaying() && (mY > needleY-needleH && mY < needleY+needleH))
    {
      a.master.pause();
      for (Segment segment : Segments.values())
      {
       segment.ani.pause();
      }
    }
    if (mX > needleX-20 && mX < needleX+20 && (mY > needleY-needleH && mY < needleY+needleH))
    {
      a.noStroke();
      a.fill(255, 64);
      a.rect(needleX-5, needleY-needleH, 10, needleH*2);
    }
    if (mP && (mX > needleX-35 && mX < needleX+35) && (mY > needleY-needleH && mY < needleY+needleH))
    {      
      a.noStroke();
      a.fill(255, 128);
      a.rect(needleX-5, needleY-needleH, 10, needleH*2);

      a.master.seek(map(mX, a.wWidth*a.wLeft, a.wWidth*a.wRight, 0, 1));
      for (Segment segment : Segments.values())
      {
        segment.ani.seek(map(mX, a.wWidth*a.wLeft, a.wWidth*a.wRight, 0, 1));
      }
    }
    if (a.master.isEnded())
    {
      a.isPlaying = false;
    }
  }

  void playpause()
  {
    if (!a.master.isPlaying() && !a.isPlaying)
    {
      a.isPlaying = true;
      a.master.start();
      for (Segment segment : Segments.values())
      {
        segment.ani.start();
      }
    } else if (a.master.isPlaying() && a.isPlaying)
    {
      a.master.pause();
      for (Segment segment : Segments.values())
      {
        segment.ani.pause();
      }
    } else if (!a.master.isPlaying() && a.isPlaying) 
    {
      a.master.resume();
      for (Segment segment : Segments.values())
      {
        segment.ani.resume();
      }
    }
  }
}