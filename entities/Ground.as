package entities
{
  import net.flashpunk.*;
  import net.flashpunk.graphics.Tilemap;
  import net.flashpunk.masks.Grid;
  
  public class Ground extends AreaEntity
  {
    [Embed(source = "../assets/images/tiles.png")]
    public static const TILES:Class;
    
    public static var id:Ground;
    
    public var floor:Tilemap;
    public var walls:Tilemap;
    public var grid:Grid;
    
    public function Ground(width:uint, height:uint)
    {
      id = this;
      type = "solid";
      layer = 1;
      setHitbox(width, height);
      
      walls = new Tilemap(TILES, width, height, Game.TILE_SIZE, Game.TILE_SIZE);
      walls.usePositions = true;
      walls.color = 0xAAAAAA;
      addGraphic(walls);
      
      floor = new Tilemap(TILES, width, height, Game.TILE_SIZE, Game.TILE_SIZE);
      floor.usePositions = true;
      addGraphic(floor);
      
      mask = grid = new Grid(width, height, Game.TILE_SIZE, Game.TILE_SIZE);
      grid.usePositions = true;
    }
    
    public function loadFromXML(data:XML):void
    {
      for each (var o:Object in data.walls.tile) walls.setTile(o.@x, o.@y, o.@id);
      for each (o in data.walls.rect) walls.setRect(o.@x, o.@y, o.@w, o.@h, o.@id);
      
      for each (o in data.floor.tile)
      {
        floor.setTile(o.@x, o.@y, o.@id);
        grid.setTile(o.@x, o.@y);
      }
      
      for each (o in data.floor.rect)
      {
        floor.setRect(o.@x, o.@y, o.@w, o.@h, o.@id);
        grid.setRect(o.@x, o.@y, o.@w, o.@h);
      }
    } 
  }
}
