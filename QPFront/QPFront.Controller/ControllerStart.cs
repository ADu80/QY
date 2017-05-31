using QPFront.Controller.Helpers;
using QPFront.Helpers;
using System;
using System.Reflection;
using System.Web;

namespace QPFront.Controller
{
    public class ControllerStart
    {
        public static string ExecuteMethod(string controller, string action, HttpRequest req)
        {
            try
            {
                IController cb = ControllerFactory.Create(controller, "QPFront.Controller");
                if (cb == null)
                {
                    return JsonResultHelper.GetErrorJson("Controller为空");
                }
                Type t = cb.GetType();
                MethodInfo mi = t.GetMethod(action);
                object r = mi.Invoke(cb, new object[] { req });
                return r.ToString();
            }
            catch (Exception ex)
            {
                return JsonResultHelper.GetErrorJson(ex.Message);
            }
        }

    }
}
