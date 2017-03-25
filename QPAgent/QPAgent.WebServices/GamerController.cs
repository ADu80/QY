using Game.Entity.Accounts;
using Game.Kernel;
using Game.Utils;
using QPAgent.WebServices.Helpers;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;

namespace QPAgent.WebServices
{
    public class GamerController : ControllerBase
    {
        const string View = "vw_Gamer";

        protected string GetCondition(HttpRequest req)
        {
            string UserID = req["UserID"];
            string strWhere = "WHERE SpreaderID='" + UserID + "'";
            return strWhere;
        }

        public override string Index(HttpRequest req)
        {
            try
            {
                bool IsAgent = Convert.ToBoolean(req["IsAgent"]);
                if (!IsAgent)
                {
                    return JsonResultHelper.GetErrorJson("不是代理");
                }

                int pageIndex = Convert.ToInt32(req["pageIndex"] ?? "1");
                int pageSize = Convert.ToInt32(req["pageSize"] ?? "20");
                PagerSet pageSet = aideAccountsFacade.GetAccountsList(pageIndex, pageSize, GetCondition(req), "");
                DataTable dtUsers = pageSet.PageSet.Tables[0];

                string json = GetResponse(GetModuleName((int)ModuleType.AgentInfo), View, dtUsers, pageSize, pageSet.RecordCount);
                return json;
            }
            catch (Exception ex)
            {
                return JsonResultHelper.GetErrorJson(ex.Message);
            }
        }

        public override string New(HttpRequest req)
        {
            string json = "";
            string module = GetModuleName(Convert.ToInt32(req["moduleType"] ?? "0"));
            try
            {
                AccountsInfo account = new AccountsInfo();
                IndividualDatum datum = new IndividualDatum();

                account.Accounts = GameRequest.GetFormString("UserName");
                account.NickName = GameRequest.GetFormString("NickName");
                account.LogonPass = Utility.MD5(GameRequest.GetFormString("Password"));
                account.InsurePass = Utility.MD5(GameRequest.GetFormString("cfPassword"));
                account.UnderWrite = TextFilter.FilterAll(GameRequest.GetFormString("underwrite"));
                account.Present = 0;
                account.LoveLiness = GameRequest.GetFormInt("txtlove", 0);
                account.Experience = GameRequest.GetFormInt("txtexpr", 0);
                account.Gender = Convert.ToByte(req.Form["rdosex"]);
                account.FaceID = (short)GameRequest.GetFormInt("org.faceId", 0);
                account.Nullity = Convert.ToByte(req.Form["ckbNullity"]);
                account.StunDown = Convert.ToByte(req.Form["ckbStunDown"]);
                account.MoorMachine = Convert.ToByte(req.Form["rdorobort"]);
                account.SpreaderID = userExt.AgentID;
                account.AgentID = userExt.AgentID;
                account.IsAndroid = Convert.ToByte(req.Form["chkIsAndroid"]);

                account.MasterOrder = Convert.ToByte(req.Form["rdoMasterOrder"]);

                account.Compellation = GameRequest.GetFormString("compellation");
                //account.MemberOrder = Convert.ToByte(GameRequest.GetFormString("sendType"));
                //account.MemberOverDate = string.IsNullOrEmpty(GameRequest.GetFormString("OverMemberDate")) ? Convert.ToDateTime("1980-01-01") : Convert.ToDateTime(GameRequest.GetFormString("OverMemberDate"));
                //account.MemberSwitchDate = string.IsNullOrEmpty(GameRequest.GetFormString("OverMemberDate")) ? Convert.ToDateTime("1980-01-01") : Convert.ToDateTime(GameRequest.GetFormString("OverMemberDate"));
                account.RegisterIP = GameRequest.GetUserIP();

                datum.QQ = GameRequest.GetFormString("qq");
                datum.EMail = GameRequest.GetFormString("email");
                datum.SeatPhone = GameRequest.GetFormString("seatphone");
                datum.MobilePhone = GameRequest.GetFormString("mobilephone");
                datum.PostalCode = GameRequest.GetFormString("postalcode");
                datum.DwellingPlace = GameRequest.GetFormString("txtaddr");
                datum.UserNote = GameRequest.GetFormString("txtnote");

                Message msg = aideAccountsFacade.AddAccount(account, datum);
                if (msg.Success)
                {
                    json = JsonResultHelper.GetSuccessJson("保存成功");
                    LogHelper2.SaveSuccessLog("新增玩家[" + req.Form["UserName"] + "]", userExt.UserID, (int)LogOperationEnum.AddGamer, GameRequest.GetUserIP(), module);
                }
                else
                {
                    string strMessage = "";
                    int intMsgID = msg.MessageID;
                    switch (intMsgID)
                    {
                        case -5:
                            strMessage = "帐号已存在，请重新输入！";
                            break;
                        case -4:
                            strMessage = "昵称已存在，请重新输入！";
                            break;
                        case -3:
                            strMessage = "帐号已存在，请重新输入！";
                            break;
                        case -2:
                            strMessage = "参数有误！";
                            break;
                        case -1:
                            strMessage = "抱歉，未知服务器错误！";
                            break;
                        case 1:
                            strMessage = "用户添加成功，但未成功获取游戏 ID 号码！";
                            break;
                        default:
                            strMessage = "抱歉，未知服务器错误！";
                            break;
                    }
                    json = JsonResultHelper.GetErrorJson(strMessage);
                    LogHelper2.SaveSuccessLog("新增玩家[" + req.Form["UserName"] + "]" + strMessage, userExt.UserID, (int)LogOperationEnum.AddGamer, GameRequest.GetUserIP(), module);
                }
            }
            catch (Exception ex)
            {
                json = JsonResultHelper.GetErrorJson(ex.Message);
                LogHelper2.SaveErrLog("新增玩家[" + req.Form["UserName"] + "]", ex.Message, userExt.UserID, (int)LogOperationEnum.AddGamer, GameRequest.GetUserIP(), module);
            }
            return json;
        }

        public override string Edit(HttpRequest req)
        {
            return base.Edit(req);
        }

        public override string Delete(HttpRequest req)
        {
            return base.Delete(req);
        }
    }
}
