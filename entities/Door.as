package entities
{
  import net.flashpunk.*;
  import net.flashpunk.graphics.Tilemap;
  import net.flashpunk.utils.Ease;
  
  public class Door extends AreaEntity
  {
    [Embed(source = "../assets/images/door.png")]
    public static const IMAGE:Class;
    
    [Embed(source = "../assets/sfx/door.mp3")]
    public static const SFX:Class;
    
    public static const TIME:Number = 0.25;
    public var minY:int;
    public var maxY:int;
    public var openMessage:String;
    public var closeMessage:String;
    public var moveTween:Tween;
    public var isOpen:Boolean;
    public var sfx:Sfx = new Sfx(SFX);
    
    public static function fromXML(o:Object):Door
    {
      return (new Door(
        o.@x,
        o.@y,
        o.@height / Game.TILE_SIZE,
        o.@openMessage,
        o.@closeMessage,
        o.@open == "true"
      )).setupFromXML(o) as Door;
    }
    
    public function Door(x:int, y:int, height:uint, openMsg:String, closeMsg:String, open:Boolean = false)
    {
      super(x, y);
      setHitbox(Game.TILE_SIZE, Game.TILE_SIZE * height);
      type = "solid";
      layer = 6;
      openMessage = openMsg;
      closeMessage = closeMsg;
      isOpen = open;
      
      minY = y - this.height;
      maxY = y;
      if (open) y = minY;
      
      var map:Tilemap = new Tilemap(IMAGE, this.width, this.height, Game.TILE_SIZE, Game.TILE_SIZE);
      if (height > 1) map.setRect(0, 0, 1, height - 1, 1);
      map.setTile(0, height - 1, 0);
      graphic = map;
    }
    
    override public function added():void
    {
      if (openMessage != "") area.addListener(openMessage, open);
      if (closeMessage != "") area.addListener(closeMessage, close);
    }
    
    override public function loadFromData(obj:Object):void
    {
      isOpen = obj.open;
      y = isOpen ? minY : maxY;
    }
    
    override public function generateData():Object
    {
      return { open: isOpen };
    }
    
    public function open(complete:Function = null):void
    {
      var time:Number = TIME * ((y - minY) / (maxY - minY));
      if (moveTween && moveTween.active) moveTween.cancel();
      moveTween = FP.tween(this, { y: minY }, time, { tweener: this, ease: Ease.quadIn, complete: complete });
      isOpen = true;
      sfx.play(sfxVolume * 0.5);
    }

    public function close(complete:Function = null):void
    {
      var time:Number = TIME * ((maxY - y) / (maxY - minY));
      if (moveTween && moveTween.active) moveTween.cancel();
      moveTween = FP.tween(this, { y: maxY }, time, { tweener: this, ease: Ease.quadIn, complete: complete });
      isOpen = false;
      sfx.play(sfxVolume * 0.5);
    }
  }
}
