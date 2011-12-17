package worlds
{
  public class Test extends Area
  {
    [Embed(source = "../assets/areas/test.oel", mimeType = "application/octet-stream")]
    public static const DATA:Class;
    
    public function Test(index:uint, from:int = -1)
    {
      super(DATA, index, from);
    }
  }
}