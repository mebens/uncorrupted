package entities
{
  import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.*;
	import net.flashpunk.graphics.Image;
	
  public class Lighting extends AreaEntity
  {
    [Embed(source = "../assets/images/light.png")]
    public static const LIGHT:Class;
    
    [Embed(source = "../assets/images/end-light.png")]
    public static const END_LIGHT:Class;
    
    public static var id:Lighting;
    public static var image:Image = new Image(LIGHT);
    public static var endImage:Image = new Image(END_LIGHT);
    
    public var canvas:BitmapData;
    public var size:Rectangle;
    public var lights:Vector.<Light> = new Vector.<Light>();

    public function Lighting()
    {
      id = this;
      layer = -1;
      canvas = new BitmapData(FP.width, FP.height, false, 0xFFFFFF);
      size = new Rectangle(0, 0, FP.width, FP.height);
      image.centerOrigin();
      endImage.originX = endImage.width;
    }
    
    public function add(l:Light):void
    {
      lights.push(l);
    }
    
    public function remove(l:Light):void
    {
      for (var i:uint = 0; i < lights.length; i++)
      {
        if (lights[i] == l) lights.splice(i, 1);
      }
    }
    
    override public function render():void
    {
      super.render();
      canvas.fillRect(size, 0xFFFFFF);
      
      for (var i:uint; i < lights.length; i++)
      {
        if (lights[i].end)
        {
          endImage.render(canvas, lights[i].point, FP.camera);
        }
        else
        {
          image.scale = lights[i].scale;
          image.alpha = lights[i].alpha;
          image.render(canvas, lights[i].point, FP.camera);
        }
      }
      
      var img:Image = new Image(canvas);
      img.blend = BlendMode.SUBTRACT;
      img.render(FP.buffer, FP.camera, FP.camera);
    }
  }
}
