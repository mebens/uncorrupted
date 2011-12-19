package entities
{
  import flash.display.BitmapData;
  import net.flashpunk.*;
  import net.flashpunk.graphics.Emitter;
  import net.flashpunk.graphics.Image;
  
  public class Bullet extends AreaEntity
  {
    [Embed(source = "../assets/images/bullet.png")]
    public static const IMAGE:Class;
    
    [Embed(source = "../assets/sfx/bullet-hit.mp3")]
    public static const HIT_SFX:Class;
    
    public static const PARTICLE:BitmapData = new BitmapData(1, 1, false, 0xF54A0B);
    public static const SPEED:Number = 600;
    public static const WIDTH:Number = 12;
    public static const HEIGHT:Number = 1;
    public static var hitSfx:Sfx = new Sfx(HIT_SFX);
    
    public var direction:int;
    public var emitter:Emitter;
    
    public function Bullet(x:int, y:int, direction:int = 1)
    {
      super(x, y, new Image(IMAGE));
      setHitbox(WIDTH, HEIGHT);
      type = "bullet";
      layer = 2;
      this.direction = direction;
    }
    
    override public function update():void
    {
      if (area.paused) return;
      
      if (emitter)
      {
        if (emitter.particleCount == 0) area.remove(this);
        return;
      }
      
      if (x < -width || x > area.width) area.remove(this);
      x += SPEED * direction * FP.elapsed;
      var collision:Entity = collideTypes(["solid", "enemy"], x, y);

      if (collision)
      {
        hitSfx.play(sfxVolume);
        graphic = emitter = new Emitter(PARTICLE);
        emitter.newType("sparks");
        emitter.setAlpha("sparks", 0.8, 0);
        emitter.setGravity("sparks", 0.1, 0.2);
        emitter.setMotion("sparks", 90, 5, 0.15, direction == -1 ? -180 : 180, 10, 0.2);
        for (var i:uint = 0; i < 5 + FP.rand(6); i++) emitter.emit("sparks", width / 2, 0);
        if (collision is Enemy) Enemy(collision).hit();
      }
    }
  }
}
