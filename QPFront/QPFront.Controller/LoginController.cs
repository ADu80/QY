using Game.Entity.Accounts;
using Game.Kernel;
using Game.Utils;
using QPFront.Controller.Helpers;
using QPFront.Helpers;
using System;
using System.Data;
using System.Web;

namespace QPFront.Controller
{
    public class LoginController : ControllerBase, IController
    {
        public string AccountLogon(HttpRequest req)
        {
            string account = req["account"];
            string pwd = Utility.MD5(req["pwd"]);
            Message msg = aideAccountFacade.Logon(account, pwd);
            if (msg.Success)
            {
                SessionHelper.SetSession("account", account);
                UserInfo userInfo = aideAccountFacade.GetAccountInfoByAccount(account);
                string json = GetJsonByObjectList(userInfo);
                return JsonResultHelper.GetSuccessJsonByArray(json);
            }
            else
            {
                return JsonResultHelper.GetErrorJson(JsonReplace(msg.Content));
            }
        }
        public string AccountLogonByMobile(HttpRequest req)
        {
            UserInfo user = new UserInfo();
            string mobile = req["account"];
            user.RegisterMobile = mobile;
            user.LogonPass = Utility.MD5(req["pwd"]);
            Message msg = aideAccountFacade.LogonByMobile(user, true);
            if (msg.Success)
            {
                string account = aideAccountFacade.GetAccountsByMobile(mobile);
                SessionHelper.SetSession("account", account);
                UserInfo userInfo = aideAccountFacade.GetAccountInfoByAccount(account);
                string json = GetJsonByObjectList(userInfo);
                return JsonResultHelper.GetSuccessJsonByArray(json);
            }
            else
            {
                return JsonResultHelper.GetErrorJson(JsonReplace(msg.Content));
            }
        }

        public string AccountRegister(HttpRequest req)
        {
            UserInfo userInfo = new UserInfo();
            userInfo.Accounts = req.Form["account"];
            userInfo.LogonPass = req.Form["pwd"];
            string pAccount = req.Form["pAccount"];
            Message msg = aideAccountFacade.Register(userInfo, pAccount);
            if (msg.Success)
            {
                string json = GetJsonByObjectList(userInfo);
                return JsonResultHelper.GetSuccessJsonByArray(json);
            }
            else
            {
                return JsonResultHelper.GetErrorJson(msg.Content);
            }
        }

        public string AccountInfo(HttpRequest req)
        {
            var account = req["account"];

            DataTable dt = aideAccountFacade.GetAccountScoreInfoByAccount(account);
            string json = GetJsonByDataTable(dt);
            return JsonResultHelper.GetSuccessJsonByArray(json);
        }

        public string AccountInfo2(HttpRequest req)
        {
            int gameid = Convert.ToInt32(req["gameid"] ?? "0");

            DataTable dt = aideAccountFacade.GetAccountScoreInfoByGameID(gameid);
            string json = GetJsonByDataTable(dt);
            return JsonResultHelper.GetSuccessJsonByArray(json);
        }

        public string ValidateImage(HttpRequest req)
        {
            var yzm = new YZMHelper();
            string code = yzm.CreateRandomCode(4);
            SessionHelper.SetSession("ValidateCode", code);
            string imgstr = yzm.GetValidateGraphicBase64String(code);
            return imgstr;
        }

        public string CheckValidaeImage(HttpRequest req)
        {
            var code = req["valicode"];
            var currCode = SessionHelper.GetSession("ValidateCode");
            if (currCode.ToLower() != code.ToLower())
            {
                return JsonResultHelper.GetErrorJson("验证码输入不正确！");
            }
            return JsonResultHelper.GetSuccessJson("验证码输入正确");
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
