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

namespace pay.uka
{
    public partial class Receive : System.Web.UI.Page
    {
        private string userkey = ConfigurationManager.AppSettings["userkey"];

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                //返回参数
                String opstate = Request["opstate"];//返回处理结果
                String orderid = Request["orderid"];//返回商户订单号
                String ovalue = Request["ovalue"];//返回实际充值金额
                String sign = Request["sign"];//返回签名
                String sysorderid = Request["sysorderid"];//录入时产生流水号。
                String systime = Request["systime"];//处理时间。
                String attach = Request["attach"];//上行附加信息
                String msg = Request["msg"];//返回订单处理消息
                String param = String.Empty;

                //InsertLog(orderid, cardno, opstate, ovalue, attach, sign);

                param = String.Format("orderid={0}&opstate={1}&ovalue={2}{3}", orderid, opstate, ovalue, userkey);//组织参数

                //比对签名是否有效
                if (sign.Equals(md5.MD5(param).ToLower()))
                {

                    //执行操作方法
                    if (opstate.Equals("0"))
                    {
                        //Response.Write("opstate=0");
                        //操作流程成功的情况
                        //此处执行商户订单处理逻辑
                        PayOrderController ent = new PayOrderController();

                        Dictionary<string, object> conditions2 = new Dictionary<string, object>();

                        conditions2.Add("OrderID", orderid);
                        conditions2.Add("ErrorCode", "");
                        conditions2.Add("PayState", "2"); 
                        int result = ent.PayOrderEdit(conditions2);

                        PayOrder getmodel = ent.PayOrderArr(orderid);
                        if (getmodel != null)
                        {
                            getmodel.PayState = "2";
                            getmodel.OrderID = orderid;
                            NotiSerController.NotiChongZhi(getmodel);
                        }
                         
                        Response.Write("opstate=0&充值成功");
                    }
                    else if (opstate.Equals("1"))
                    {
                        PayOrderController ent = new PayOrderController();

                        Dictionary<string, object> conditions2 = new Dictionary<string, object>();

                        conditions2.Add("OrderID", orderid);
                        conditions2.Add("ErrorCode", "卡号密码错误");
                        conditions2.Add("PayState", "3");
                        int result = ent.PayOrderEdit(conditions2); 

                        //卡号密码错误
                        Response.Write("opstate=1&数据接收成功");
                    }
                    else if (opstate.Equals("2"))
                    {
                        PayOrderController ent = new PayOrderController();

                        Dictionary<string, object> conditions2 = new Dictionary<string, object>();

                        conditions2.Add("OrderID", orderid);
                        conditions2.Add("ErrorCode", "系统不支持该类卡进行支付");
                        conditions2.Add("PayState", "3");
                        int result = ent.PayOrderEdit(conditions2); 

                        //卡实际面值和提交时面值不符，卡内实际面值未使用
                        Response.Write("opstate=2&系统不支持该类卡进行支付");
                    }
                    else if (opstate.Equals("3"))
                    {
                        PayOrderController ent = new PayOrderController();

                        Dictionary<string, object> conditions2 = new Dictionary<string, object>();

                        conditions2.Add("OrderID", orderid);
                        conditions2.Add("ErrorCode", "签名验证串错误");
                        conditions2.Add("PayState", "3");
                        int result = ent.PayOrderEdit(conditions2); 


                        //卡在提交之前已经被使用
                        Response.Write("opstate=3&签名验证串错误");
                    }
                    else if (opstate.Equals("4"))
                    {
                        PayOrderController ent = new PayOrderController();

                        Dictionary<string, object> conditions2 = new Dictionary<string, object>();

                        conditions2.Add("OrderID", orderid);
                        conditions2.Add("ErrorCode", "订单内容重复");
                        conditions2.Add("PayState", "3");
                        int result = ent.PayOrderEdit(conditions2); 


                        //失败，原因请查看msg
                        Response.Write("opstate=4&订单内容重复");
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