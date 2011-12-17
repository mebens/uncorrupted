package entities
{
  import net.flashpunk.*;
  import worlds.Area;
  
  public class AreaConnection extends AreaEntity
  {
    public var index:uint;
    
    public static function fromXML(o:Object):AreaConnection
    {
      return (new AreaConnection(o.@x, o.@y, o.@width, o.@height, o.@index)).setupFromXML(o) as AreaConnection;
    }
    
    public function AreaConnection(x:int, y:int, width:uint, height:uint, index:uint)
    {
      super(x, y);
      setHitbox(width, height);
      visible = false;
      this.index = index;
    }
    
    override public function update():void
    {
      if (!area.paused && collideWith(Player.id, x, y)) Area.switchTo(index);
    }
  }
}
