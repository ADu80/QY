using Game.Entity.PlatformManager;
using Game.Kernel;
using Game.Utils;
using QPAgent.WebServices.Helpers;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;

namespace QPAgent.WebServices
{
    public class AdminController : ControllerBase
    {
        const string View = "vw_Admin";

        public override string Index(HttpRequest req)
        {
            try
            {
                int pageIndex = Convert.ToInt32(req["pageIndex"] ?? "1");
                int pageSize = Convert.ToInt32(req["pageSize"] ?? "20");
                PagerSet pageSet = aidePlatformManagerFacade.GetUserList(pageIndex, pageSize, GetCondition(req), "ORDER BY UserID DESC");
                DataTable dtUsers = pageSet.PageSet.Tables[0];

                string json = GetResponse(GetModuleName((int)ModuleType.Admin), View, dtUsers, pageSize, pageSet.RecordCount);
                return json;
            }
            catch (Exception ex)
            {
                return JsonResultHelper.GetErrorJson(ex.Message);
            }
        }
          
        protected string GetCondition(HttpRequest req)
        {
            string keyword = req["keyword"];
            string status = req["status"];
            StringBuilder sb = new StringBuilder();
            sb.Append(" WHERE AgentID IS NULL");
            if (!string.IsNullOrEmpty(keyword))
            {
                sb.AppendFormat(" AND (UserName LIKE '%{0}%')", keyword);
            }
            if (!string.IsNullOrEmpty(status) && Convert.ToInt32(status) != -1)
            {
                sb.Append(" AND Nullity=" + status);
            }
            return sb.ToString();
        }

        public override string New(HttpRequest req)
        {
            string json = "";
            string module = GetModuleName(Convert.ToInt32(req["moduleType"] ?? "0"));


            try
            {
                Base_Users user = new Base_Users();
                user.Username = req.Form["UserName"];
                user.Password = Utility.MD5(req.Form["Password"]);
                bool oIsBand = (req.Form["IsBand"] == "on" ? true : false);
                byte IsBand = Convert.ToByte(oIsBand);
                user.BandIP = req.Form["BandIP"];
                user.RoleID = Convert.ToInt32(string.IsNullOrEmpty(req.Form["RoleID"]) ? "0" : req.Form["RoleID"]);
                user.LastLoginIP = Utility.UserIP;
                string sNullity = req.Form["Nullity"];
                user.Nullity = Convert.ToByte(sNullity == "on" ? 1 : 0);
                if (string.IsNullOrEmpty(user.Username))
                {
                    json = JsonResultHelper.GetSuccessJson("用户名不能为空");
                }
                else
                {
                    Base_Users getuser = aidePlatformManagerFacade.GetUserByAccounts(user.Username);
                    if (getuser != null)
                    {
                        json = JsonResultHelper.GetSuccessJson("用户名已经存在！");
                        LogHelper2.SaveErrLog("新增账号[" + req.Form["UserName"] + "]", "保存失败！用户名已经存在！", userExt.UserID, (int)LogOperationEnum.AddAdmin, GameRequest.GetUserIP(), module);
                    }
                    else
                    {
                        int id = aidePlatformManagerFacade.AddUser(user);
                        if (id == -1)
                            json = JsonResultHelper.GetSuccessJson("保存失败！");
                        else
                            json = JsonResultHelper.GetSuccessJson("保存成功！");

                        LogHelper2.SaveSuccessLog("新增账号[" + req.Form["UserName"] + "]", userExt.UserID, (int)LogOperationEnum.AddAdmin, GameRequest.GetUserIP(), module);

                    }
                }
            }
            catch (Exception ex)
            {
                json = JsonResultHelper.GetErrorJson(ex.Message);
                LogHelper2.SaveErrLog("新增账号[" + req.Form["UserName"] + "]", ex.Message, userExt.UserID, (int)LogOperationEnum.AddAdmin, GameRequest.GetUserIP(), module);
            }
            return json;
        }

        public override string Edit(HttpRequest req)
        {
            string subType = req["subType"];
            string json = "";
            switch (subType)
            {
                case "ch_role":
                    json = ChangeRole(req);
                    break;
                case "ch_pwd":
                    json = ChangePassword(req);
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

        private string Save(HttpRequest req)
        {
            int UserID = Convert.ToInt32(req.Form["UserID"]);
            string Username = req.Form["UserName"];
            bool oIsBand = (req.Form["IsBand"] == "on" ? true : false);
            byte IsBand = Convert.ToByte(oIsBand);
            string BandIP = req.Form["BandIP"];
            string OrgUserName = req.Form["OrgUserName"];

            int RoleID = Convert.ToInt32(string.IsNullOrEmpty(req.Form["RoleID"]) ? "0" : req.Form["RoleID"]);
            string LastLoginIP = Utility.UserIP;
            Dictionary<string, object> kvs = new Dictionary<string, object>();
            kvs.Add(Base_Users._Username, Username);
            kvs.Add(Base_Users._IsBand, IsBand);
            kvs.Add(Base_Users._BandIP, BandIP);
            kvs.Add(Base_Users._RoleID, RoleID);
            string module = GetModuleName(Convert.ToInt32(req["moduleType"] ?? "0"));
            Base_Users getuser = aidePlatformManagerFacade.GetUserByAccountsAndUserId(UserID,Username);
            if (getuser != null)
            {
                return JsonResultHelper.GetSuccessJson("用户名已经存在！");
            }
            try
            {
                aidePlatformManagerFacade.UpdateUserByID(UserID, kvs);
                LogHelper2.SaveSuccessLog("修改[" + req.Form["UserName"] + "]", userExt.UserID, (int)LogOperationEnum.EditAgent, GameRequest.GetUserIP(), module);
                return JsonResultHelper.GetSuccessJson("保存成功！");
            }
            catch (Exception ex)
            {
                LogHelper2.SaveErrLog("修改[" + req.Form["UserName"] + "]", ex.Message, userExt.UserID, (int)LogOperationEnum.ChangeAdminRole, GameRequest.GetUserIP(), module);
                return JsonResultHelper.GetErrorJson("保存失败！" + ex.Message);
            }
        }

        private string ChangeRole(HttpRequest req)
        {
            int UserID = Convert.ToInt32(req.Form["UserID"]);
            string RoleID = req.Form["RoleID"];
            Dictionary<string, object> kvs = new Dictionary<string, object>();
            kvs.Add(Base_Users._RoleID, RoleID);
            string module = GetModuleName(Convert.ToInt32(req["moduleType"] ?? "0"));
            try
            {
                aidePlatformManagerFacade.UpdateUserByID(UserID, kvs);
                LogHelper2.SaveSuccessLog("[" + req.Form["UserName"] + "]更换角色成[]", userExt.UserID, (int)LogOperationEnum.ChangeAdminRole, GameRequest.GetUserIP(), module);
                return JsonResultHelper.GetSuccessJson("保存成功！");
            }
            catch (Exception ex)
            {
                LogHelper2.SaveErrLog("[" + req.Form["UserName"] + "]更换角色成：", ex.Message, userExt.UserID, (int)LogOperationEnum.ChangeAdminRole, GameRequest.GetUserIP(), module);
                return JsonResultHelper.GetErrorJson("保存失败！" + ex.Message);
            }
        }

        private string SetNullity(HttpRequest req, byte Nullity)
        {
            Dictionary<string, object> kvs = new Dictionary<string, object>();
            string ids = req["ids"];
            StringBuilder conditionAppend = new StringBuilder();
            conditionAppend.Append(" AND UserID IN (" + ids + ")");

            kvs.Add(Base_Users._Nullity, Nullity);
            string module = GetModuleName(Convert.ToInt32(req["moduleType"] ?? "0"));
            try
            {
                aidePlatformManagerFacade.UpdateUserBy(conditionAppend.ToString(), kvs);
                LogHelper2.SaveSuccessLog("冻结账号[" + ids + "]", userExt.UserID, Convert.ToBoolean(Nullity) ? (int)LogOperationEnum.NullityAdmin : (int)LogOperationEnum.NoNullityAdmin, GameRequest.GetUserIP(), module);
                return JsonResultHelper.GetSuccessJson("保存成功！");
            }
            catch (Exception ex)
            {
                LogHelper2.SaveErrLog("冻结账号[" + ids + "]", ex.Message, userExt.UserID, Convert.ToBoolean(Nullity) ? (int)LogOperationEnum.NullityAdmin : (int)LogOperationEnum.NoNullityAdmin, GameRequest.GetUserIP(), module);
                return JsonResultHelper.GetErrorJson("保存失败！" + ex.Message);
            }
        }

        private string ChangePassword(HttpRequest req)
        {
            string UserName = req["UserName"];
            string module = GetModuleName(Convert.ToInt32(req["moduleType"] ?? "0"));
            try
            {
                int UserID = Convert.ToInt32(req["UserID"]);
                aidePlatformManagerFacade.ResetUserPassword(UserID, Utility.MD5("123456"));
                LogHelper2.SaveSuccessLog("重置[" + UserName + "]密码", userExt.UserID, (int)LogOperationEnum.ChangeAdminPassword, GameRequest.GetUserIP(), module);
                return JsonResultHelper.GetSuccessJson("保存成功！");
            }
            catch (Exception ex)
            {
                LogHelper2.SaveErrLog("重置[" + UserName + "]密码", ex.Message, userExt.UserID, (int)LogOperationEnum.ChangeAdminPassword, GameRequest.GetUserIP(), module);
                return JsonResultHelper.GetErrorJson("保存失败：" + ex.Message);
            }
        }

        public override string Delete(HttpRequest req)
        {
            string ids = req["ids"];
            string module = GetModuleName(Convert.ToInt32(req["moduleType"] ?? "0"));
            try
            {
                aidePlatformManagerFacade.DeleteUser(ids);
                LogHelper2.SaveSuccessLog("删除[" + ids + "]", userExt.UserID, (int)LogOperationEnum.DeleteAdmin, GameRequest.GetUserIP(), module);
                return JsonResultHelper.GetSuccessJson("删除成功！");
            }
            catch (Exception ex)
            {
                LogHelper2.SaveErrLog("删除[" + ids + "]：", ex.Message, userExt.UserID, (int)LogOperationEnum.DeleteAdmin, GameRequest.GetUserIP(), module);
                return JsonResultHelper.GetErrorJson(ex.Message);
            }
        }
    }
}
