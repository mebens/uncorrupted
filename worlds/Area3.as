package worlds
{
  public class Area3 extends Area
  {
    [Embed(source = "../assets/areas/3.oel", mimeType = "application/octet-stream")]
    public static const DATA:Class;
    
    public function Area3(index:uint, from:int = -1)
    {
      super(DATA, index, from);
    }
  }
}
