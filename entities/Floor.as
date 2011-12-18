package entities
{
  import flash.display.BitmapData;
  import net.flashpunk.*;
  import net.flashpunk.graphics.Canvas;
  import net.flashpunk.graphics.Tilemap;
  import net.flashpunk.masks.Grid;
  
  public class Floor extends AreaEntity
  {
    [Embed(source = "../assets/images/decals/person-1.png")]
    public static const PERSON_1:Class;
    
    public static var id:Floor;
    
    public var map:Tilemap;
    public var decals:Canvas;
    public var grid:Grid;
    
    public function Floor(width:uint, height:uint)
    {
      id = this;
      type = "solid";
      layer = 5;
      setHitbox(width, height);
      
      map = new Tilemap(Game.TILES, width, height, Game.TILE_SIZE, Game.TILE_SIZE);
      map.usePositions = true;
      addGraphic(map);
      
      decals = new Canvas(width, height);
      addGraphic(decals);
      
      mask = grid = new Grid(width, height, Game.TILE_SIZE, Game.TILE_SIZE);
      grid.usePositions = true;
    }
    
    public function addDecal(data:*, x:int, y:int):void
    {
      decals.draw(x, y, data is Class ? FP.getBitmap(Class(data)) : BitmapData(data));
    }
    
    public function loadFromXML(data:XML):void
    {
      for each (var o:Object in data.floor.tile)
      {
        map.setTile(o.@x, o.@y, o.@id);
        grid.setTile(o.@x, o.@y);
      }
      
      for each (o in data.floor.rect)
      {
        map.setRect(o.@x, o.@y, o.@w, o.@h, o.@id);
        grid.setRect(o.@x, o.@y, o.@w, o.@h);
      }
      
      for each (o in data.decals.person1) addDecal(PERSON_1, o.@x, o.@y);
    }
  }
}
