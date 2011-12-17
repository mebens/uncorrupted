package entities
{
  import flash.geom.Point;
  import net.flashpunk.*;
  import net.flashpunk.graphics.Spritemap;
  import net.flashpunk.utils.Input;
  
  public class Player extends AreaEntity
  {
    [Embed(source = "../assets/images/player.png")]
    public static const IMAGE:Class;
    
    public static const ACCELERATION:Number = 1600;
    public static const FRICTION:Number = 0.78;
    public static var id:Player;
    
    public var map:Spritemap;
    public var vel:Point = new Point;
    public var axis:Point = new Point;
    
    public static function fromData(xml:XML, fromArea:int):Player
    {
      for each (var o:Object in xml.objects.player)
      {
        if (int(o.@fromArea) == fromArea) return new Player(o.@x, o.@y);
      }
      
      return new Player(0, 0);
    }
    
    public function Player(x:int, y:int)
    {
      id = this;
      name = "player";
      layer = 0;
      setHitbox(11, 11);
      super(x, y);
      
      graphic = map = new Spritemap(IMAGE, width, height);
      map.add("move", [0, 1, 2], 10);
      map.play("move");
    }
    
    override public function update():void
    {
      if (area.paused) return;
      
      axis.x = 0;
      axis.y = 0;
      if (Input.check("left")) axis.x--;
      if (Input.check("right")) axis.x++;
      if (Input.check("up")) axis.y--;
      if (Input.check("down")) axis.y++;
      
      map.active = axis.x != 0 || axis.y != 0;
      vel.x += ACCELERATION * axis.x * FP.elapsed;
      vel.y += ACCELERATION * axis.y * FP.elapsed;
      vel.x *= FRICTION;
      vel.y *= FRICTION;
      moveBy(vel.x * FP.elapsed, vel.y * FP.elapsed, "solid");
    }
    
    override public function moveCollideX(e:Entity):Boolean
    {
      vel.x = 0;
      return true;
    }
    
    override public function moveCollideY(e:Entity):Boolean
    {
      vel.y = 0;
      return true;
    }
  }
}
