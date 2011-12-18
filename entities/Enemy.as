package entities
{
  import net.flashpunk.*;
  
  public class Enemy extends AreaEntity
  {
    public var health:uint;
    public var dead:Boolean = false;
    
    public function Enemy(x:int, y:int, health:uint)
    {
      super(x, y);
      type = "enemy";
      layer = 0;
      this.health = health;
    }
    
    public function hit():void
    {
      if (!dead && --health == 0) die();
    }
    
    public function die():void
    {
      dead = true;
      area.remove(this);
    }
  }
}
