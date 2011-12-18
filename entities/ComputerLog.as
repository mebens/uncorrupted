package entities
{
  import net.flashpunk.*;
  import net.flashpunk.graphics.Image;
  
  public class ComputerLog extends Readable
  {
    [Embed(source = "../assets/images/computer.png")]
    public static const IMAGE:Class;
    
    public static function fromXML(o:Object):ComputerLog
    {
      return (new ComputerLog(o.@x, o.@y, o.@text)).setupFromXML(o) as ComputerLog;
    }
    
    public function ComputerLog(x:int, y:int, text:String)
    {
      super(x, y, 18, 9, new Image(IMAGE), "Computer Log", text);
    }
  }
}
