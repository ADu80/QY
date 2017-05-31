using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using Game.Entity.Treasure;
using Game.Kernel;
using Game.Utils;
using Game.Facade;

namespace Game.Web
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class AppStorePay1 : IHttpHandler
    {
        int userID = 0;
        string orderID = "";
        int payAmount = 0;
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            userID = GameRequest.GetQueryInt("UserID", 0);
            orderID = GameRequest.GetQueryString("OrderID");
            payAmount = GameRequest.GetQueryInt("PayAmount", 0);
            PayApp(context);
        }

        protected void PayApp(HttpContext context)
        {
            #region 验证

            if (userID == 0 || orderID == "" || payAmount == 0)
            {
                context.Response.Write("非法操作");
            }
            #endregion

            #region 处理

            ShareDetialInfo detailInfo = new ShareDetialInfo();
            TreasureFacade treasureFacade = new TreasureFacade();

            //request
            detailInfo.UserID = userID;
            detailInfo.OrderID = orderID;
            detailInfo.PayAmount = Convert.ToDecimal(payAmount);
            detailInfo.ShareID = 100;

            try
            {
                Message msg = treasureFacade.FilliedApp(detailInfo);
                if (msg.Success)
                {
                    context.Response.Write("0");
                }
                else
                {
                    context.Response.Write(msg.Content);
                }
            }
            catch (Exception ex)
            {
                context.Response.Write(ex.Message);
            }
            #endregion

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
