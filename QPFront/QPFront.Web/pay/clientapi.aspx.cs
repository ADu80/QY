using QPFront.Controller;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace pay.uka
{
    public partial class clientapi : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            string bank_Type = "1003";//银行类型 
            string bank_payMoney ="0.1";//充值金额
            string goodsname = "0";//商品类型 
            string Account = Request["Account"].ToString();
            var payno = Request.QueryString["OrderID"].ToString();//商户订单号
            var sign = Request.QueryString["sign"].ToString();//签名

            if (Request["rtype"] != null)
            {
                bank_Type = Request.QueryString["rtype"].ToString();
            }

            if (Request["goodsname"] != null)
            {
                goodsname = Request.QueryString["goodsname"].ToString();
            }

            if (Request["PayMoney"] != null)
            {
                bank_payMoney = Request.QueryString["PayMoney"].ToString();
            }
            var md5str = "skey=qysopen8899&rtype=" + bank_Type + "&paymoney=" + bank_payMoney + "&goodsname=" + goodsname + "&account=" + Account + "&OrderID=" + payno + "";

            var mdgetstr = System.Web.Security.FormsAuthentication.HashPasswordForStoringInConfigFile(md5str, "MD5");
            if (sign.ToLower() != mdgetstr.ToLower())
            {
                Response.Write("签名不正确"); return;
            }
            PayOrderController ent = new PayOrderController();

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

            Response.Redirect("ClientSend.aspx?&rtype=" + bank_Type + "&PayMoney=" + bank_payMoney + "&orderid=" + payno + "&goodsname=" + goodsname);

        }

    }
}