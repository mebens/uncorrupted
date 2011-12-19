package worlds
{
  public class Area6 extends Area
  {
    [Embed(source = "../assets/areas/6.oel", mimeType = "application/octet-stream")]
    public static const DATA:Class;
    
    public function Area6(index:uint, from:int = -1)
    {
      super(DATA, index, from);
    }
  }
}
