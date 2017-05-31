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
    public partial class test : System.Web.UI.Page
    {
        private string shop_id = ConfigurationManager.AppSettings["userid"];
        private string userkey = ConfigurationManager.AppSettings["userkey"];
        private string gateway = ConfigurationManager.AppSettings["gateway"];

        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) {
                TextBox1.Text = "1004";
                TextBox2.Text = "121345";
                TextBox3.Text = "500";
                TextBox4.Text = "0";
            }

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
            PayOrderController ent = new PayOrderController();
            string bank_Type = TextBox1.Text;//银行类型 
            string bank_payMoney = TextBox3.Text;//充值金额
            string goodsname = TextBox4.Text;//商品类型 
            string Account = TextBox2.Text;
            var payno = ent.PayOrderNO;//商户订单号
            var sign = "";//签名 
            var md5str = "skey=qysopen8899&rtype=" + bank_Type + "&paymoney=" + bank_payMoney + "&goodsname=" + goodsname + "&account=" + Account + "&OrderID=" + payno + "";
            sign = System.Web.Security.FormsAuthentication.HashPasswordForStoringInConfigFile(md5str, "MD5");


            Dictionary<string, object> conditions2 = new Dictionary<string, object>();


            conditions2.Add("OrderID", payno);
            conditions2.Add("ChannelOrderID", "");
            try
            {
                int var1 = Convert.ToInt32(Account);

            }
            catch
            {
                Response.Write("账户格式错误"); return;
            }
            int getuserid = ent.ifExist(int.Parse(Account));
            if (getuserid == 0) { Response.Write("玩家不存在"); return; }
            conditions2.Add("UserID", getuserid.ToString());
            conditions2.Add("GoodsType", goodsname);
            conditions2.Add("PayType", "5");
            conditions2.Add("PayAmount", bank_payMoney);
            conditions2.Add("BuyCount", "0");
            conditions2.Add("BackCount", "0");
            conditions2.Add("PayState", "1");
            int result = ent.PayOrderAdd(conditions2);

            Response.Redirect("Send.aspx?&rtype=" + bank_Type + "&PayMoney=" + bank_payMoney + "&orderid=" + payno + "&goodsname=" + goodsname);



        }

    }
}