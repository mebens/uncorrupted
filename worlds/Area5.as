package worlds
{
  public class Area5 extends Area
  {
    [Embed(source = "../assets/areas/5.oel", mimeType = "application/octet-stream")]
    public static const DATA:Class;
    
    public function Area5(index:uint, from:int = -1)
    {
      super(DATA, index, from);
    }
  }
}
