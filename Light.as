package
{
  import flash.geom.Point;
  
  public class Light
  {
    public var scale:Number = 1;
    public var alpha:Number = 1;
    private var _x:int = 0;
    private var _y:int = 0;
    private var _point:Point;
    
    public function Light(x:int, y:int, scale:Number = 1, alpha:Number = 1)
    {
      _x = x;
      _y = y;
      _point = new Point(x, y);
      this.scale = scale;
      this.alpha = alpha;
    }
    
    public function get x():int
    {
      return _x;
    }
    
    public function set x(value:int):void
    {
      _x = _point.x = value;
    }
    
    public function get y():int
    {
      return _y;
    }
    
    public function set y(value:int):void
    {
      _y = _point.y = value;
    }
    
    public function get point():Point
    {
      return _point;
    }
  }
}
