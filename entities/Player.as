package entities
{
  import flash.geom.Point;
  import net.flashpunk.*;
  import net.flashpunk.graphics.Image;
  import net.flashpunk.utils.Input;
  
  public class Player extends AreaEntity
  {
    [Embed(source = "../assets/images/player.png")]
    public static const IMAGE:Class;
    
    public static const ACCELERATION:Number = 1200;
    public static const FRICTION:Number = 0.82;
    public static const JUMP_SPEED:Number = -250;
    public static const FLOAT_GRAVITY:Number = 2.5;
    public static const MAX_FALL:Number = 500;
    public static var id:Player;
    
    public var image:Image;
    public var vel:Point = new Point;
    public var inAir:Boolean;
    
    public static function fromData(xml:XML, fromArea:int):Player
    {
      var fallback:Object;
      
      for each (var o:Object in xml.objects.player)
      {
        if (int(o.@fromArea) == fromArea) return new Player(o.@x, o.@y);
        if (o.@fromArea == "-1") fallback = o;
      }
      
      if (fallback) return new Player(fallback.@x, fallback.@y);
      return new Player(0, 0);
    }
    
    public function Player(x:int, y:int)
    {
      id = this;
      name = "player";
      layer = 0;
      setHitbox(8, 14);
      super(x, y, image = new Image(IMAGE));
    }
    
    override public function update():void
    {
      if (area.paused) return;
      if (collide("death", x, y) || y > area.height) return die();
      
      var xAxis:int = 0;
      var platform:Entity = collide("solid", x, y + 1);
      var oldInAir:Boolean = inAir;
      inAir = platform == null;
      
      if (inAir)
      {
        var factor:Number = vel.y < 0 && !Input.check("jump") ? FLOAT_GRAVITY : 1;
        if (vel.x < MAX_FALL) vel.y += Game.GRAVITY * factor * FP.elapsed;
      }
      else if (Input.pressed("jump"))
      {
        vel.y = JUMP_SPEED;
      }
            
      if (Input.check("left")) xAxis--;
      if (Input.check("right")) xAxis++;
            
      vel.x += ACCELERATION * xAxis * FP.elapsed;
      vel.x *= FRICTION;
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
    
    public function die():void
    {
      area.reload();
      area.sendMessage("player.die");
    }
  }
}
