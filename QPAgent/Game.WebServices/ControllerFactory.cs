namespace Game.WebServices
{
    public class ControllerFactory
    {
        public static ControllerBase Create(string controller)
        {
            switch (controller)
            {
                case "Gamer":
                    return new GamerController();
                default: return null;
            }
        }
    }
}
