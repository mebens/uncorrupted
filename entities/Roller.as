package entities
{
  import flash.geom.Point;
  import flash.geom.Rectangle;
  import net.flashpunk.*;
  import net.flashpunk.graphics.Emitter;
  import net.flashpunk.graphics.Spritemap;
  import net.flashpunk.utils.Ease;
  
  public class Roller extends Enemy
  {
    [Embed(source = "../assets/images/roller.png")]
    public static const IMAGE:Class;
    
    [Embed(source = "../assets/images/smoke.png")]
    public static const SMOKE:Class;
    
    public static const ACCELERATION:Number = 800;
    public static const MAX_FALL:Number = 500;
    
    public var map:Spritemap;
    public var emitter:Emitter;
    public var zone:Rectangle;
    public var vel:Point = new Point;
    public var attacking:Boolean = false;
    public var smokeOnDeath:Boolean = true;
    
    public static function fromXML(o:Object):Roller
    {
      return (new Roller(o.@x, o.@y, o.@zoneSize, o.@health)).setupFromXML(o) as Roller;
    }
    
    public function Roller(x:int, y:int, zoneSize:uint = 150, health:uint = 4)
    {
      super(x, y, health);
      setHitbox(16, 14);
      zone = new Rectangle(x + width / 2 - zoneSize, y + height / 2 - zoneSize, zoneSize * 2, zoneSize * 2);
      
      map = new Spritemap(IMAGE, width, height)
      map.add("move", [0, 1, 2, 3, 4, 5], 12);
      map.play("move");
      addGraphic(map);
    }
    
    override public function update():void
    {
      if (area.paused) return;
      var p:Player = Player.id;
      
      if (attacking)
      {
        var dir:int = 0;
        if (x < p.x) dir = 1;
        if (x > p.x) dir = -1;
        if (collide("solid", x, y + 1) == null && vel.y < MAX_FALL) vel.y += Game.GRAVITY * FP.elapsed;
        
        vel.x += ACCELERATION * dir * FP.elapsed;
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
        
        map.active = dir != 0;
        if (dir != 0) map.flipped = dir == 1;
      }
      else if (p.collideRect(p.x, p.y, zone.x, zone.y, zone.width, zone.height))
      {
        attacking = true;
      }
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
    
    override public function die():void
    {
      dead = true;
      type = "solid";
      active = false;
      map.setFrame(0, 1);
      setHitbox(14, 13, -2, -1);
      
      if (smokeOnDeath)
      {
        emitter = new Emitter(SMOKE);
        emitter.x = width / 2;
        emitter.y = height - 2;
        emitter.newType("burst");
        emitter.setAlpha("burst", 1, 0, Ease.quadIn);
        emitter.setGravity("burst", 0.1, 0.2);
        emitter.setMotion("burst", 20, 15, 0.5, 140, 20, 0.5);
        addGraphic(emitter);
        for (var i:uint = 0; i < 60 + FP.rand(11); i++) emitter.emit("burst", 0, 0);
      }
    }
    
    override public function loadFromData(obj:Object):void
    {
      if (obj.dead)
      {
        smokeOnDeath = false;
        x = obj.x;
        y = obj.y;
        die();
      }
    }
    
    override public function generateData():Object
    {
      return { dead: dead, x: x, y: y };
    }
  }
}
