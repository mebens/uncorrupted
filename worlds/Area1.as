package worlds
{
  public class Area1 extends Area
  {
    [Embed(source = "../assets/areas/1.oel", mimeType = "application/octet-stream")]
    public static const DATA:Class;
    
    public function Area1(index:uint, from:int = -1)
    {
      super(DATA, index, from);
    }
  }
}