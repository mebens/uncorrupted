package worlds
{
  public class Area9 extends Area
  {
    [Embed(source = "../assets/areas/9.oel", mimeType = "application/octet-stream")]
    public static const DATA:Class;
    
    public function Area9(index:uint, from:int = -1)
    {
      super(DATA, index, from);
    }
  }
}
