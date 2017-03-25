using Game.Entity.PlatformManager;
using Game.Kernel;
using Game.Utils.Utils;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;

namespace QPAgent.WebServices
{
    public class MyInfoController : ControllerBase
    {

       
        public override string Index(HttpRequest req)
        {
            try
            {
                string subType = req["subType"];
                string json = "";
                switch (subType)
                {
                    case "gamerlist":
                        json = GetGamerListInfo(req);
                        break;
                    case "subagentlist":
                        json = GetSubAgentListInfo(req);
                        break;
                    case "tree":
                        json = GetAgentsTree(req);
                        break;
                    case "add_binddata":
                        json = GetAddBindData(req);
                        break;
                    case "spreaderidlist":
                        json = GetSpreaderIdList(req);
                        break;
                    case "recharge":
                        json = GetRecharge(req);
                        break;
                    case "gift":
                        json = GeGift(req);
                        break;
                    case "loginlog":
                        json = GetLoginLog(req);
                        break;
                    case "richchange":
                        json = GetRichChange(req);
                        break;
                    case "playgame":
                        json = GetPlayGame(req);
                        break;
                    case "gamewaste":
                        json = GetGameWaste(req);
                        break;
                    case "allsum":
                        json = GetAllSum(req);
                        break;
                    case "allsum_gamer":
                        json = GetAllSum_Gamer(req);
                        break;
                    case "reportbind":
                        json = GetReportBind(req);
                        break;
                    case "spreadsum":
                        json = GetSpreadSumByUserID(req);
                        break;
                    case "spreadplayer":
                        json = GetSpreadGamer(req);
                        break;
                    default:
                        json = GetStatInfo(req);
                        break;
                }
                return json;
            }
            catch (Exception ex)
            {
                return JsonResultHelper.GetErrorJson(ex.Message);
            }
        }

        private string GetSpreadGamer(HttpRequest req)
        {
            string json = "";
            try
            {
                int pageIndex = Convert.ToInt32(req["pageIndex"] ?? "1");
                int pageSize = Convert.ToInt32(req["pageSize"] ?? "20");
                int UserID = Convert.ToInt32(req["byUserID"] ?? "20");
                Dictionary<string, object> conditions = new Dictionary<string, object>();
                conditions.Add("UserID", UserID);
                conditions.Add("startDate", req["startDate"]);
                conditions.Add("endDate", req["endDate"]);
                PagerSet pageSet = aidePlatformManagerFacade.GetSpreaderChildren(pageIndex, pageSize, conditions);
                DataTable dtGamers = pageSet.PageSet.Tables[1];

                json = GetResponse(GetModuleName((int)ModuleType.AgentInfo), vw_GamerListInfo.Tablename, dtGamers, pageSize, pageSet.RecordCount);
            }
            catch (Exception ex)
            {
                json = JsonResultHelper.GetErrorJsonByArray(ex.Message);
            }
            return json;
        }

        private string GetAddBindData(HttpRequest req)
        {
            string json = "";
            int AgentLevel = Convert.ToInt32(req["AgentLevel"]);
            AgentLevel = AgentLevel == 0 ? -1 : AgentLevel + 1;
            DataTable dtAR = aidePlatformManagerFacade.GetAgentRoles(AgentLevel);
            DataTable dtAG = aidePlatformManagerFacade.GetAgentGrades();
            json = "{\"AgentRoles\":" + GetJsonByDataTable(dtAR) + ",\"AgentGrades\":" + GetJsonByDataTable(dtAG) + "}";
            json = JsonResultHelper.GetSuccessJsonByArray(json);
            return json;
        }

        private string GetSpreaderIdList(HttpRequest req)
        {
            DataTable dt = aidePlatformManagerFacade.GetSpreaderID(10);
            string json = GetJsonByDataTable(dt);
            json = JsonResultHelper.GetSuccessJsonByArray(json);
            return json;
        }

        protected Dictionary<string, object> GetCondition_GamerList(HttpRequest req)
        {
            Dictionary<string, object> whereAppend = new Dictionary<string, object>();

            whereAppend.Add("GameID", req["GameID"] ?? "-1");
            whereAppend.Add("Accounts", req["Accounts"]);
            whereAppend.Add("Range", req["Range"]);
            whereAppend.Add("startDate", req["startDate"]);
            whereAppend.Add("endDate", req["endDate"]);
            whereAppend.Add("userType", req["userType"]);
            whereAppend.Add("byUserID", req["byUserID"]);
            return whereAppend;
        }
        private string GetGamerListInfo(HttpRequest req)
        {
            string json = "";
            try
            {
                int pageIndex = Convert.ToInt32(req["pageIndex"] ?? "1");
                int pageSize = Convert.ToInt32(req["pageSize"] ?? "20");
                PagerSet pageSet = aidePlatformManagerFacade.GetGamerListInfo(pageIndex, pageSize, GetCondition_GamerList(req));
                DataTable dtGamers = pageSet.PageSet.Tables[1];

                json = GetResponse(GetModuleName((int)ModuleType.AgentInfo), vw_GamerListInfo.Tablename, dtGamers, pageSize, pageSet.RecordCount);
            }
            catch (Exception ex)
            {
                json = JsonResultHelper.GetErrorJsonByArray(ex.Message);
            }
            return json;
        }

        private string GetSubAgentListInfo(HttpRequest req)
        {
            string json = "";
            try
            {
                int pageIndex = Convert.ToInt32(req["pageIndex"] ?? "1");
                int pageSize = Convert.ToInt32(req["pageSize"] ?? "20");
                PagerSet pageSet = aidePlatformManagerFacade.GetSubAgentListInfo(pageIndex, pageSize, GetCondition_SubAgentList(req));
                DataTable dtSubagents = pageSet.PageSet.Tables[1];

                json = GetResponse(GetModuleName((int)ModuleType.AgentInfo), vw_SubAgentListInfo.Tablename, dtSubagents, pageSize, pageSet.RecordCount);
            }
            catch (Exception ex)
            {
                json = JsonResultHelper.GetErrorJsonByArray(ex.Message);
            }
            return json;
        }

        protected Dictionary<string, object> GetCondition_SubAgentList(HttpRequest req)
        {
            Dictionary<string, object> whereAppend = new Dictionary<string, object>();
            whereAppend.Add("SpreaderID", req["SpreaderID"]);
            whereAppend.Add("Accounts", req["Accounts"]);
            whereAppend.Add("Range", req["Range"]);
            whereAppend.Add("startDate", req["startDate"]);
            whereAppend.Add("endDate", req["endDate"]);
            whereAppend.Add("userType", req["userType"]);
            whereAppend.Add("byUserID", req["byUserID"]);
            return whereAppend;
        }

        private void FillSpreaderURL(DataTable dtStatInfo, string spreaderUrl)
        {
            foreach (DataRow dr in dtStatInfo.Rows)
            {
                string newSprUrl = spreaderUrl.Replace("#InviteCode#", dr["SpreaderID"].ToString().Trim());
                dr["SpreaderURL"] = newSprUrl;
            }
        }

        private string GetStatInfo(HttpRequest req)
        {
            DataTable dtStatInfo = null;
            string UserID = req["UserID"];
            if (string.IsNullOrEmpty(UserID))
            {
                dtStatInfo = aideTreasureFacade.GetStatInfo_Admin().Tables[0];
            }
            else
            {
                dtStatInfo = aideTreasureFacade.GetStatInfo_Agent(Convert.ToInt32(req["UserID"])).Tables[0];
                string spreaderUrl = ConfigHelper.GetAppSetting("SpreaderURL");
                FillSpreaderURL(dtStatInfo, spreaderUrl);
            }
            string json = GetJsonByDataTable(dtStatInfo);
            return JsonResultHelper.GetSuccessJsonByArray("{\"data\":{\"info\":" + json + "}}");
        }

        private string GetAgentsTree(HttpRequest req)
        {
            bool IsAgent = aidePlatformManagerFacade.IsAgent(userExt.UserID);
            DataTable dt = aidePlatformManagerFacade.GetAgentsTree(userExt.AgentID, IsAgent);
            string json = "";
            if (IsAgent)
            {
                int ParentAgentID = aidePlatformManagerFacade.GetParentAgentID(userExt.UserID);
                json = GetAgentsJson(dt, ParentAgentID, 0);
            }
            else
            {
                json = GetAgentsJson(dt, 0, 1);
                string roleName = aidePlatformManagerFacade.GetRolenameByRoleID(userExt.RoleID);
                json = "[{\"id\":\"" + userExt.UserID + "\",\"title\":\"" + userExt.Username + "\",\"RoleID\":" + userExt.RoleID + ",\"RoleName\":\"(" + roleName + ")\",\"parentId\":\"-1\",\"AdminID\":" + userExt.UserID + ",\"type\":\"admin\",\"open\":true,\"level\":0,\"ag\":0,\"subtree\":" + json + "}]";
            }
            return JsonResultHelper.GetSuccessJsonByArray("{\"tree\":" + json + "}");
        }

        private string GetAgentsJson(DataTable dt, int parentId, int level)
        {
            DataRow[] drs = dt.Select("ParentID=" + parentId);
            StringBuilder jsonAppend = new StringBuilder();
            foreach (DataRow dr in drs)
            {
                jsonAppend.Append("{");
                jsonAppend.Append("\"id\":\"" + dr["ID"] + "\",");
                jsonAppend.Append("\"title\":\"" + dr["UserName"].ToString() + "\",");
                jsonAppend.Append("\"RoleID\":" + dr["RoleID"] + ",");
                jsonAppend.Append("\"RoleName\":\"(" + dr["RoleName"] + ")\",");
                jsonAppend.Append("\"GradeDes\":\"(" + dr["GradeDes"] + ")\",");
                jsonAppend.Append("\"parentId\":\"" + dr["ParentID"] + "\",");
                jsonAppend.Append("\"AdminID\":" + dr["AdminID"] + ",");
                jsonAppend.Append("\"canHasSubAgent\":" + dr["canHasSubAgent"].ToString().ToLower() + ",");
                jsonAppend.Append("\"AgentLevelLimit\":" + dr["AgentLevelLimit"] + ",");
                jsonAppend.Append("\"type\":" + (Convert.ToBoolean(dr["IsAgent"]) ? "\"agent\"" : "\"gamer\"") + ",");
                jsonAppend.Append("\"open\":true,");
                jsonAppend.Append("\"active\":false,");
                jsonAppend.Append("\"level\":" + dr["AgentLevel"] + ",");
                jsonAppend.Append("\"ag\":" + level + ",");
                jsonAppend.Append("\"subtree\":" + GetAgentsJson(dt, Convert.ToInt32(dr["ID"]), level + 1));
                jsonAppend.Append("},");
            }
            string json = "[" + jsonAppend.ToString().Trim().Trim(',') + "]";
            return json;
        }

        private string GetAdmin()
        {
            return "{\"UserID\":\"" + userExt.UserID + "\",\"UserName\":\"" + userExt.Username + "\",\"Username\":\"" + userExt.Username + "\"}";
        }

        public override string New(HttpRequest req)
        {
            string json = "";
            return json;
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

        #region 统计
        private string GetReport(HttpRequest req, string view, Func<int, int, Dictionary<string, object>, PagerSet> find, Func<HttpRequest, Dictionary<string, object>> GetCondition)
        {
            try
            {
                int pageIndex = Convert.ToInt32(req["pageIndex"] ?? "1");
                int pageSize = Convert.ToInt32(req["pageSize"] ?? "20");
                PagerSet pageSet = find(pageIndex, pageSize, GetCondition(req));
                if (pageSet.PageSet.Tables.Count == 0)
                {
                    return JsonResultHelper.GetErrorJson("没有符合条件的数据");
                }
                DataTable dt = pageSet.PageSet.Tables[1];

                string json = GetResponse(GetModuleName((int)ModuleType.AgentInfo), view, dt, pageSize, pageSet.RecordCount);
                return json;
            }
            catch (Exception ex)
            {
                return JsonResultHelper.GetErrorJsonByArray(ex.Message);
            }
        }

        private string GetRecharge(HttpRequest req)
        {
            return GetReport(req, "vm_Recharge", aideTreasureFacade.GetReportRecharge, GetRechargeCond);
        }

        private string GeGift(HttpRequest req)
        {
            return GetReport(req, "vm_Gift", aideTreasureFacade.GetReportGift, GetGiftCond);
        }

        private string GetLoginLog(HttpRequest req)
        {
            return GetReport(req, "vm_LoginLog", aideTreasureFacade.GetReportLoginLog, GetLoginLogCond);
        }

        private string GetRichChange(HttpRequest req)
        {
            return GetReport(req, "vm_RichChange", aideTreasureFacade.GetReportRichChange, GetRichCond);
        }

        private string GetPlayGame(HttpRequest req)
        {
            return GetReport(req, "vm_PlayGame", aideTreasureFacade.GetReportPlayGame, GetPlayGameCond);
        }

        private string GetGameWaste(HttpRequest req)
        {
            return GetReport(req, "vm_GameWaste", aideTreasureFacade.GetReportGameWaste, GetGameWasteCond);
        }

        private string GetAllSum(HttpRequest req)
        {
            return GetReport(req, "vm_AllSum", aideTreasureFacade.GetReportAllSum, GetAllSumCond);
        }
        private string GetAllSum_Gamer(HttpRequest req)
        {
            return GetReport(req, "vm_AllSum_Gamer", aideTreasureFacade.GetReportAllSum_Gamer, GetAllSumCond);
        }
        #endregion

        Dictionary<string, object> GetRechargeCond(HttpRequest req)
        {
            Dictionary<string, object> whereAppend = new Dictionary<string, object>();
            whereAppend.Add("Accounts", req["Accounts"]);
            whereAppend.Add("Nullity", Convert.ToInt32(req["Range"] ?? "0"));
            whereAppend.Add("startDate", req["startDate"]);
            whereAppend.Add("endDate", req["endDate"]);
            whereAppend.Add("userType", req["userType"]);
            whereAppend.Add("byUserID", Convert.ToInt32(req["byUserID"]));
            return whereAppend;
        }

        Dictionary<string, object> GetGiftCond(HttpRequest req)
        {
            Dictionary<string, object> whereAppend = new Dictionary<string, object>();
            whereAppend.Add("Accounts", req["Accounts"]);
            whereAppend.Add("OperationType", Convert.ToInt32(req["OperationType"] ?? "-1"));
            whereAppend.Add("startDate", req["startDate"]);
            whereAppend.Add("endDate", req["endDate"]);
            whereAppend.Add("userType", req["userType"]);
            whereAppend.Add("byUserID", Convert.ToInt32(req["byUserID"]));
            return whereAppend;
        }

        Dictionary<string, object> GetLoginLogCond(HttpRequest req)
        {
            Dictionary<string, object> whereAppend = new Dictionary<string, object>();
            whereAppend.Add("startDate", req["startDate"]);
            whereAppend.Add("endDate", req["endDate"]);
            whereAppend.Add("userType", req["userType"]);
            whereAppend.Add("byUserID", Convert.ToInt32(req["byUserID"]));
            return whereAppend;
        }

        Dictionary<string, object> GetRichCond(HttpRequest req)
        {
            Dictionary<string, object> whereAppend = new Dictionary<string, object>();
            whereAppend.Add("rType", Convert.ToInt32(req["rType"] ?? "-1"));
            whereAppend.Add("startDate", req["startDate"]);
            whereAppend.Add("endDate", req["endDate"]);
            whereAppend.Add("userType", req["userType"]);
            whereAppend.Add("byUserID", Convert.ToInt32(req["byUserID"]));
            return whereAppend;
        }

        Dictionary<string, object> GetPlayGameCond(HttpRequest req)
        {
            Dictionary<string, object> whereAppend = new Dictionary<string, object>();
            whereAppend.Add("GameID", Convert.ToInt32(req["GameID"] ?? "-1"));
            whereAppend.Add("RoomID", Convert.ToInt32(req["RoomID"] ?? "-1"));
            whereAppend.Add("Accounts", req["Accounts"]);
            whereAppend.Add("startDate", req["startDate"]);
            whereAppend.Add("endDate", req["endDate"]);
            whereAppend.Add("userType", req["userType"]);
            whereAppend.Add("byUserID", Convert.ToInt32(req["byUserID"]));
            return whereAppend;
        }

        Dictionary<string, object> GetGameWasteCond(HttpRequest req)
        {
            Dictionary<string, object> whereAppend = new Dictionary<string, object>();
            whereAppend.Add("GameID", Convert.ToInt32(req["GameID"] ?? "-1"));
            whereAppend.Add("startDate", req["startDate"]);
            whereAppend.Add("endDate", req["endDate"]);
            whereAppend.Add("userType", req["userType"]);
            whereAppend.Add("byUserID", Convert.ToInt32(req["byUserID"]));
            return whereAppend;
        }

        Dictionary<string, object> GetAllSumCond(HttpRequest req)
        {
            Dictionary<string, object> whereAppend = new Dictionary<string, object>();
            whereAppend.Add("startDate", req["startDate"]);
            whereAppend.Add("endDate", req["endDate"]);
            whereAppend.Add("userType", req["userType"]);
            whereAppend.Add("byUserID", Convert.ToInt32(req["byUserID"]));
            return whereAppend;
        }

        private string GetReportBind(HttpRequest req)
        {
            DataTable dtRoomList = aidePlatformFacade.GetGameRoomList();
            string json = GetJsonByDataTable(dtRoomList);

            DataTable dtGameList = aidePlatformFacade.GetGameItemList();
            string json1 = GetJsonByDataTable(dtGameList);

            return JsonResultHelper.GetSuccessJsonByArray("{\"data\":{\"roomlist\":" + json + ",\"gamelist\":" + json1 + "}}");
        }

        public string GetSpreadSumByUserID(HttpRequest req)
        {
            int UserID = Convert.ToInt32(req["UserID"]);
            string today = DateTime.Parse(req["today"]).ToString("yyyy-MM-dd");
            DataSet ds = aidePlatformManagerFacade.GetGamerSpreadSumByDay(UserID, today);
            DataTable dtA = ds.Tables[0];
            DataTable dtB = ds.Tables[1];
            DataTable dtC = ds.Tables[2];
            DataTable dtR = ds.Tables[3];
            string jsonA = GetJsonByDataTable(dtA);
            string jsonB = GetJsonByDataTable(dtB);
            string jsonC = GetJsonByDataTable(dtC);
            string RealSpreadSum = dtR.Rows[0][0].ToString();
            string json = "{\"status\":\"success\",\"message\":\"\",\"result\":{\"A\":" + jsonA + ",\"B\":" + jsonB + ",\"C\":" + jsonC + ",\"RealSpreadSum\":" + RealSpreadSum + "}}";
            return json;
        }
    }
}
