using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using QPFront.Helpers;
using System.Security.Cryptography;

namespace QPFront.Controller
{
    class MallController : ControllerBase, IController
    {
        const string skey = "qysopen8899";
        public string Sign(HttpRequest req)
        {
            string rtype = req["rtype"];
            string payMoney = req["paymoney"];
            string goodName = req["goodsname"];
            string account = req["account"];
            string orderID = req["OrderID"];
            string str = "skey=" + skey + "&rtype=" + rtype
                + "&paymoney=" + payMoney + "&goodsname=" + goodName
                + "&account=" + account + "&OrderID=" + orderID;
            string sign = JsonResultHelper.GetSuccessJson(MD5(str, "gb2312"));
            return sign;
        }

        string MD5(string strToEncrypt, string encodeing)
        {
            byte[] bytes = Encoding.GetEncoding(encodeing).GetBytes(strToEncrypt); //.Default.GetBytes(strToEncrypt);

            bytes = new MD5CryptoServiceProvider().ComputeHash(bytes);
            string encryptStr = "";
            for (int i = 0; i < bytes.Length; i++)
            {
                encryptStr = encryptStr + bytes[i].ToString("x").PadLeft(2, '0');
            }
            return encryptStr;
        }

        public string Add(HttpRequest req)
        {
            throw new NotImplementedException();
        }

        public string Delete(HttpRequest req)
        {
            throw new NotImplementedException();
        }

        public string Index(HttpRequest req)
        {
            throw new NotImplementedException();
        }

        public string Update(HttpRequest req)
        {
            throw new NotImplementedException();
        }
    }
}
