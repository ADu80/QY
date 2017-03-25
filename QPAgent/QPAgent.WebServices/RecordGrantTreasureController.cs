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
    public class RecordGrantTreasureController : ControllerBase
    {
        const string View = "vw_RecordGrantTreasure";

        protected string GetCondition(HttpRequest req)
        {
            string keyword = req["keyword"];
            StringBuilder sb = new StringBuilder();
            if (!string.IsNullOrEmpty(keyword))
            {
                sb.AppendFormat(" WHERE (UserName LIKE '{0}%')", keyword);
            }
            return sb.ToString();
        }

        public override string Index(HttpRequest req)
        {
            int pageIndex = Convert.ToInt32(req["pageIndex"] ?? "1");
            int pageSize = Convert.ToInt32(req["pageSize"] ?? "20");
            PagerSet pageSet = aidePlatformManagerFacade.GetUserList(pageIndex, pageSize, GetCondition(req), "ORDER BY UserID DESC");
            DataTable dtUsers = pageSet.PageSet.Tables[0];

            string json = GetResponse(GetModuleName((int)ModuleType.AgentInfo), "vw_Log", dtUsers, pageSize, pageSet.RecordCount);
            return json;
        }

        public override string New(HttpRequest req)
        {
            string module = GetModuleName(Convert.ToInt32(req["moduleType"] ?? "0"));
            try
            {
                string ids = req.Form["ids"];
                int GiftGold = Convert.ToInt32(req.Form["GiftGold"] ?? "0");
                string Reason = req.Form["Reason"];
                string LoginIP = GameRequest.GetUserIP();
                bool IsAgent = Convert.ToBoolean(req["IsAgent"] ?? "false");
                Message msg = null;
                if (IsAgent)
                {
                    msg = aideTreasureFacade.GrantTreasure_Agent(userExt.AgentID, ids, ids.Split(',').Length, GiftGold, userExt.AgentID, Reason, LoginIP);
                }
                else
                {
                    msg = aideTreasureFacade.GrantTreasure(ids, GiftGold, userExt.UserID, Reason, LoginIP);
                }

                string json = "";
                if (msg.Success)
                {
                    json = JsonResultHelper.GetSuccessJson("操作成功");
                    LogHelper2.SaveSuccessLog("赠送[" + ids + "]金币", userExt.UserID, (int)LogOperationEnum.EditAgent, GameRequest.GetUserIP(), module);
                }
                else
                {
                    if (msg.MessageID == -4)
                        msg.Content = "操作失败，可用金币不足！";
                    json = JsonResultHelper.GetErrorJson(msg.Content);
                    LogHelper2.SaveErrLog("赠送[" + ids + "]金币", msg.Content, userExt.UserID, (int)LogOperationEnum.AddGamer, GameRequest.GetUserIP(), module);
                }
                return json;
            }
            catch (Exception ex)
            {
                LogHelper2.SaveSuccessLog(ex.Message, userExt.UserID, (int)LogOperationEnum.EditAgent, GameRequest.GetUserIP(), module);
                return JsonResultHelper.GetErrorJson(ex.Message);
            }
        }

        public override string Edit(HttpRequest req)
        {
            string json = "";
            return json;
        }

        public override string Delete(HttpRequest req)
        {
            string json = "";
            return json;
        }

    }
}
