using Game.Kernel;
using Game.Utils;
using QPAgent.WebServices.Helpers;
using System;
using System.Data;
using System.Web;

namespace QPAgent.WebServices
{
    public class SensitiveWordController : ControllerBase
    {
        const string View = "vw_SensitiveWord";
        public override string Index(HttpRequest req)
        {
            try
            {
                string keyword = req["keyword"];
                int pageIndex = Convert.ToInt32(req["pageIndex"] ?? "1");
                int pageSize = Convert.ToInt32(req["pageSize"] ?? "20");
                PagerSet pageSet = aidePlatformManagerFacade.GetSensitiveWordSet(keyword, pageIndex, pageSize);
                DataTable dt = pageSet.PageSet.Tables[1];

                string json = GetResponse(GetModuleName((int)ModuleType.SensitiveWord), View, dt, pageSize, pageSet.RecordCount);
                return json;
            }
            catch (Exception ex)
            {
                return JsonResultHelper.GetErrorJson(ex.Message);
            }
        }

        public string GetSensitiveWordSet()
        {
            PagerSet pageSet = aidePlatformManagerFacade.GetSensitiveWordSet("", 1, int.MaxValue);
            DataTable dt = pageSet.PageSet.Tables[1];

            string json = GetJsonByDataTable(dt);
            return json;
        }

        public override string New(HttpRequest req)
        {
            string module = GetModuleName(Convert.ToInt32(req["moduleType"] ?? "0"));
            try
            {
                string sword = req["SensitiveWord"];
                aidePlatformManagerFacade.AddSensitiveWordSet(sword);
                LogHelper2.SaveSuccessLog("新增敏感词【" + sword + "】", userExt.UserID, (int)LogOperationEnum.EditSensitiveWord, GameRequest.GetUserIP(), module);
                return JsonResultHelper.GetSuccessJson("保存成功！");
            }
            catch (Exception ex)
            {
                return JsonResultHelper.GetErrorJson("保存失败：" + ex.Message);
            }
        }

        public override string Edit(HttpRequest req)
        {
            string module = GetModuleName(Convert.ToInt32(req["moduleType"] ?? "0"));
            try
            {
                int id = Convert.ToInt32(req["ID"]);
                string oldsword = req["OldSensitiveWord"];
                string sword = req["SensitiveWord"];
                aidePlatformManagerFacade.SaveSensitiveWordSet(id, sword);
                LogHelper2.SaveSuccessLog("修改敏感词【" + oldsword + "】为【" + sword + "】", userExt.UserID, (int)LogOperationEnum.EditSensitiveWord, GameRequest.GetUserIP(), module);
                return JsonResultHelper.GetSuccessJson("保存成功！");
            }
            catch (Exception ex)
            {
                return JsonResultHelper.GetErrorJson("保存失败：" + ex.Message);
            }
        }

        public override string Delete(HttpRequest req)
        {
            string module = GetModuleName(Convert.ToInt32(req["moduleType"] ?? "0"));
            try
            {
                string ids = req["ids"];
                string swords = req["swords"];
                aidePlatformManagerFacade.DeleteSensitiveWordSet(ids);
                LogHelper2.SaveSuccessLog("删除了敏感词【" + swords + "】", userExt.UserID, (int)LogOperationEnum.EditSensitiveWord, GameRequest.GetUserIP(), module);
                return JsonResultHelper.GetSuccessJson("操作成功！");
            }
            catch (Exception ex)
            {
                return JsonResultHelper.GetErrorJson("操作失败：" + ex.Message);
            }
        }
    }
}
