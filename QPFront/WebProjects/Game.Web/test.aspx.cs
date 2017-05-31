using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Game.Web
{
    public partial class test : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 大厅cookie处理
            object pfCookieUserName = HttpContext.Current.Request.Cookies["Accounts"];
            object pfCookieUserID = HttpContext.Current.Request.Cookies["UserID"];
            
            // 大厅Cookie存在
            if (pfCookieUserName != null && pfCookieUserID != null)
            {
                Response.Write("用户名:" + pfCookieUserName.ToString() + "<br/>");
                Response.Write("用户ID:" + pfCookieUserID.ToString() + "<br/>");
            }
            else 
            {
                Response.Write("没有读取到大厅cookies");
            }
        }
    }
}
