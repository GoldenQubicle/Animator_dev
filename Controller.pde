private class Controller
{
  Animator a;
  private Map<Integer, Ani>aniSegments;
  private int needleX, needleY, needleH;
  private PFont font;

  Controller(Animator _a)
  {
    a = _a;
    aniSegments = new HashMap<Integer, Ani>();
    needleX = int(a.wWidth*.05);
    needleY = int(a.wHeight/2);
    needleH = 25;
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

  void scrollTimeLine(float _mx, float _my, boolean _p) 
  {        
    a.stroke(2);
    a.line(needleX, needleY-needleH, needleX, needleY+needleH);
    if (_mx > needleX-15 && _mx < needleX+15 && _p && a.master.isPlaying() && (_my > needleY-needleH && _my < needleY+needleH))
    {
      a.master.pause();
      for (Ani myAni : aniSegments.values())
      {
        myAni.pause();
      }
    }
    if (_mx > needleX-15 && _mx < needleX+15 && (_my > needleY-needleH && _my < needleY+needleH))
    {
      a.noStroke();
      a.fill(255, 64);
      a.rect(needleX-5, needleY-needleH, 10, needleH*2);
    }
    if (_p && _mx > needleX-15 && _mx < needleX+15 && _my > needleY-needleH && _my < needleY+needleH)
    {
      a.master.seek(map(_mx, a.wWidth*.05, a.wWidth*.95, 0, 1));
      for (Ani myAni : aniSegments.values())
      {
        myAni.seek(map(_mx, a.wWidth*.05, a.wWidth*.95, 0, 1));
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
      for (Ani ani : aniSegments.values())
      {
        ani.start();
      }
    } else if (a.master.isPlaying() && a.isPlaying)
    {
      a.master.pause();
      for (Ani ani : aniSegments.values())
      {
        ani.pause();
      }
    } else if (!a.master.isPlaying() && a.isPlaying) 
    {
      a.master.resume();
      for (Ani ani : aniSegments.values())
      {
        ani.resume();
      }
    }
  }
}