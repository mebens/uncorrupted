package worlds
{
  public class Area7 extends Area
  {
    [Embed(source = "../assets/areas/7.oel", mimeType = "application/octet-stream")]
    public static const DATA:Class;
    
    public function Area7(index:uint, from:int = -1)
    {
      super(DATA, index, from);
    }
  }
}
