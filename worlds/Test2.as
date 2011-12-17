package worlds
{
  public class Test2 extends Area
  {
    [Embed(source = "../assets/areas/test2.oel", mimeType = "application/octet-stream")]
    public static const DATA:Class;
    
    public function Test2(index:uint, from:int = -1)
    {
      super(DATA, index, from);
    }
  }
}