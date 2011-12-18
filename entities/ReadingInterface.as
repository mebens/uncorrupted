package entities
{
  import net.flashpunk.*;
  import net.flashpunk.graphics.Image;
  import net.flashpunk.graphics.Text;
  import net.flashpunk.utils.Input;
  
  public class ReadingInterface extends AreaEntity
  {
    public static const X_PADDING:uint = 15;
    public static const Y_PADDING:uint = 20;
    public static const PADDING:uint = 5;
    public static const FADE_TIME:Number = 0.5;
    public static var id:ReadingInterface;
    
    public var background:Image;
    public var instructions:Text;
    public var text:Text;
    public var isOpen:Boolean = false;

    public function ReadingInterface()
    {
      super(X_PADDING, Y_PADDING);
      setHitbox(FP.width - X_PADDING * 2, FP.height - Y_PADDING * 2);
      id = this;
      layer = -3;
      
      background = Image.createRect(width, height, 0x000000, 0);
      addGraphic(background);
      
      instructions = new Text("Press Z to close.", PADDING, 0, { alpha: 0 });
      instructions.y = height - PADDING - instructions.textHeight;
      addGraphic(instructions);
      
      text = new Text("", PADDING, PADDING, {
        width: width - PADDING * 2,
        height: instructions.y - PADDING * 2,
        wordWrap: true,
        alpha: 0
      });
      
      addGraphic(text);
    }
    
    override public function update():void
    {
      if (Input.pressed("action")) close();
    }
    
    public function open(str:String):void
    {
      if (isOpen) return;
      area.paused = true;
      text.text = str.replace(/\\n/g, "\n");
      FP.tween(background, { alpha: 0.8 }, FADE_TIME, { tweener: this, complete: openComplete });
      FP.tween(instructions, { alpha: 1 }, FADE_TIME, { tweener: this });
      FP.tween(text, { alpha: 1 }, FADE_TIME, { tweener: this });
    }
    
    public function close():void
    {
      if (!isOpen) return;
      FP.tween(background, { alpha: 0 }, FADE_TIME, { tweener: this, complete: closeComplete });
      FP.tween(instructions, { alpha: 0 }, FADE_TIME, { tweener: this });
      FP.tween(text, { alpha: 0 }, FADE_TIME, { tweener: this });
    }
    
    private function openComplete():void
    {
      isOpen = true;
    }
    
    private function closeComplete():void
    {
      isOpen = false;
      area.paused = false;
    }
  }
}
