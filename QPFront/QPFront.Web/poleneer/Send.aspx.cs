using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Net;
using System.Text;
using System.IO;
using System.Web.Script.Serialization;
using System.Drawing;
using ThoughtWorks.QRCode.Codec;
using QPFront.Controller;

namespace pay.poleneer
{
    public partial class Send : System.Web.UI.Page
    {
        private string shop_id = ConfigurationManager.AppSettings["poleneer_shop_id"];
        private string appkey = ConfigurationManager.AppSettings["poleneer_appkey"];
        private string gateway = ConfigurationManager.AppSettings["poleneer_gateway"];
        private string hrefBack = ConfigurationManager.AppSettings["poleneer_CallBackurl"];

        protected void Page_Load(object sender, EventArgs e)
        {
            SendToPay();
        }

        // {"order_no":"15217221119T149491888960664","success":true,"pay_url":"https://qr.alipay.com/bax094817g9ozxskh83y00ed"}


        public class PayReturnModel
        {
            public string order_no { get; set; }
            public bool success { get; set; }
            public string pay_url { get; set; }
        }

        private void SendToPay()
        {
            string orderid = Request.QueryString["orderid"].ToString();
            string getuserid = Request.QueryString["userid"].ToString();
            string GoodsType = Request.QueryString["GoodsType"].ToString(); 
            string hrefBackurl = hrefBack;  // 下行异步通知地址
            //银行提交获取信息
            string bank_Type = Request.QueryString["rtype"].ToString();//银行类型 
            string bank_payMoney = Request.QueryString["PayMoney"].ToString();//充值金额
            string goodsname = "会员充值";
            goodsname = HttpUtility.UrlEncode(goodsname, System.Text.Encoding.GetEncoding("utf-8"));
            var forgemd5 = shop_id + bank_payMoney + appkey;
            var md5str = md5.MD5(forgemd5);
            String param = String.Format("shop_id={0}&amount={1}&pay_source={2}&body={3}&notify_url={4}", shop_id, bank_payMoney, bank_Type, goodsname, hrefBackurl);
            String PostUrl = String.Format("{0}?{1}&sign={2}", gateway, param, md5str);

             

            var uri = PostUrl;
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
            PayReturnModel abc = jss.Deserialize<PayReturnModel>(result) as PayReturnModel;
            var order_no = abc.order_no;
            var issucc = abc.success;
            var pay_url = abc.pay_url;

            
            if (issucc == true)
            {
               
                Dictionary<string, object> conditions2 = new Dictionary<string, object>();


                conditions2.Add("OrderID", orderid);
                conditions2.Add("ChannelOrderID", order_no);

                PayOrderController ent = new PayOrderController();

                conditions2.Add("UserID", int.Parse(getuserid));
                conditions2.Add("GoodsType", int.Parse(GoodsType));
                conditions2.Add("PayType", 6);
                conditions2.Add("PayAmount", bank_payMoney);
                conditions2.Add("BuyCount", 0);
                conditions2.Add("BackCount", 0);
                conditions2.Add("PayState", 1);
                ent.PayOrderAdd(conditions2);
                if (bank_Type == "1")
                {
                    Response.Redirect(pay_url);
                }
                else
                {
                    Panel1.Visible = true;
                    var foredcode = pay_url;
                    var path = Server.MapPath("/qrcode_data");
                    Bitmap getimage = Create_ImgCode(path, foredcode, 10);

                    string imgname = DateTime.Now.ToString("yyyyMMddhhmmss") + ".jpg";
                    string savepath = "/CodeEncoder/" + imgname;
                    getimage.Save(Server.MapPath(savepath));
                    this.Image1.ImageUrl = savepath;
                }
            }else{
                Response.Write("返回数据错误" + result);
            }

        }

        /// <summary>  
        /// 生成二维码图片  
        /// </summary>  
        /// <param name="codeNumber">要生成二维码的字符串</param>       
        /// <param name="size">大小尺寸</param>  
        /// <returns>二维码图片</returns>  
        public Bitmap Create_ImgCode(string path, string codeNumber, int size)
        {
            //创建二维码生成类  
            QRCodeEncoder qrCodeEncoder = new QRCodeEncoder(path);
            //设置编码模式  
            qrCodeEncoder.QRCodeEncodeMode = QRCodeEncoder.ENCODE_MODE.BYTE;
            //设置编码测量度  
            qrCodeEncoder.QRCodeScale = size;
            //设置编码版本  
            qrCodeEncoder.QRCodeVersion = 7;
            //设置编码错误纠正  
            qrCodeEncoder.QRCodeErrorCorrect = QRCodeEncoder.ERROR_CORRECTION.M;
            //生成二维码图片  
            System.Drawing.Bitmap image = qrCodeEncoder.Encode(codeNumber);
            return image;
        }  

    }
}