using System.Web;

namespace Game.WebServices
{
    public interface IController
    {
        string ajax(ControllerBase controller, HttpRequest req);
    }
}
