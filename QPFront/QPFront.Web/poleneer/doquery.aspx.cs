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
using System.Text;
using System.Net;
using System.IO;
using System.Web.Script.Serialization;

namespace pay.poleneer
{
    public partial class doquery : System.Web.UI.Page
    {

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
                PayOrder getmodel = ent.PayOrderArr(orderid);
               
                var geturl = "http://pay.poleneer.com/service/m_get_order?order_no=" + getmodel .ChannelOrderID+ "";
                var uri = geturl;
                var json = "";
                byte[] b = Encoding.ASCII.GetBytes(json);
                HttpWebRequest req = (HttpWebRequest)HttpWebRequest.Create(uri);
                req.Method = "POST";
                req.ContentType = "text/html";
                req.ContentLength = b.Length;
                req.Headers.Set("Pragma", "no-cache");
                req.Timeout = 60000;
                Stream reqstream = req.GetRequestStream();
                reqstream.Write(b, 0, b.Length);
                WebResponse res = req.GetResponse();
                Stream stream = res.GetResponseStream();
                StreamReader sr = new StreamReader(stream, Encoding.UTF8);
                string result = sr.ReadToEnd();
                reqstream.Close();
                reqstream.Dispose();
                sr.Close();
                sr.Dispose();
                stream.Close();
                stream.Close();

                JavaScriptSerializer jss = new JavaScriptSerializer();
                AllGet abc = jss.Deserialize<AllGet>(result) as AllGet;
                var issucc = abc.success;
                var getstate = abc.data[0].state;//0:未支付/支付失败;1:支付成功


                Literal1.Text = "";
                if (getstate == 0)
                {
                    Literal1.Text = "充值中";
                }

                if (getstate == 1)
                {
                   
                    Dictionary<string, object> conditionsEdit = new Dictionary<string, object>();

                    conditionsEdit.Add("OrderID", orderid);
                    conditionsEdit.Add("ErrorCode", "");
                    conditionsEdit.Add("PayState", "2");//充值成功
                    ent.PayOrderEdit(conditionsEdit);

                    Literal1.Text = "充值成功";
                }
                if (getmodel ==null)
                {
                    Literal1.Text = "订单不存在";
                }

                //PayOrder getmodel = ent.PayOrderArr(orderid);
                //if (getmodel != null)
                //{
                //    getmodel.PayState = "2";
                //    getmodel.OrderID = orderid;
                //    NotiSerController.NotiChongZhi(getmodel);
                //}
                //var md5str = "skey=qysopen8899&rtype=1004&paymoney=0.1&goodsname=1&buyCount=100&BackCount=1&account=qylw003&OrderID=2017042912072786";

                //var mdgetstr= System.Web.Security.FormsAuthentication.HashPasswordForStoringInConfigFile(md5str, "MD5");

            }

        }
        public class AllGet
        {
            public List<GetModel> data { get; set; }
            public bool success { get; set; }
        }
        public class GetModel
        {
            public string order_no { get; set; }
            public string amount { get; set; }
            public int state { get; set; }
            public string body { get; set; }
        }

        // \"data\":[{\"order_no\":\"15217221119T149492198132231\",\"amount\":\"500.00\",\"state\":0,\"body\":\"会员充值\"}],\"success\":true}

    }
}