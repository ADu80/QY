using Game.Entity.Accounts;
using Game.Kernel;
using QPFront.Helpers;
using System;
using System.Data;
using System.Web;

namespace QPFront.Controller
{
    public class AccountsController : ControllerBase, IController
    {
        public string Index(HttpRequest req)
        {
            try
            {
                UserInfo info = new UserInfo();
                object oAccounts = req["accounts"];
                object oPassword = req["password"];
                //string Accounts = "hu1111";
                //string Password = "0";
                if (oAccounts != null && oAccounts.ToString().Trim() != "")
                {
                    info.Accounts = oAccounts.ToString();
                    info.LogonPass = oPassword.ToString();
                }
                    //Accounts = oAccounts.ToString();
                
                Message msg = aideAccountFacade.Logon(info, false);
                if (msg.Success)
                {
                    return JsonResultHelper.GetSuccessJson("登录成功！");
                }
                return JsonResultHelper.GetErrorJson("登录失败");
            }
            catch (Exception ex)
            {
                return JsonResultHelper.GetErrorJson(ex.Message);
            }
        }

        //public string Index(HttpRequest req)
        //      {
        //          try
        //          {
        //              object oUserID = req.Form["userid"];
        //              object username = req.Form["username"];
        //              int UserID = 0;
        //              if (oUserID != null && oUserID.ToString().Trim() != "")
        //                  UserID = Convert.ToInt32(oUserID);

        //              DataTable dt = aideAccountFacade.GetAccountList();
        //              string json = GetJsonByDataTable(dt);

        //              return JsonResultHelper.GetSuccessJsonByArray(json);
        //          }
        //          catch (Exception ex)
        //          {
        //              return JsonResultHelper.GetErrorJson(ex.Message);;
        //          }
        //      }


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
    }
}