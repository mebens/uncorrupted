package entities
{
  import net.flashpunk.*;
  import worlds.GameComplete;
  
  public class End extends AreaEntity
  {
    public static function fromXML(o:Object):End
    {
      return new End(o.@x, o.@y, o.@width, o.@height);
    }
    
    public function End(x:int, y:int, width:uint, height:uint)
    {
      super(x, y);
      setHitbox(width, height);
      Lighting.id.add(new Light(x + width, y, 1, 1, true));
    }
    
    override public function update():void
    {
      if (collideWith(Player.id, x, y))
      {
        area.paused = true;
        area.fade.fadeIn(0.5, fadeDone);
      }
    }
    
    private function fadeDone():void
    {
      FP.world = new GameComplete;
    }
  }
}
