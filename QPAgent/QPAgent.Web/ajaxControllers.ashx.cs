using QPAgent.WebServices;
using System.Web;
using System.Web.SessionState;

namespace QPAgent.Web
{
    /// <summary>
    /// ajaxControllers 的摘要说明
    /// </summary>
    public class ajaxControllers : IHttpHandler , IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            string controller = context.Request["controller"];
            ControllerBase cb = ControllerFactory.Create(controller);
            string json = "";
            if (cb == null)
            {
                json = JsonResultHelper.GetErrorJson("controler【" + controller + "】不存在！");
            }
            else
            {
                json = cb.ajax(context.Request);
            }

            context.Response.ContentType = "application/json";
            context.Response.Write(json);
        }

        public bool IsReusable
        {
            get { return false; }
        }
    }
}