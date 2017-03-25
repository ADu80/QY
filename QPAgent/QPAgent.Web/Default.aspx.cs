using Game.Entity.PlatformManager;
using Game.Facade;
using Game.Utils;
using QPAgent.WebServices;
using System;
using System.Data;

namespace QPAgent.Web
{
    public partial class Default : System.Web.UI.Page
    {
        protected string roleName = "";
        protected AdminCookie.SesionUser userExt = null;
        protected PlatformManagerFacade aidePlatformManagerFacade = new PlatformManagerFacade();

        protected void Page_Load(object sender, EventArgs e)
        {
            //登录判断
            userExt = AdminCookie.GetUserFromCookie();
            if (userExt == null || userExt.UserID <= 0 || userExt.RoleID <= 0)
            {
                Response.Redirect("Login.aspx");
            }
            else
            {
                if (userExt.RoleID == 1)
                {
                    roleName = "超级管理员";
                }
                else
                {
                    roleName = aidePlatformManagerFacade.GetRolenameByRoleID(userExt.RoleID);
                }

            }
            Utility.ClearPageClientCache();
        }

    }
}