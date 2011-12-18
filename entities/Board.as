package entities
{
  import net.flashpunk.*;
  import net.flashpunk.graphics.Image;
  
  public class Board extends Readable
  {
    [Embed(source = "../assets/images/board.png")]
    public static const IMAGE:Class;
    
    public static function fromXML(o:Object):Board
    {
      return (new Board(o.@x, o.@y, o.@text)).setupFromXML(o) as Board;
    }
    
    public function Board(x:int, y:int, text:String)
    {
      super(x, y, 27, 18, new Image(IMAGE), "Board", text);
    }
  }
}
