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

    [Embed(source = "../assets/images/decals/person-2.png")]
    public static const PERSON_2:Class;
    
    [Embed(source = "../assets/images/decals/person-3.png")]
    public static const PERSON_3:Class;
    
    [Embed(source = "../assets/images/decals/blood-1.png")]
    public static const BLOOD_1:Class;
    
    [Embed(source = "../assets/images/decals/blood-2.png")]
    public static const BLOOD_2:Class;
    
    [Embed(source = "../assets/images/decals/blood-3.png")]
    public static const BLOOD_3:Class;
    
    [Embed(source = "../assets/images/decals/blood-4.png")]
    public static const BLOOD_4:Class;
    
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
      for each (o in data.decals.person2) addDecal(PERSON_2, o.@x, o.@y);
      for each (o in data.decals.person3) addDecal(PERSON_3, o.@x, o.@y);
      for each (o in data.decals.blood1) addDecal(BLOOD_1, o.@x, o.@y);
      for each (o in data.decals.blood2) addDecal(BLOOD_2, o.@x, o.@y);
      for each (o in data.decals.blood3) addDecal(BLOOD_3, o.@x, o.@y);
      for each (o in data.decals.blood4) addDecal(BLOOD_4, o.@x, o.@y);
    }
  }
}
