using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;

namespace QPAgent.WebServices
{
    public interface IController
    {
        string ajax(HttpRequest req);
        string Index(HttpRequest req);
        string New(HttpRequest req);
        string Edit(HttpRequest req);
        string Delete(HttpRequest req);
    }
}
