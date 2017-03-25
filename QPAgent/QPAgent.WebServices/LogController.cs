using Game.Kernel;
using Game.Utils;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;

namespace QPAgent.WebServices
{
    public class LogController : ControllerBase
    {
        const string View = "vw_Log";

        protected Dictionary<string, object> GetCondition(HttpRequest req)
        {
            int byUserID = userExt.AgentID;
            Dictionary<string, object> conditions = new Dictionary<string, object>();
            string @Accounts = req["@Accounts"];
            string userType = req["userType"];
            conditions.Add("Accounts", @Accounts);
            conditions.Add("byUserID", byUserID);
            conditions.Add("userType", userType);
            conditions.Add("operationID", Convert.ToInt32(req["OperationID"] ?? "-1"));
            if (!string.IsNullOrEmpty(req["startDate"] ?? ""))
                conditions.Add("startDate", req["startDate"] ?? "");
            if (!string.IsNullOrEmpty(req["endDate"] ?? ""))
                conditions.Add("endDate", req["endDate"] ?? "");
            return conditions;
        }

        public override string Index(HttpRequest req)
        {
            /************ 获取日志操作类型 **************/
            string dataType = req["dataType"];
            if (dataType == "operations")
            {
                DataTable dtOperations = aidePlatformManagerFacade.GetLogOperations();
                string jsonstr = GetJsonByDataTable(dtOperations);
                jsonstr = JsonResultHelper.GetSuccessJsonByArray(jsonstr);
                return jsonstr;
            }
            /******************* end *****************/

            int pageIndex = Convert.ToInt32(req["pageIndex"] ?? "1");
            int pageSize = Convert.ToInt32(req["pageSize"] ?? "20");

            PagerSet pageSet = aidePlatformManagerFacade.GetSystemLog(pageIndex, pageSize, GetCondition(req));
            DataTable dtLogs = pageSet.PageSet.Tables[1];

            string json = GetResponse(GetModuleName((int)ModuleType.SystemLog), "vw_Log", dtLogs, pageSize, pageSet.RecordCount);
            json = json.Replace("\n", "").Replace("\r", "");
            return json;
        }

        public override string New(HttpRequest req)
        {
            int Operator = Convert.ToInt32(req.Form["Operator"]);
            int Operation = Convert.ToInt32(req.Form["Operation"]);
            string LogContent = req.Form["LogContent"];
            string Module = req["Module"];
            string LoginIP = GameRequest.GetUserIP();
            aidePlatformManagerFacade.AddLog(Operator, Operation, LogContent, LoginIP, Module);
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

    }
}
