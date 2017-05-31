using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Game.Utils;
using Game.Kernel;
using Game.Facade;
using Game.Entity.NativeWeb;

namespace Game.Web.PhoneService.Feedback
{
    public partial class FeedbackInfo : System.Web.UI.Page
    {
        #region Fields

        string accounts = GameRequest.GetFormString("P1");
        string content = GameRequest.GetFormString("P2");

        private AccountsFacade accountsFacade = new AccountsFacade();
        private NativeWebFacade webFacade = new NativeWebFacade();
        #endregion

        #region 窗口事件

        protected void Page_Load(object sender, EventArgs e)
        {
            //检查
            if (accounts == "")
            {
                Response.Write(1);
                return;
            }
            else
            {
                Message umsg = accountsFacade.IsAccountsExist(accounts);
                if (umsg.Success)
                {
                    Response.Write(1);
                    return;
                }
            }

            //逻辑处理
            GameFeedbackInfo info = new GameFeedbackInfo();
            info.Accounts = accounts;
            info.FeedbackTitle = TextFilter.FilterScript(content);
            info.FeedbackContent = TextFilter.FilterScript(content);            
            info.ClientIP = GameRequest.GetUserIP();
            Message msg = webFacade.PublishFeedback(info);
            if (msg.Success)
            {
                Response.Write(0);
            }
            else
            {
                Response.Write(1);
            }
        }
        #endregion
        
    }
}
