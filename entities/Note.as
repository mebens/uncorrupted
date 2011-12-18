package entities
{
  import net.flashpunk.*;
  import net.flashpunk.graphics.Image;
  
  public class Note extends Readable
  {
    [Embed(source = "../assets/images/note.png")]
    public static const IMAGE:Class;
    
    public static function fromXML(o:Object):Note
    {
      return (new Note(o.@x, o.@y, o.@text)).setupFromXML(o) as Note;
    }
    
    public function Note(x:int, y:int, text:String)
    {
      super(x, y, 8, 2, new Image(IMAGE), "Note", text);
    }
  }
}
