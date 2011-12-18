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
      LIST.push(Test);
      LIST.push(Test2);
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
      add(new Lighting);
      add(new Ground(width, height));
      add(Player.fromData(xml, from));
      Ground.id.loadFromXML(xml);
      loadObjects(xml);
      
      // other setup
      fade.fadeOut(FADE_TIME);
    }
    
    override public function begin():void
    {
      sendMessage("area.begin");
    }
    
    override public function end():void
    {
      sendMessage("area.save");
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
    
    private function loadObjects(data:XML):void
    {
      for each (var o:Object in data.objects.roller) add(Roller.fromXML(o));
      for each (o in data.objects.areaConnection) add(AreaConnection.fromXML(o));
    }
  }
}
