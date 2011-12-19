package worlds
{
  public class Area8 extends Area
  {
    [Embed(source = "../assets/areas/8.oel", mimeType = "application/octet-stream")]
    public static const DATA:Class;
    
    public function Area8(index:uint, from:int = -1)
    {
      super(DATA, index, from);
    }
  }
}
