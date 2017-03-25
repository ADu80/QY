using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace QPAgent.Web
{
    /// <summary>
    /// WebServices 的摘要说明
    /// </summary>
    public class WebServices : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string controller = context.Request["controller"];

            string jsonpCallback = context.Request["jsonpcb"];
            Game.WebServices.ControllerBase cb = Game.WebServices.ControllerFactory.Create(controller);
            string json = "";
            if (cb == null)
                json = Game.WebServices.JsonResultHelper.GetErrorJson("controler【" + controller + "】不存在！");
            else
                json = cb.ajax(cb, context.Request);

            json = string.IsNullOrEmpty(jsonpCallback) ? json : jsonpCallback + "(" + json + ")";
            context.Response.ContentType = "application/json";
            context.Response.Write(json);

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