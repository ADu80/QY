using Game.Entity.PlatformManager;
using Game.Facade;
using QPAgent.WebServices;
using System;

namespace QPAgent.Web
{
    public partial class Login : System.Web.UI.Page
    {
        protected AdminCookie.SesionUser userExt = null;
        protected PlatformManagerFacade aidePlatformManagerFacade = new PlatformManagerFacade();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.Form.Count > 0)
            {
                #region 同步请求
                //userExt = AdminCookie.GetUserFromCookie();
                //string json = "";
                //if (userExt == null || userExt.UserID <= 0 || userExt.RoleID <= 0)
                //{
                //    json = ControllerBase.Login(Request);
                //    if (!json.Contains("success"))
                //    {
                //        lblmsg.Text = JsonHelper.GetSingleItemValue(json, "message").ToString();
                //        lblmsg.ForeColor = System.Drawing.Color.Red;
                //        return;
                //    }
                //}
                //Response.Redirect("/Default.aspx");
                #endregion

                #region 异步请求
                userExt = AdminCookie.GetUserFromCookie();
                string json = "";
                if (userExt == null || userExt.UserID <= 0 || userExt.RoleID <= 0)
                {
                    json = ControllerBase.Login(Request);
                }
                else
                {
                    json = JsonResultHelper.GetSuccessJson("登录成功");
                }
                Response.ContentType = "application/json";
                Response.Write(json);
                #endregion
            }
        }
    }
}