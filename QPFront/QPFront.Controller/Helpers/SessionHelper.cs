using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.SessionState;

namespace QPFront.Controller.Helpers
{
    public class SessionHelper
    {
        public static void SetSession(string key, string value)
        {
            HttpContext.Current.Session[key] = value;

        }

        public static string GetSession(string key)
        {
            return HttpContext.Current.Session[key].ToString();
        }
    }
}
