package entities
{
  import net.flashpunk.*;
  import net.flashpunk.utils.Data;
  import worlds.Area;
  
  public class AreaEntity extends Entity
  {
    public function AreaEntity(x:int = 0, y:int = 0, graphic:Graphic = null)
    {
      super(x, y, graphic);
    }
    
    override public function added():void
    {
      if (name)
      {
        var data:String = Data.readString("area" + area.index + "-" + name);
        
        if (data != "")
        {
          var values:Array = data.split(",");
          var dataObj:Object = {};
          
          for each (var v:String in values)
          {
            var key:String = v.replace(/^([^\:]+)\:.+/, "$1");
            var value:String = v.replace(/^\w+\:(.+)/, "$1");
            
            if (value.charAt() == '"')
            {
              dataObj[key] = value.replace(/"(.+)"/, "$1");
            }
            else if (value == "true" || value == "false")
            {
              dataObj[key] = value == "true";
            }
            else
            {
              dataObj[key] = Number(value);
            }
          }
          
          loadFromData(dataObj);
        }
      }
      
      area.addListener("area.save", saveData);
    }
    
    public function setupFromXML(o:Object):AreaEntity
    {
      if (o.@name) name = o.@name;
      return this;
    }
        
    public function loadFromData(obj:Object):void
    {
      
    }
    
    public function generateData():Object
    {
      return {};
    }
    
    public function get area():Area
    {
      return world as Area;
    }
    
    public function get sfxVolume():Number
    {
      return FP.scale(FP.distance(Player.id.x, Player.id.y, x, y) / 150, 0, 1, 1, 0);
    }
    
    private function saveData():void
    {
      if (!name) return;
      var data:Object = generateData();
      var dataStr:String = "";
      
      for (var k:String in data)
      {
        dataStr += k + ":";
        
        if (data[k] is String)
        {
          dataStr += '"' + data[k] + '"';
        }
        else if (data[k] is Boolean)
        {
          dataStr += data[k] ? "true" : "false";
        }
        else
        {
          dataStr += String(data[k]); // Number
        }
        
        dataStr += ",";
      }
      
      Data.writeString("area" + area.index + "-" + name, dataStr.substr(0, dataStr.length - 1));
    }
  }
}