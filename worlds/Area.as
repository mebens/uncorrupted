/*
Layers

-4: Fade
-3: Reading Interface
-2: Action Text
-1: Lighting
0: Enemies
1: Player
2: Bullets
3: Before-floor Objects
4: Readables
5: Floor
6: After-floor Objects
7: Walls
*/

package worlds
{
  import flash.utils.Dictionary;
  import net.flashpunk.*;
  import entities.*;
  
  public class Area extends World
  {
    public static const LIST:Array = [];
    public static const FADE_TIME:Number = 0.15;
    public static var current:Area;
    
    public var index:uint;
    public var width:uint;
    public var height:uint;
    public var fromIndex:int;
    public var paused:Boolean = false;
    public var fade:Fade;
    public var listeners:Dictionary = new Dictionary;
    
    public static function init():void
    {
      LIST.push(Area1);
    }
    
    public static function load(index:uint, from:int = -1):void
    {
      if (!LIST[index]) throw new Error("An area by the index of " + index + " doesn't exist.");
      FP.world = current = new LIST[index](index, from);
    }
    
    public static function switchTo(index:uint):void
    {
      if (current)
      {
        current.paused = true;
        current.save();
        current.fade.fadeIn(FADE_TIME, function():void { load(index, current.index); });
      }
      else
      {
        load(index);
      }
    }
    
    public function Area(data:Class, index:uint, from:int = -1)
    {
      var xml:XML = FP.getXML(data);
      width = xml.width;
      height = xml.height;
      fromIndex = from;
      this.index = index;
      
      // entities
      add(fade = new Fade);
      add(new ReadingInterface)
      add(new ActionText);
      add(new Lighting);
      add(Player.fromData(xml, from));
      add(new Floor(width, height));
      add(new Walls(width, height));
      Floor.id.loadFromXML(xml);
      Walls.id.loadFromXML(xml);
      loadObjects(xml);
      
      // other setup
      fade.fadeOut(FADE_TIME);
    }
    
    override public function begin():void
    {
      sendMessage("area.begin");
    }
    
    override public function update():void
    {
      super.update();
      FP.camera.x = Player.id.x - FP.width / 2;
      FP.camera.y = Player.id.y - FP.height / 2;
      FP.clampInRect(FP.camera, 0, 0, Math.max(width - FP.width, 0), Math.max(height - FP.height, 0));
    }
    
    public function addListener(message:String, callback:Function):void
    {
      for each (var msg:String in message.split(","))
      {
        if (!listeners[msg]) listeners[msg] = new Dictionary;
        listeners[msg][callback] = true;
      }
    }
    
    public function removeListener(message:String, callback:Function):void
    {
      if (!listeners[message]) throw new Error("The message '" + message + "' doesn't exist.");
      delete listeners[message][callback];
    }
    
    public function sendMessage(message:String):void
    {
      if (!listeners[message]) return;
      for (var f:Object in listeners[message]) f();
    }
    
    public function reload():void
    {
      current.fade.fadeIn(FADE_TIME, function():void { load(index, fromIndex); });
    }
    
    public function save():void
    {
      sendMessage("area.save");
    }
    
    private function loadObjects(data:XML):void
    {
      for each (var o:Object in data.objects.roller) add(Roller.fromXML(o));
      for each (o in data.objects["switch"]) add(Switch.fromXML(o));
      for each (o in data.objects.door) add(Door.fromXML(o));
      for each (o in data.objects.note) add(Note.fromXML(o));
      for each (o in data.objects.areaConnection) add(AreaConnection.fromXML(o));
    }
  }
}
