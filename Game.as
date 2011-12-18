package
{
  import net.flashpunk.*;
  import net.flashpunk.utils.Input;
  import net.flashpunk.utils.Key;
  import worlds.*;
  
  public class Game extends Engine
  {
    [Embed(source = "assets/images/tiles.png")]
    public static const TILES:Class;
    
    public static const TILE_SIZE:uint = 9;
    public static const GRAVITY:Number = 800;
    public static const FRICTION:Number = 0.82;
    
    public function Game()
    {
      super(300, 200);
      FP.screen.scale = 2;
      FP.screen.color = 0x000000;
      FP.console.enable();
      
      Input.define("left", Key.LEFT, Key.A);
      Input.define("right", Key.RIGHT, Key.D);
      Input.define("jump", Key.SPACE, Key.UP, Key.W);
      Input.define("shoot", Key.X, Key.C);
      Input.define("action", Key.Z);
    }
    
    override public function init():void
    {
      Area.init();
      Area.load(0);
    }
    
    override public function update():void
    {
      super.update();
      if (Input.pressed(Key.Q)) FP.console.visible = !FP.console.visible;
    }
  }
}
