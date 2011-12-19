package worlds
{
  public class Area10 extends Area
  {
    [Embed(source = "../assets/areas/10.oel", mimeType = "application/octet-stream")]
    public static const DATA:Class;
    
    public function Area10(index:uint, from:int = -1)
    {
      super(DATA, index, from);
    }
  }
}
