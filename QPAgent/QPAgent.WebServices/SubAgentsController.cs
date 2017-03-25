using Game.Entity.Accounts;
using Game.Entity.PlatformManager;
using Game.Kernel;
using Game.Utils;
using QPAgent.WebServices.Helpers;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web;

namespace QPAgent.WebServices
{
    public class SubAgentsController : ControllerBase
    {
        const string View = "vw_SubAgentList";

        protected string GetCondition(HttpRequest req)
        {
            bool IsAgent = Convert.ToBoolean(req["IsAgent"]);
            string keyword = req["keyword"];
            int status = Convert.ToInt32(req["status"] ?? "-1");
            string strWhere = " WHERE UserName LIKE '%" + keyword + "%'";
            if (IsAgent)
            {
                strWhere += " AND AgentID=" + userExt.AgentID;
            }
            if (status != -1)
            {
                strWhere += " AND Nullity=" + status;
            }
            return strWhere;
        }
        protected Dictionary<string, object> GetConditionEx(HttpRequest req)
        {
            Dictionary<string, object> parms = new Dictionary<string, object>();
            bool IsAgent = Convert.ToBoolean(req["IsAgent"]);
            string keyword = req["keyword"];
            int status = Convert.ToInt32(req["status"] ?? "-1");
            parms.Add("UserName", keyword);
            if (IsAgent)
            {
                parms.Add("AgentID", userExt.AgentID);
            }
            if (status != -1)
            {
                parms.Add("Nullity", status);
            }
            return parms;
        }

        public override string Index(HttpRequest req)
        {
            try
            {
                string subType = req["subType"];
                string json = "";
                switch (subType)
                {
                    case "byId":
                        int UserID = Convert.ToInt32(req["UserID"]);
                        DataTable dtA = aidePlatformManagerFacade.GetAgent(UserID);
                        json = GetJsonByDataTable(dtA);
                        json = JsonResultHelper.GetSuccessJsonByArray(json);
                        break;
                    default:
                        int pageIndex = Convert.ToInt32(req["pageIndex"] ?? "1");
                        int pageSize = Convert.ToInt32(req["pageSize"] ?? "20");
                        PagerSet pageSet = aidePlatformManagerFacade.GetSubAgentListEx(pageIndex, pageSize, GetConditionEx(req));
                        DataTable dtAgents = pageSet.PageSet.Tables[1];
                        json = GetResponse(GetModuleName((int)ModuleType.SubAgents), View, dtAgents, pageSize, pageSet.RecordCount);
                        break;
                }

                return json;
            }
            catch (Exception ex)
            {
                return JsonResultHelper.GetErrorJsonByArray(ex.Message);
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
                Base_Users user = new Base_Users();
                account.Accounts = GameRequest.GetFormString("UserName");
                account.NickName = GameRequest.GetFormString("Nick");
                account.LogonPass = Utility.MD5(GameRequest.GetFormString("Password"));
                account.InsurePass = account.LogonPass;
                account.UnderWrite = string.Empty;
                account.Present = 0;
                account.LoveLiness = 0;
                account.Experience = 0;
                account.Gender = Convert.ToByte(req.Form["Sex"]);
                account.FaceID = 0;
                account.Nullity = 0;
                account.StunDown = 0;
                account.MoorMachine = 0;

                account.IsAndroid = 0;
                account.UserRight = 0;
                account.MasterRight = 0;
                account.MasterOrder = 0;
                account.Compellation = GameRequest.GetFormString("compellation");
                account.MemberOrder = 0;
                account.MemberOverDate = Convert.ToDateTime("1970-01-01");
                account.MemberSwitchDate = Convert.ToDateTime("1970-01-01");
                account.RegisterIP = GameRequest.GetUserIP();

                string sIsAgent = req["IsAgent"];
                bool IsAgent = Convert.ToBoolean(string.IsNullOrEmpty(sIsAgent) ? "false" : sIsAgent);
                if (!IsAgent)
                {
                    account.AgentID = 0;
                }
                else
                {
                    account.AgentID = userExt.AgentID;
                    account.SpreaderID = userExt.AgentID;
                }
                datum.QQ = GameRequest.GetFormString("qq");
                datum.EMail = GameRequest.GetFormString("email");
                datum.SeatPhone = GameRequest.GetFormString("seatphone");
                datum.MobilePhone = GameRequest.GetFormString("mobilephone");
                datum.PostalCode = GameRequest.GetFormString("postalcode");
                datum.DwellingPlace = GameRequest.GetFormString("txtaddr");
                datum.UserNote = GameRequest.GetFormString("txtnote");

                user.canHasSubAgent = Convert.ToByte(req["canHasSub"]);
                user.AgentLevelLimit = Convert.ToInt32(req["AgentLevelLimit"]);
                user.RoleID = Convert.ToInt32(req["RoleID"]);
                user.GradeID = Convert.ToInt32(req["GradeID"]);
                user.Percentage = Convert.ToInt32(req["Revenue"]);

                Message msg = new Message();

                msg = aideAccountsFacade.AddSilver(userExt.UserID, 0, account, datum, user);

                if (msg.Success)
                {
                    json = JsonResultHelper.GetSuccessJson("保存成功");
                    LogHelper2.SaveSuccessLog("新增代理[" + req.Form["UserName"] + "]", userExt.UserID, (int)LogOperationEnum.AddAgent, GameRequest.GetUserIP(), module);
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
                    LogHelper2.SaveErrLog("新增代理[" + req.Form["UserName"] + "]：", strMessage, userExt.UserID, (int)LogOperationEnum.AddAgent, GameRequest.GetUserIP(), module);
                }
            }
            catch (Exception ex)
            {
                json = JsonResultHelper.GetErrorJson(ex.Message);
                LogHelper2.SaveErrLog("新增代理[" + req.Form["UserName"] + "]：", ex.Message, userExt.UserID, (int)LogOperationEnum.AddAgent, GameRequest.GetUserIP(), module);
            }
            return json;
        }

        int GetSpreaderID()
        {
            int spreaderId = aidePlatformManagerFacade.GetSpreaderID();
            return spreaderId;
        }

        public override string Edit(HttpRequest req)
        {
            string module = GetModuleName(Convert.ToInt32(req["moduleType"] ?? "0"));
            try
            {
                string subType = req["subType"] ?? "";
                string json = "";
                switch (subType.ToLower())
                {
                    case "spreaderid":
                        json = UpdateSpreaderID(req);
                        break;
                    case "ch_pwd":
                        json = ResetUserPassword(req);
                        break;
                    case "ch_pwd2":
                        json = ChangeUserPassword(req);
                        break;
                    case "dj":
                        json = SetNullity(req, 1);
                        break;
                    case "jd":
                        json = SetNullity(req, 0);
                        break;
                    default:
                        json = Save(req);
                        break;
                }
                return json;
            }
            catch (Exception ex)
            {
                LogHelper2.SaveErrLog("修改[" + (req.Form["UserName"] ?? req["UserName"]) + "]", ex.Message, userExt.UserID, (int)LogOperationEnum.EditAgent, GameRequest.GetUserIP(), module);
                return JsonResultHelper.GetErrorJson(ex.Message);
            }
        }

        public string UpdateSpreaderID(HttpRequest req)
        {
            string module = GetModuleName(Convert.ToInt32(req["moduleType"] ?? "0"));
            try
            {
                int UserID = Convert.ToInt32(req["UserID"]);
                string oldCode = req["oldSpreaderID"];
                string newCode = req["SpreaderID"];
                int r = aidePlatformManagerFacade.UpdateSpreaderID(UserID, oldCode, newCode);
                if (r == -1)
                    return JsonResultHelper.GetErrorJson("邀请码不存在！");
                else if (r == -2)
                    return JsonResultHelper.GetErrorJson("邀请码已被占用！");
                LogHelper2.SaveSuccessLog("修改[" + req["UserName"] + "]", userExt.UserID, (int)LogOperationEnum.EditAgent, GameRequest.GetUserIP(), module);
                return JsonResultHelper.GetSuccessJson("保存成功");
            }
            catch (Exception ex)
            {
                LogHelper2.SaveErrLog("修改[" + req["UserName"] + "]邀请码", ex.Message, userExt.UserID, (int)LogOperationEnum.EditAgent, GameRequest.GetUserIP(), module);
                return JsonResultHelper.GetErrorJson(ex.Message);
            }
        }

        public string ChangeUserPassword(HttpRequest req)
        {
            string module = GetModuleName(Convert.ToInt32(req["moduleType"] ?? "0"));
            try
            {
                int UserID = Convert.ToInt32(req.Form["UserID"]);
                string oldpwd = req.Form["oldPwd"];
                string newpwd = req.Form["newPwd"];
                int i = aidePlatformManagerFacade.ModifyUserPassword(UserID, Utility.MD5(oldpwd), Utility.MD5(newpwd));
                if (i == -1)
                {
                    return JsonResultHelper.GetErrorJson("原密码输入错误");
                }
                return JsonResultHelper.GetSuccessJson("修改成功！");
            }
            catch (Exception ex)
            {
                LogHelper2.SaveErrLog("修改[" + req["UserName"] + "]密码", ex.Message, userExt.UserID, (int)LogOperationEnum.EditAgent, GameRequest.GetUserIP(), module);
                return JsonResultHelper.GetErrorJson(ex.Message);
            }
        }
        public string ResetUserPassword(HttpRequest req)
        {
            string module = GetModuleName(Convert.ToInt32(req["moduleType"] ?? "0"));
            string UserName = req["UserName"];
            try
            {
                int UserID = Convert.ToInt32(req["UserID"]);
                aidePlatformManagerFacade.ResetUserPassword(UserID, Utility.MD5("123456"));
                LogHelper2.SaveSuccessLog("重置[" + UserName + "]密码", userExt.UserID, (int)LogOperationEnum.EditAgent, GameRequest.GetUserIP(), module);
                return JsonResultHelper.GetSuccessJson("修改成功！");
            }
            catch (Exception ex)
            {
                LogHelper2.SaveErrLog("重置[" + UserName + "]密码", ex.Message, userExt.UserID, (int)LogOperationEnum.EditAgent, GameRequest.GetUserIP(), module);
                return JsonResultHelper.GetErrorJson(ex.Message);
            }
        }

        public string Save(HttpRequest req)
        {
            string module = GetModuleName(Convert.ToInt32(req["moduleType"] ?? "0"));
            try
            {
                Base_Users user = new Base_Users();
                user.UserID = Convert.ToInt32(req["AdminID"] ?? "0");
                user.Username = GameRequest.GetFormString("UserName");
                user.canHasSubAgent = Convert.ToByte(req.Form["canHasSub"]);
                user.AgentLevelLimit = Convert.ToInt32(req.Form["AgentLevelLimit"]);
                user.RoleID = Convert.ToInt32(req.Form["RoleID"]);
                user.GradeID = Convert.ToInt32(req.Form["GradeID"]);
                user.Nullity = byte.Parse(GameRequest.GetFormString("AgentStatus"));
                user.Percentage = GameRequest.GetFormInt("Revenue", 0);

                Message msg = aidePlatformManagerFacade.ModifyUserInfo(user);
                if (msg.Success)
                {
                    LogHelper2.SaveSuccessLog("修改[" + req.Form["UserName"] + "]", userExt.UserID, (int)LogOperationEnum.EditAgent, GameRequest.GetUserIP(), module);
                    return JsonResultHelper.GetSuccessJson("保存成功");
                }
                else
                {
                    LogHelper2.SaveErrLog("修改[" + req.Form["UserName"] + "]", msg.Content, userExt.UserID, (int)LogOperationEnum.EditAgent, GameRequest.GetUserIP(), module);
                    return JsonResultHelper.GetErrorJson(msg.Content);
                }
            }
            catch (Exception ex)
            {
                LogHelper2.SaveErrLog("修改[" + req.Form["UserName"] + "]", ex.Message, userExt.UserID, (int)LogOperationEnum.EditAgent, GameRequest.GetUserIP(), module);
                return JsonResultHelper.GetErrorJson(ex.Message);
            }
        }

        private string SetNullity(HttpRequest req, int nullity)
        {
            string module = GetModuleName(Convert.ToInt32(req["moduleType"] ?? "0"));
            string ids = req["ids"];
            try
            {
                Dictionary<string, object> kvs = new Dictionary<string, object>();
                kvs.Add(Base_Users._Nullity, nullity);
                aidePlatformManagerFacade.UpdateUserBy("AND UserID IN (" + ids + ")", kvs);
                LogHelper2.SaveSuccessLog((nullity == 1 ? "冻结[" : "解冻") + ids + "]", userExt.UserID, (int)LogOperationEnum.EditAgent, GameRequest.GetUserIP(), module);
                return JsonResultHelper.GetSuccessJson("修改成功");
            }
            catch (Exception ex)
            {
                LogHelper2.SaveErrLog((nullity == 1 ? "冻结[" : "解冻") + ids + "]", ex.Message, userExt.UserID, (int)LogOperationEnum.EditAgent, GameRequest.GetUserIP(), module);
                return JsonResultHelper.GetErrorJson(ex.Message);
            }
        }

        public override string Delete(HttpRequest req)
        {
            string json = "";
            return json;
        }
    }
}
