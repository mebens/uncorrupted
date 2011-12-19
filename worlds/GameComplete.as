package worlds
{
  import net.flashpunk.*;
  import net.flashpunk.graphics.Text;
  import net.flashpunk.utils.Data;
  import net.flashpunk.utils.Input;
  
  public class GameComplete extends World
  {
    public static const FADE_TIME:Number = 0.5;
    public static const PADDING:uint = 10;
    
    public var text:Text;
    public var instructions:Text;
    public var ready:Boolean = false;
    
    public function GameComplete()
    {
      text = new Text(
        "And so you make it out of the robot controlled facility in one piece. As you step into the light you begin to wonder, what lies outside?",
        0,
        0,
        { width: FP.width - PADDING * 2, align: "center", wordWrap: true, alpha: 0 }
      );
      
      instructions = new Text("Press Z to restart.", 0, 0, { width: FP.width - PADDING * 2, align: "center", alpha: 0 });
      addGraphic(text, 0, PADDING, FP.height / 2 - text.textHeight / 2);
      addGraphic(instructions, 0, PADDING, FP.height - instructions.textHeight - PADDING);
      FP.tween(text, { alpha: 1 }, FADE_TIME, { tweener: this, complete: fadeInDone });
      FP.tween(instructions, { alpha: 1 }, FADE_TIME, { tweener: this });
    }
    
    override public function update():void
    {
      if (ready && Input.pressed("action"))
      {
        FP.tween(text, { alpha: 0 }, FADE_TIME, { tweener: this, complete: fadeOutDone });
        FP.tween(instructions, { alpha: 0 }, FADE_TIME, { tweener: this });
      }
    }
    
    private function fadeInDone():void
    {
      ready = true;
    }
    
    private function fadeOutDone():void
    {
      Data.load();
      Area.load(0);
    }
  }
}
