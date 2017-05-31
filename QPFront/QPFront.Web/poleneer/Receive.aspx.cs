using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using QPFront.Controller;
using Game.Web.Controllers;
using Game.Entity.Treasure;

namespace pay.poleneer
{
    public partial class Receive : System.Web.UI.Page
    {
        private string appkey = ConfigurationManager.AppSettings["poleneer_appkey"];

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                //返回参数
                String shop_id = Request["shop_id"];//商户ID
                String order_no = Request["order_no"];//订单流水号
                String amount = Request["amount"];//金额
                String sign = Request["sign"];//返回签名
                String state = Request["state"];//支付状态 0:支付失败;1:支付成功 
                String param = String.Empty;
 
                param = String.Format("{0}{1}{2}", shop_id, amount,  appkey);//组织参数

                //比对签名是否有效
                if (sign.Trim().ToLower().Equals(md5.MD5(param).ToLower()))
                {
                    PayOrderController ent = new PayOrderController();

                    PayOrder getmodel = ent.PayOrderArrByChannel(order_no);
                    //执行操作方法 
                    if (state.Trim().Equals("1"))
                    {

                       
                        Dictionary<string, object> conditions2 = new Dictionary<string, object>();

                        conditions2.Add("OrderID", getmodel.OrderID);
                        conditions2.Add("ErrorCode", "");
                        conditions2.Add("PayState", "2");
                        int result = ent.PayOrderEdit(conditions2); 
                         
                        if (getmodel != null)
                        {
                            getmodel.PayState = "2";
                            getmodel.OrderID = getmodel.OrderID;
                            NotiSerController.NotiChongZhi(getmodel);
                        }

                        Response.Write("SUCCESS");
                       
                    }
                    else    
                    {
                       
                        Dictionary<string, object> conditions2 = new Dictionary<string, object>();

                        conditions2.Add("OrderID", getmodel.OrderID);
                        conditions2.Add("ErrorCode", "支付失败");
                        conditions2.Add("PayState", "3");
                        int result = ent.PayOrderEdit(conditions2);

                        if (getmodel != null)
                        {
                            getmodel.PayState = "3";
                            getmodel.OrderID = getmodel.OrderID;
                            NotiSerController.NotiChongZhi(getmodel);
                        }

                        Response.Write("SUCCESS");


                       
                    }
                     
                }
                else
                {
                    //签名无效
                    Response.Write("签名无效");
                }
            }
            catch { }
        }
    }
}