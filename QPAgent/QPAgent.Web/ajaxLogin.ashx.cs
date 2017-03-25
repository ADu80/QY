using Game.Facade;
using QPAgent.WebServices;
using System.Web;
using System.Web.SessionState;
namespace QPAgent.Web
{
    /// <summary>
    /// ajaxLogin 的摘要说明
    /// </summary>
    public class ajaxLogin : IHttpHandler, IRequiresSessionState
    {
        protected AdminCookie.SesionUser userExt = null;
        protected PlatformManagerFacade aidePlatformManagerFacade = new PlatformManagerFacade();


        public void ProcessRequest(HttpContext context)
        {
            HttpRequest req = context.Request;
            HttpResponse res = context.Response;
            string type = req["type"];
            string json = "";
            if (type.ToLower() == "login")
            {
                json = Login(req);
            }
            else
            {
                json = Logout();
            }
            res.ContentType = "application/json";
            res.Write(json);
        }

        string Login(HttpRequest req)
        {
            userExt = AdminCookie.GetUserFromCookie();
            if (userExt == null || userExt.UserID <= 0 || userExt.RoleID <= 0)
            {
                return ControllerBase.Login(req);
            }

            return JsonResultHelper.GetSuccessJson("[" + userExt.Username + "]登录成功");
        }

        string Logout()
        {
            return ControllerBase.Logout();
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}