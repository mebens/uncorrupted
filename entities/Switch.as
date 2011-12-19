package entities
{
  import net.flashpunk.*;
  import net.flashpunk.graphics.Spritemap;
  import net.flashpunk.utils.Input;
  
  public class Switch extends AreaEntity
  {
    [Embed(source = "../assets/images/switch.png")]
    public static const IMAGE:Class;
    
    [Embed(source = "../assets/sfx/switch.mp3")]
    public static const SFX:Class;
    
    public var map:Spritemap;
    public var onMessage:String;
    public var offMessage:String;
    public var on:Boolean;
    public var sfx:Sfx = new Sfx(SFX);
    
    public static function fromXML(o:Object):Switch
    {
      return (new Switch(o.@x, o.@y, o.@onMessage, o.@offMessage, o.@on == "true")).setupFromXML(o) as Switch;
    }
    
    public function Switch(x:int, y:int, onMsg:String, offMsg:String, on:Boolean = false)
    {
      super(x, y);
      setHitbox(Game.TILE_SIZE, Game.TILE_SIZE);
      layer = 3;
      onMessage = onMsg;
      offMessage = offMsg;
      this.on = on;
      
      graphic = map = new Spritemap(IMAGE, width, height);
      map.setFrame(on ? 0 : 1);
    }
    
    override public function update():void
    {
      if (area.paused) return;
      
      if (collideWith(Player.id, x, y))
      {
        ActionText.id.display(name, "Activate", "Switch");
        
        if (Input.pressed("action"))
        {
          on = !on;
          map.setFrame(on ? 0 : 1);
          sfx.play();
          
          if (on && onMessage)
          {
            area.sendMessage(onMessage);
          }
          else if (!on && offMessage)
          {
            area.sendMessage(offMessage);
          }
        }
      }
      else if (ActionText.id.currentName == name)
      {
        ActionText.id.close(name);
      }
    }
    
    override public function loadFromData(obj:Object):void
    {
      on = obj.on;
      map.setFrame(on ? 0 : 1);
    }
    
    override public function generateData():Object
    {
      return { on: on };
    }
  }
}
