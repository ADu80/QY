using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;

namespace pay.uka
{
    public partial class Send : System.Web.UI.Page
    {
        private string userid = ConfigurationManager.AppSettings["userid"];
        private string userkey = ConfigurationManager.AppSettings["userkey"];
        private string gateway = ConfigurationManager.AppSettings["gateway"];
        private string callBack = ConfigurationManager.AppSettings["callBackurl"];
        private string hrefBack = ConfigurationManager.AppSettings["hrefBackurl"];

        protected void Page_Load(object sender, EventArgs e)
        {
            SendToPay();
        }

        /// <summary>
        /// 优卡联盟支付
        /// </summary>
        /// <param name="orderid"></param>
        /// <param name="callBackurl">返回地址</param>
        private void SendToPay()
        {
            string orderid = Request.QueryString["orderid"].ToString(); 
            string callBackurl = callBack; // 下行异步通知地址
            string hrefBackurl = hrefBack;  // 下行同步通知地址
            //银行提交获取信息
            string bank_Type = Request.QueryString["rtype"].ToString();//银行类型 
            string bank_payMoney = Request.QueryString["PayMoney"].ToString();//充值金额
            string goodsname = "会员充值"; 
            goodsname = HttpUtility.UrlEncode(goodsname, System.Text.Encoding.GetEncoding("GB2312"));
             
            String param = String.Format("parter={0}&type={1}&value={2}&orderid={3}&callbackurl={4}", userid, bank_Type, bank_payMoney, orderid, callBackurl);
            String PostUrl = String.Format("{2}?{0}&sign={1}&attach=test&hrefbackurl=" + hrefBackurl + "&goodsname={3}", param, md5.MD5(param + userkey).ToLower(), gateway, goodsname);
            //代理参数
            string agent = "";//代理ID
            PostUrl = PostUrl + "&agent=" + agent;

            Response.Redirect(PostUrl);
        }
    }
}