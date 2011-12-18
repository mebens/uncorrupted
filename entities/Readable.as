package entities
{
  import net.flashpunk.*;
  import net.flashpunk.utils.Input;
  
  public class Readable extends AreaEntity
  {
    public var description:String;
    public var text:String;
    
    public function Readable(x:int, y:int, width:uint, height:uint, graphic:Graphic, description:String, text:String)
    {
      super(x, y, graphic);
      setHitbox(width, height);
      layer = 4;
      this.description = description;
      this.text = text;
    }
    
    override public function update():void
    {
      if (area.paused) return;
      
      if (collideWith(Player.id, x, y))
      {
        if (Input.pressed("action"))
        {
          ReadingInterface.id.open(text);
          ActionText.id.close("Read", description);
        }
        else
        {
          ActionText.id.display("Read", description);
        }
      }
      else
      {
        ActionText.id.close("Read", description);
      }
    }
  }
}
