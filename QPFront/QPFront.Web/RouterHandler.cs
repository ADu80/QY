using QPFront.Controller;
using QPFront.Controller.Helpers;
using QPFront.Helpers;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.SessionState;

namespace QPFront.Web
{
    public class RouterHandler : IHttpHandler, IRequiresSessionState
    {
        public bool IsReusable
        {
            get
            {
                return true;
            }
        }

        public void ProcessRequest(HttpContext context)
        {
            HttpRequest req = context.Request;
            HttpResponse res = context.Response;

            string querystring = req.RawUrl.Replace("/api", "");

            MatchCollection mc = Regex.Matches(querystring, "/\\w+");
            if (mc.Count < 2)
            {
                SendJsonResponse(res, JsonResultHelper.GetErrorJson("请求不正确"));
                return;
            }
            string controller = mc[0].Value.Replace("/", "");
            string action = mc[1].Value.Replace("/", "");
            if (action.ToLower().Trim() == "list")
            {
                action = "Index";
            }
            string jsonpCallback = req["jsonpcb"];
            string json = "";

            json = ControllerStart.ExecuteMethod(controller, action, req);
            json = string.IsNullOrEmpty(jsonpCallback) ? json : (jsonpCallback + "(" + json + ")");

            LogHelper.WriteLog("RouterHandler", "json: " + json);

            SendJsonResponse(res, json);
        }

        void SendJsonResponse(HttpResponse res, string json)
        {
            res.ContentType = "application/json";
            res.Write(json);
        }
    }
}