using Game.Entity.PlatformManager;
using Game.Facade;
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
    public class RolesController : ControllerBase
    {
        const string View = "vw_Roles";

        public override string Index(HttpRequest req)
        {
            int pageIndex = Convert.ToInt32(req["pageIndex"] ?? "1");
            int pageSize = Convert.ToInt32(req["pageSize"] ?? "20");
            PagerSet pageSet = aidePlatformManagerFacade.GetRoleList(pageIndex, pageSize, GetCondition(req), " ORDER BY RoleID ASC");
            DataTable dtRoles = pageSet.PageSet.Tables[0];

            string json = GetResponse(GetModuleName((int)ModuleType.Roles), View, dtRoles, pageSize, pageSet.RecordCount);
            return json;
        }

        protected string GetCondition(HttpRequest req)
        {
            return "";
        }

        public override string New(HttpRequest req)
        {
            if (!IsAuthUserOperationPermission())
            {
                return JsonResultHelper.GetErrorJson("对不起，您没有操作权限！");
            }
            string module = GetModuleName(Convert.ToInt32(req["moduleType"] ?? "0"));
            try
            {
                Base_Roles Role = new Base_Roles();
                Role.RoleName = req.Form["RoleName"];
                Role.Description = req.Form["Description"];
                //Role.Operator = req.Form["AgentLevel"];
                Role.Operator = req.Form["Operator"];
                string created = req.Form["Created"];
                string modified = req.Form["Modified"];
                Role.Created = DateTime.Parse(created);
                Role.Modified = DateTime.Parse(modified);
                Message msg = aidePlatformManagerFacade.InsertRole(Role);
                string json = "";
                if (msg.Success)
                {
                    json = JsonResultHelper.GetSuccessJson("保存成功！");
                }
                else
                {
                    json = JsonResultHelper.GetErrorJson(msg.Content);
                }
                LogHelper2.SaveSuccessLog("新增角色[" + req.Form["RoleName"] + "]", userExt.UserID, (int)LogOperationEnum.AddRole, GameRequest.GetUserIP(), module);
                return json;
            }
            catch (Exception ex)
            {
                LogHelper2.SaveErrLog("新增角色[" + req.Form["RoleName"] + "]", ex.Message, userExt.UserID, (int)LogOperationEnum.AddRole, GameRequest.GetUserIP(), module);
                return JsonResultHelper.GetErrorJson(ex.Message);
            }
        }

        public override string Edit(HttpRequest req)
        {
            if (!IsAuthUserOperationPermission())
            {
                return JsonResultHelper.GetErrorJson("对不起，您没有操作权限！");
            }
            string module = GetModuleName(Convert.ToInt32(req["moduleType"] ?? "0"));
            try
            {
                Base_Roles Role = new Base_Roles();
                Role.RoleName = req.Form["RoleName"];
                Role.Description = req.Form["Description"];
                Role.Operator = req.Form["AgentLevel"];
                Role.Operator = req.Form["Operator"];
                Role.RoleID = int.Parse(req.Form["RoleID"] == null ? "0" : req.Form["RoleID"]);
                string modified = req.Form["Modified"];
                Role.Modified = DateTime.Now; 
                Message msg = aidePlatformManagerFacade.UpdateRole(Role);
                if (msg.Success)
                {
                    LogHelper2.SaveSuccessLog("修改角色[" + req.Form["RoleName"] + "]", userExt.UserID, (int)LogOperationEnum.EditRole, GameRequest.GetUserIP(), module);
                    return JsonResultHelper.GetSuccessJson("保存成功！");
                }
                else
                {
                    LogHelper2.SaveErrLog("修改角色[" + req.Form["RoleName"] + "]", msg.Content, userExt.UserID, (int)LogOperationEnum.EditRole, GameRequest.GetUserIP(), module);
                    return JsonResultHelper.GetErrorJson(msg.Content);
                }
            }
            catch (Exception ex)
            {
                LogHelper2.SaveErrLog("修改角色[" + req.Form["RoleName"] + "]", ex.Message, userExt.UserID, (int)LogOperationEnum.EditRole, GameRequest.GetUserIP(), module);
                return JsonResultHelper.GetErrorJson(ex.Message);
            }
        }

        public override string Delete(HttpRequest req)
        {
            if (!IsAuthUserOperationPermission())
            {
                return JsonResultHelper.GetErrorJson("对不起，您没有操作权限！");
            }

            string module = GetModuleName(Convert.ToInt32(req["moduleType"] ?? "0"));
            string json = "";
            string ids = req["ids"];
            try
            {

                string msg = aidePlatformManagerFacade.DeleteRoleEx(ids);
                if (msg == "success")
                {
                    json = JsonResultHelper.GetSuccessJson("成功删除！");
                    LogHelper2.SaveSuccessLog("删除[" + ids + "]", userExt.UserID, (int)LogOperationEnum.DeleteRole, GameRequest.GetUserIP(), module);
                }
                else
                {
                    json = JsonResultHelper.GetErrorJson(msg + " 已存在关联用户，不能删除！");
                    LogHelper2.SaveErrLog("删除[" + ids + "]", msg, userExt.UserID, (int)LogOperationEnum.AddGamer, GameRequest.GetUserIP(), module);
                }
            }
            catch (Exception ex)
            {
                LogHelper2.SaveErrLog("删除[" + ids + "]", ex.Message, userExt.UserID, (int)LogOperationEnum.DeleteRole, GameRequest.GetUserIP(), module);
                json = JsonResultHelper.GetErrorJson(ex.Message);
            }
            return json;
        }
    }
}
