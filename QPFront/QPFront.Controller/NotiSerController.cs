using Game.Entity.Accounts;
using Game.Entity.Treasure;
using Game.Facade;
using Game.Kernel;
using QPFront.Helpers;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;

namespace Game.Web.Controllers
{
    public class NotiSerController
    {


        private static string myApiUrl
        {
            get
            {
                return System.Web.Configuration.WebConfigurationManager.AppSettings["APIURL"];
            }
        }

        public static string OnGamePost(string type, Dictionary<string, string> dic2)
        {
            string r = GloBalSign(type, dic2);
            if (r == "无法连接到远程服务器" || r.Contains("基础连接已经关闭") || r.Contains("操作超时"))
            {
                return "-1";
            }
            else
            {
                return GetResultNew(type, r);
            }
        }

        private static string GetResultNew(string type, string r)
        {

            int wcode = Convert.ToInt32(JsonHelper.GetSingleItemValue(r, "wCode") ?? "1");
            return wcode.ToString();
        }


        public static string GloBalSign(string type, Dictionary<string, string> dic2)
        {
            Dictionary<string, string> dic = new Dictionary<string, string>();
            dic.Add("type", type);
            string url = myApiUrl;
            dic.Add("message", "##count##");
            dic = dic.Union(dic2).ToDictionary(key => key.Key, value => value.Value);
            int count = GetMessageParams(dic).Count();
            dic["message"] = count.ToString();
            string sign = GetSign(dic);
            dic.Add("sign", sign);
            string json = GetJson(type, dic);
            string r = todoHttpResquest(url, json);
            return r;
        }

        /// <summary>
        /// 通知服务器
        /// </summary>
        /// <param name="UserID"></param>
        /// <returns></returns>
        public static string NotiChongZhi(PayOrder model)
        {
            try
            {

                Dictionary<string, string> dic = new Dictionary<string, string>();
                string type = "30";
                dic.Add("dwUserID", model.UserID);
                dic.Add("OrderNo", model.OrderID);
                dic.Add("PayState", model.PayState);
                dic.Add("PayType", model.PayType);
                dic.Add("BuyCount", model.BuyCount);
                dic.Add("BackCount", model.BackCount);
                dic.Add("BackType", model.Present);
                var r = NotiSerController.OnGamePost(type, dic);
                return r;
            }
            catch
            {
                return "";
            }

        }

        private static string GetResult(string type, string r)
        {
            //string json = r.Replace("\"wCode\": 0", "\"status\":\"success\"").Replace("\"wCode\": 1", "\"status\":\"error\"");
            //return json;
            int wcode = Convert.ToInt32(JsonHelper.GetSingleItemValue(r, "wCode") ?? "1");
            string message = (JsonHelper.GetSingleItemValue(r, "message") ?? "").ToString();
            if (wcode == 1)
            {
                return "{\"status\":\"error\",\"message\":\"失败\"}";
            }
            return "{\"status\":\"success\",\"message\":\"" + (message ?? "成功") + "\"}";
        }

        static IEnumerable<KeyValuePair<string, string>> GetMessageParams(Dictionary<string, string> dic)
        {
            var items = dic.Where(kv => { return kv.Key != "type" && kv.Key != "message" && kv.Key != "sign"; });
            return items;
        }

        static string GetJson(string type, Dictionary<string, string> dic)
        {
            string json = "{\"type\":" + dic["type"] + ",\"message\":{##message##},\"sign\":\"" + dic["sign"] + "\"}";
            string msg = "";
            var items = GetMessageParams(dic);
            foreach (var item in items)
            {
                if (item.Key == "OrderNo")
                {
                    msg += ",\"" + item.Key + "\":\"" + item.Value + "\"";
                }
                else
                {
                    msg += ",\"" + item.Key + "\":" + item.Value;
                }
            }
            msg = msg.Trim().Trim(',');
            json = json.Replace("##message##", msg);
            return json;
        }

        static string GetSign(Dictionary<string, string> dic)
        {
            string str = "";
            foreach (var item in dic)
            {
                str += item.Key + "=" + item.Value + "&";
            }
            str = str.Trim().Trim('&');
            string sign = MD5Str(str, 32).ToUpper();
            return sign;
        }

        static string MD5Str(string str, int code)
        {
            if (code == 16) //16位MD5加密（取32位加密的9~25字符）   
            {
                return System.Web.Security.FormsAuthentication.HashPasswordForStoringInConfigFile(str, "MD5").ToLower().Substring(8, 16);
            }
            else//32位加密   
            {
                return System.Web.Security.FormsAuthentication.HashPasswordForStoringInConfigFile(str, "MD5").ToLower();
            }
        }

        static string GetJson(Stream inputStream)
        {
            using (StreamReader sr = new StreamReader(inputStream))
            {
                string getstr = sr.ReadToEnd();
                return getstr;
            }
        }

        static string todoHttpResquest(string url, string json)
        {
            string uri = url;
            try
            {
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
                return result;
            }
            catch (Exception e)
            {
                return e.Message;
            }
        }

    }
}