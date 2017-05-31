using System.Web;

namespace QPFront.Controller
{
    public interface IController
    {
        string Index(HttpRequest req);
        string Add(HttpRequest req);
        string Delete(HttpRequest req);
        string Update(HttpRequest req);
    }
}
