using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using QPFront.Controller;
using Game.Entity.Treasure;
using Game.Web.Controllers;

namespace pay.uka
{
    public partial class doquery : System.Web.UI.Page
    {
        private string shop_id = ConfigurationManager.AppSettings["userid"];
        private string userkey = ConfigurationManager.AppSettings["userkey"];
        private string gateway = ConfigurationManager.AppSettings["gateway"];

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            SendDoQuery();
        }

        /// <summary>
        ///优卡联盟查询接口
        /// </summary>
        /// <param name="orderid">订单号</param>
        /// <param name="callBackurl">返回地址</param>
        private void SendDoQuery()
        {
            if (!String.IsNullOrEmpty(Request.Form["orderid"].ToString()))
            {
                PayOrderController ent = new PayOrderController();
                Dictionary<string, object> conditions2 = new Dictionary<string, object>();

                String orderid = Request.Form["orderid"];
                conditions2.Add("OrderID", orderid);
                var r=ent.PayOrderGet(conditions2);
                Literal1 .Text= "";
                if (r == 1) {
                    Literal1.Text = "充值中";
                }
                if (r == 2)
                {
                    Literal1.Text = "充值成功";
                }

                if (r == 3)
                {
                    Literal1.Text = "充值失败";
                }
                if (r == -1)
                {
                    Literal1.Text = "订单不存在";
                }


                PayOrder getmodel = ent.PayOrderArr(orderid);
                if (getmodel != null)
                {
                    getmodel.PayState = "2";
                    getmodel.OrderID = orderid;
                    NotiSerController.NotiChongZhi(getmodel);
                }
                var md5str = "skey=qysopen8899&rtype=1004&paymoney=0.1&goodsname=1&buyCount=100&BackCount=1&account=qylw003&OrderID=2017042912072786";

                var mdgetstr= System.Web.Security.FormsAuthentication.HashPasswordForStoringInConfigFile(md5str, "MD5");
 
            }

        }

    }
}