package entities
{
  import net.flashpunk.*;
  import net.flashpunk.graphics.Text;
  import net.flashpunk.utils.Data;
  import net.flashpunk.utils.Input;
  
  public class Intro extends AreaEntity
  {
    public static const PADDING:uint = 20;
    public static const FADE_TIME:Number = 1;
    
    public var text:Text;
    public var instructions:Text;
    public var open:Boolean = false;
    
    public function Intro()
    {
      text = new Text(
        "Slowly you come out what seems like an overly long sleep. You appear to be some kind of robot. Questions start to fill your mind.\n\n\"Who am I? Where am I? How did I get here? Is there anyone else here?\"\n\nSo begins your search for answers.\n\nInstructions:\nArrows to move.\nSpace to jump.\nX to shoot.\nZ to interact (activate switches, read notes, etc.).",
        PADDING,
        0,
        { width: FP.width - PADDING * 2, align: "center", wordWrap: true, alpha: 0 }
      );
      
      text.y = FP.height / 2 - text.textHeight / 2;
      addGraphic(text);
      
      instructions = new Text("Press Z to continue.", PADDING, 0, { width: FP.width - PADDING * 2, align: "center", alpha: 0 });
      instructions.y = FP.height - instructions.textHeight;
      addGraphic(instructions);
      
      FP.tween(text, { alpha: 1 }, FADE_TIME, { tweener: this, complete: fadeInComplete });
      FP.tween(instructions, { alpha: 1 }, FADE_TIME, { tweener: this });
      layer = -5;
    }
    
    override public function added():void
    {
      area.paused = true;
    }
    
    override public function update():void
    {
      if (open && Input.pressed("action"))
      {
        open = false;
        FP.tween(text, { alpha: 0 }, FADE_TIME, { tweener: this, complete: fadeOutComplete });
        FP.tween(instructions, { alpha: 0 }, FADE_TIME, { tweener: this });
      }
    }
    
    private function fadeInComplete():void
    {
      open = true;
    }
    
    private function fadeOutComplete():void
    {
      area.fade.fadeOut(FADE_TIME, levelBegin);
    }
    
    private function levelBegin():void
    {
      Data.writeBool("intro", true);
      area.paused = false;
      area.remove(this);
    }
  }
}
