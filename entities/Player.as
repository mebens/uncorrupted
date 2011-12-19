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
    
    [Embed(source = "../assets/sfx/land.mp3")]
    public static const LAND_SFX:Class;
    
    [Embed(source = "../assets/sfx/shoot.mp3")]
    public static const SHOOT_SFX:Class;
    
    public static const ACCELERATION:Number = 1200;
    public static const JUMP_SPEED:Number = -200;
    public static const FLOAT_GRAVITY:Number = 2.5;
    public static const MAX_FALL:Number = 500;
    public static var id:Player;
    
    public var map:Spritemap;
    public var light:Light;
    public var vel:Point = new Point;
    public var inAir:Boolean;
    
    public var landSfx:Sfx = new Sfx(LAND_SFX);
    public var shootSfx:Sfx = new Sfx(SHOOT_SFX);
    
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
      super(x, y);
      setHitbox(8, 15);
      id = this;
      name = "player";
      layer = 1;
      Lighting.id.add(light = new Light(x + width / 2, y + height / 2));
      
      graphic = map = new Spritemap(IMAGE, 10, 15);
      map.add("move", [0, 1, 2, 3], 12);
      map.play("move");
    }
    
    override public function update():void
    {
      if (area.paused) return;
      if (collide("enemy", x, y) || y > area.height) return die();
      
      var xAxis:int = 0;
      var platform:Entity = collide("solid", x, y + 1);
      inAir = platform == null;
      
      if (inAir)
      {
        var factor:Number = vel.y < 0 && !Input.check("jump") ? FLOAT_GRAVITY : 1;
        if (vel.y < MAX_FALL) vel.y += Game.GRAVITY * factor * FP.elapsed;
      }
      else if (Input.pressed("jump"))
      {
        vel.y = JUMP_SPEED;
      }
            
      if (Input.check("left")) xAxis--;
      if (Input.check("right")) xAxis++;
            
      vel.x += ACCELERATION * xAxis * FP.elapsed;
      vel.x *= Game.FRICTION;
      moveBy(vel.x * FP.elapsed, vel.y * FP.elapsed, "solid");
      
      if (x < 0)
      {
        x = 0;
      }
      else if (x > area.width - width)
      {
        x = area.width - width;
      }
      
      light.x = x + width / 2;
      light.y = y + height / 2;
      map.active = xAxis != 0;
      
      if (xAxis != 0)
      {
        map.flipped = xAxis == -1;
        map.x = xAxis == -1 ? -2 : 0;
      }
      
      if (Input.pressed("shoot"))
      {
        shootSfx.play();
        area.add(new Bullet(map.flipped ? x - Bullet.WIDTH : x + 8, y + 4, map.flipped ? -1 : 1));
      }
    }
    
    override public function moveCollideX(e:Entity):Boolean
    {
      vel.x = 0;
      return true;
    }
    
    override public function moveCollideY(e:Entity):Boolean
    {
      if (vel.y > 0) landSfx.play();
      vel.y = 0;
      return true;
    }
    
    public function die():void
    {
      area.sendMessage("player.die");
      area.reload();
    }
  }
}
