package entities
{
  import net.flashpunk.*;
  import net.flashpunk.graphics.Text;
  
  public class ActionText extends AreaEntity
  {
    public static const PADDING:uint = 10;
    public static const BOTTOM_PADDING:uint = 25;
    public static const SHADOW_OFFSET:int = 1;
    public static const FADE_TIME:Number = 0.15;
    public static var id:ActionText;
    
    public var text:Text;
    public var shadow:Text;
    public var tween:Tween;
    public var currentName:String;
    
    public function ActionText()
    {
      id = this;
      layer = -2;
      
      shadow = new Text("", PADDING + SHADOW_OFFSET, FP.height - BOTTOM_PADDING + SHADOW_OFFSET, {
        width: FP.width - PADDING * 2,
        align: "center",
        wordWrap: true,
        alpha: 0,
        color: 0x111111
      });
      
      text = new Text("", PADDING, FP.height - BOTTOM_PADDING, {
        width: FP.width - PADDING * 2,
        align: "center",
        wordWrap: true,
        alpha: 0
      });
      
      shadow.scrollX = shadow.scrollY = text.scrollX = text.scrollY = 0;
      addGraphic(shadow);
      addGraphic(text);
    }
    
    public function display(name:String, action:String, description:String):void
    {
      if (name == currentName) return;
      
      if (!currentName)
      {
        if (tween && tween.active) tween.cancel();
        tween = FP.tween(text, { alpha: 1 }, FADE_TIME, { tweener: this });
      }
      
      text.text = shadow.text = action + ": " + description;
      currentName = name;
    }
    
    public function close(name:String):void
    {
      if (name != currentName) return;
      if (tween && tween.active) tween.cancel();
      tween = FP.tween(text, { alpha: 0 }, FADE_TIME, { tweener: this });
      currentName = null;
    }
  }
}
