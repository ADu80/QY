using Game.Entity.Accounts;
using Game.Entity.NativeWeb;
using Game.Entity.Treasure;
using Game.Facade;
using Game.Kernel;
using Game.Utils;
using QPFront.Helpers;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web;

namespace QPFront.Controller
{
    public class PayOrderController : ControllerBase, IController
    {
        public string Index(HttpRequest req)
        {

            return "";
        }
        public string Add(HttpRequest req)
        {
            return "";

        }

        public string Delete(HttpRequest req)
        {
            return "";
        }

        public string Update(HttpRequest req)
        {
            return "";
        }

        public string PayOrderNO
        {
            get { return DateTime.Now.ToString("yyyyMMddHHmmssff") + new Random().Next(100).ToString(); }
        }

        public int PayOrderAdd()
        {


            Dictionary<string, object> conditions2 = new Dictionary<string, object>();

            conditions2.Add("OrderID", PayOrderNO);
            conditions2.Add("ChannelOrderID", "");
            conditions2.Add("UserID", "16442");
            conditions2.Add("GoodsType", "0");
            conditions2.Add("PayType", "5");
            conditions2.Add("PayAmount", "10");
            conditions2.Add("BackCount", "0");
            conditions2.Add("PayState", "1");

            int r = aideTreasureFacade.PayOrderAdd(conditions2);
            return r;
        }

        public int PayOrderAdd(Dictionary<string, object> conditions)
        {
            conditions.Add("OperatingIP", GameRequest.GetUserIP()); 
            int r = aideTreasureFacade.PayOrderAdd(conditions);
            return r;
        }

        public int PayOrderEdit(Dictionary<string, object> conditions)
        {

            int r = aideTreasureFacade.PayOrderEdit(conditions);
            return r;
        }

        public int PayOrderGet(Dictionary<string, object> conditions)
        {
            int r = aideTreasureFacade.PayOrderGet(conditions);
            return r;
        }


        public string getStatus(HttpRequest req)
        {
            Dictionary<string, object> conditions = new Dictionary<string, object>();
            var orderno = req["orderno"] ?? "00000";
            conditions.Add("OrderID", orderno);
            int r = aideTreasureFacade.PayOrderGet(conditions);
            string json = r.ToString();

            //var kksdfk = PayOrderArr(orderno);
            return JsonResultHelper.GetSuccessJsonByArray(json);
        }

        public PayOrder PayOrderArr(string orderno)
        {
            Dictionary<string, object> conditions = new Dictionary<string, object>();
            conditions.Add("OrderID", orderno);
            var r = aideTreasureFacade.PayOrderArr(conditions);
            return r;
        }
        public PayOrder PayOrderArrByChannel(string Channelorderno)
        {
            Dictionary<string, object> conditions = new Dictionary<string, object>();
            conditions.Add("ChannelOrderID", Channelorderno);
            var r = aideTreasureFacade.PayOrderArrByChannel(conditions);
            return r;
        }


        public string OrderNo(HttpRequest req)
        {
            var Account = req["Account"] ?? "00000";
            if (Account == "00000")
            {
                return "{\"status\":\"false\",\"message\":\"\"}";
            }

            PayOrderController ent = new PayOrderController();

            int getuserid = ent.ifExist(int.Parse(Account));
            if (getuserid == 0) { return "{\"status\":\"false\",\"message\":\"\"}"; }

            string json = PayOrderNO.ToString();
            return "{\"status\":\"success\",\"message\":\"" + json + "\"}";

        }

        public int UserID(string account)
        {
            try
            {
                AccountsFacade aideUserFacade = new AccountsFacade();
                UserInfo m = aideUserFacade.GetAccountInfoByAccount(account);
                return m.UserID;
            }
            catch { return 0; }
        }

        public int ifExist(int GameID)
        {
            try
            {
                var sqlstr = "select * from [QPAccountsDB].[dbo].[AccountsInfo] where GameID =" + GameID + "";
                AccountsFacade aideUserFacade = new AccountsFacade();
                DataSet ds = aideUserFacade.GetAccountInfoByGameID(sqlstr);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    return int.Parse(ds.Tables[0].Rows[0]["UserID"].ToString());
                }
                else
                {
                    return 0;
                }
            }
            catch { return 0; }
        }
    }
}
