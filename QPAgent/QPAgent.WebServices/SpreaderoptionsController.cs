using Game.Utils;
using QPAgent.WebServices.Helpers;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web;

namespace QPAgent.WebServices
{
    public class SpreaderoptionsController : ControllerBase
    {
        public override string Index(HttpRequest req)
        {
            string subType = req["subType"];
            string json = "";
            switch (subType)
            {
                case "binddata":
                    json = bindData(req);
                    break;
                default:
                    json = getIndex(req);
                    break;
            }

            return json;
        }

        private string getIndex(HttpRequest req)
        {
            string json = "";
            try
            {
                DataTable dt1 = aidePlatformManagerFacade.GetAgentSpreaderOptions();
                DataTable dt2 = aidePlatformManagerFacade.GetAgentRevenesSet();
                string json1 = GetJsonByDataTableEx(dt1).Trim();
                string json2 = GetJsonByDataTableEx(dt2).Trim();
                json = JsonResultHelper.GetSuccessJsonByArray("{\"SpreadOptionsSet\":" + json1 + ",\"AgentRevenesSet\":" + json2 + "}");
            }
            catch (Exception ex)
            {
                json = JsonResultHelper.GetErrorJson(ex.Message);
            }
            return json;
        }

        private string bindData(HttpRequest req)
        {
            string json = "";
            DataTable dtAR = aidePlatformManagerFacade.GetAgentRoles(-1);
            DataTable dtAG = aidePlatformManagerFacade.GetAgentGrades();
            json = "{\"AgentRoles\":" + GetJsonByDataTable(dtAR) + ",\"AgentGrades\":" + GetJsonByDataTable(dtAG) + "}";
            json = JsonResultHelper.GetSuccessJsonByArray(json);
            return json;
        }

        public override string New(HttpRequest req)
        {
            string json = "";
            string module = GetModuleName(Convert.ToInt32(req["moduleType"] ?? "0"));
            try
            {
                string subType = req["subType"];
                string objson = JsonUrlEncode(req.Form.ToString());
                switch (subType)
                {
                    case "spreadoptionsset":
                        DataTable dt0 = JsonToDataTable(objson, new List<string>() { "RoleID", "GradeID", "Rate", "ARate", "BRate", "CRate" });
                        aidePlatformManagerFacade.SaveSpreaderOptions(dt0);
                        json = JsonResultHelper.GetSuccessJson("保存成功！");
                        LogHelper2.SaveSuccessLog("修改了分享返利比例", userExt.UserID, (int)LogOperationEnum.SpreadOption, GameRequest.GetUserIP(), module);
                        break;
                    case "agentrevenesset":
                        DataTable dt1 = JsonToDataTable(objson, new List<string>() { "UserID", "Percentage" });
                        aidePlatformManagerFacade.SaveAgentRevenesSet(dt1);
                        json = JsonResultHelper.GetSuccessJson("保存成功！");
                        LogHelper2.SaveSuccessLog("修改了代理返利比例", userExt.UserID, (int)LogOperationEnum.EditAgent, GameRequest.GetUserIP(), module);
                        break;
                }
            }
            catch (Exception ex)
            {
                json = JsonResultHelper.GetErrorJson(ex.Message);
                LogHelper2.SaveErrLog("修改返利比例", ex.Message, userExt.UserID, (int)LogOperationEnum.AddRole, GameRequest.GetUserIP(), module);
            }
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
