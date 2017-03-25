using System;
using System.Web;
using Newtonsoft.Json;
using System.Text;
using Game.Utils;
using Game.Facade;
using Game.Entity.PlatformManager;

namespace Game.Web
{
    public class LoginPage : System.Web.UI.Page
    {
        protected static string FullPath = string.Empty;
        protected internal Base_Users userExt;

        public LoginPage()
        {
            userExt = AdminCookie.GetUserFromCookie();
        }
        protected void Page_Init(object sender, EventArgs e)
        {
            FullPath = string.Concat(Request.Url.Scheme, "://", Request.Url.Host, ":", Request.Url.Port);
        }
        /// <summary>
        /// MD5混合加密
        /// </summary>
        /// <param name="password">明文密码</param>
        /// <returns>string</returns>
        protected string SetMD5(string password)
        {
            return Utility.MD5(password);
        }
        /// <summary>
        /// ajax请求输出
        /// </summary>
        /// <param name="ContentType">输出内容类型</param>
        /// <param name="obj">输出值</param>
        protected void outputobject(string ContentType, object obj)
        {
            HttpContext.Current.Response.ContentEncoding = Encoding.GetEncoding("UTF-8");
            HttpContext.Current.Response.ContentType = ContentType;
            HttpContext.Current.Response.StatusCode = 200;
            HttpContext.Current.Response.Write(obj);
            HttpContext.Current.Response.End();
        }
        /// <summary>
        /// ajax请求输出
        /// </summary>
        /// <param name="obj">输出值,text/plain类型</param>
        protected void outputobject(object obj)
        {
            outputobject("text/plain", obj);
        }
        /// <summary>
        /// ajax请求输出
        /// </summary>
        /// <param name="obj">输出javascript值,text/html类型</param>
        protected void outputJscript(object textJs)
        {
            StringBuilder sBuilder = new StringBuilder();
            sBuilder.Append("<script type=\"text/javascript\" language=\"javascript\">").Append(textJs).Append("</script>");
            outputobject("text/html", sBuilder);
        }
        /// <summary>
        /// ajax请求输出
        /// </summary>
        /// <param name="obj">输出json值,text/plain类型</param>
        protected void outputJson(Object obj)
        {
            outputobject("text/plain", JsonConvert.SerializeObject(obj));
        }
    }
}