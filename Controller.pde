private class Controller
{
  Animator a;
  private Map<Integer, Ani>aniSegments;


  Controller(Animator _a)
  {
    a = _a;
    aniSegments = new HashMap<Integer, Ani>();
  }

  void scrollTimeLine(float _mx, boolean _p)
  {
    a.stroke(2);
    a.line(a.needleX, 20, a.needleX, a.needleH);
    if (_mx > a.needleX-15 && _mx < a.needleX+15 && _p && a.master.isPlaying())
    {
      a.noStroke();
      a.rect(a.needleX-5, 20, 10, a.needleH-20); 
      a.master.pause();
      for (Ani myAni : aniSegments.values())
      {
        myAni.pause();
      }
    } else if (_mx > a.needleX-15 && _mx < a.needleX+15)
    {
      a.noStroke();
      a.fill(255, 64);
      a.rect(a.needleX-5, 20, 10, a.needleH-20);
    } else if ( _p)
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