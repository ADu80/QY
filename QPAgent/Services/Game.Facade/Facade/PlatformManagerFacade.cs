using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Data.Factory;
using Game.IData;
using Game.Kernel;
using Game.Entity.PlatformManager;
using Game.Utils;
using System.Data;
using Game.Entity;

namespace Game.Facade
{
    public class PlatformManagerFacade
    {
        #region Fields

        private IPlatformManagerDataProvider aidePlatformManagerData;

        #endregion

        #region 构造函数
        /// <summary>
        /// 构造函数
        /// </summary>
        public PlatformManagerFacade()
        {
            aidePlatformManagerData = ClassFactory.GetIPlatformManagerDataProvider();
        }
        #endregion


        public PagerSet GetDocList(int pageIndex, int pageSize, string condition, string orderby)
        {
            return aidePlatformManagerData.GetDocList(pageIndex, pageSize, condition, orderby);
        }
        public docunmentinfo GetDocInfo(int docID)
        {
            return aidePlatformManagerData.GetDocInfo(docID);
        }

        public Message InsertDoc(docunmentinfo doc)
        {
            aidePlatformManagerData.InsertDoc(doc);
            return new Message(true);
        }
        public Message UpdateDoc(docunmentinfo doc)
        {
            aidePlatformManagerData.UpdateDoc(doc);
            return new Message(true);
        }
        public void DeleteDoc(string sqlQuery)
        {
            aidePlatformManagerData.DeleteRole(sqlQuery);
        }

        #region 管理员管理
        /// <summary>
        /// 管理员登录
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        public Message UserLogon(Base_Users user)
        {
            Message msg = GameWebRules.CheckedUserLogon(user);
            if (!msg.Success)
                return msg;
            msg = aidePlatformManagerData.UserLogon(user);
            if (msg.Success)
            {
                Base_Users logonUser = msg.EntityList[0] as Base_Users;
                AdminCookie.SetLoginUserCookie(logonUser);
            }
            return msg;
        }

        /// <summary>
        /// 管理员注销
        /// </summary>
        public void UserLogout()
        {
            AdminCookie.SesionUser userExt = GetUserInfoFromCookie();
            if (userExt == null)
                return;
            AdminCookie.ClearUserSession();
        }



        /// <summary>
        /// 获取管理员对象 by cookie
        /// </summary>
        /// <returns></returns>
        public AdminCookie.SesionUser GetUserInfoFromCookie()
        {
            AdminCookie.SesionUser userExt = AdminCookie.GetUserFromCookie();
            return userExt;
        }

        /// <summary>
        /// 检查用户登录状态
        /// </summary>
        /// <returns></returns>
        public bool CheckedUserLogon()
        {
            return AdminCookie.CheckedUserLogon();
        }

        /// <summary>
        /// 添加管理员用户
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        public Message Register(Base_Users user)
        {
            Message msg = GameWebRules.CheckedUserToRegister(ref user);
            if (!msg.Success)
                return msg;

            msg = ExistUserAccounts(user.Username);
            if (msg.Success)
            {
                msg.Success = false;
                return msg;
            }

            aidePlatformManagerData.Register(user);
            return new Message(true);
        }


        /// <summary>
        /// 修改资料
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        public Message ModifyUserInfo(Base_Users user)
        {
            Message msg = GameWebRules.CheckedUserToModify(ref user);
            if (!msg.Success)
            {
                return msg;
            }

            Base_Users extUser = GetUserByUserID(user.UserID);
            //if (extUser.Username != user.Username)
            //{
            //    msg = ExistUserAccounts(user.Username);
            //    if (!msg.Success)
            //    {
            //        msg.Success = false;
            //        return msg;
            //    }
            //}
            aidePlatformManagerData.ModifyUserInfo(user);
            return new Message(true);
        }

        /// <summary>
        /// 封停帐号
        /// </summary>
        /// <param name="userIDList"></param>
        /// <param name="nullity"></param>
        public void ModifyUserNullity(string userIDList, bool nullity)
        {
            aidePlatformManagerData.ModifyUserNullity(userIDList, nullity);
        }

        /// <summary>
        /// 获取用户列表
        /// </summary>
        /// <returns></returns>
        public DataSet GetUserList()
        {
            return aidePlatformManagerData.GetUserList();
        }

        /// <summary>
        /// 获取用户列表
        /// </summary>
        /// <param name="pageIndex"></param>
        /// <param name="pageSize"></param>
        /// <param name="condition"></param>
        /// <param name="orderby"></param>
        /// <returns></returns>
        public PagerSet GetUserList(int pageIndex, int pageSize, string condition, string orderby)
        {
            return aidePlatformManagerData.GetUserList(pageIndex, pageSize, condition, orderby);
        }

        /// <summary>
        /// 获取用户列表 by RoleID
        /// </summary>
        /// <param name="roleID">用户角色</param>
        /// <returns></returns>
        public DataSet GetUserListByRoleID(int roleID)
        {
            return aidePlatformManagerData.GetUserListByRoleID(roleID);
        }

        /// <summary>
        /// 获取用户对象 by userID
        /// </summary>
        /// <param name="userID">用户标识</param>
        /// <returns></returns>
        public Base_Users GetUserByUserID(int userID)
        {
            Base_Users user = aidePlatformManagerData.GetUserByUserID(userID);

            return user;
        }

        /// <summary>
        /// 获取用户对象 by accounts
        /// </summary>
        /// <param name="accounts"></param>
        /// <returns></returns>
        public Base_Users GetUserByAccounts(string accounts)
        {
            return aidePlatformManagerData.GetUserByAccounts(accounts);
        }

        public Base_Users GetUserByAccountsAndUserId(int uid, string accounts)
        {
            return aidePlatformManagerData.GetUserByAccountsAndUserId(uid, accounts);
        }

        /// <summary>
        /// 获取管理员帐号
        /// </summary>
        /// <param name="userID"></param>
        /// <returns></returns>
        public string GetAccountsByUserID(int userID)
        {
            Base_Users user = GetUserByUserID(userID);
            if (user != null)
                return user.Username;

            return "";
        }

        /// <summary>
        /// 删除用户
        /// </summary>
        /// <param name="userIDList">用户标识</param>
        public void DeleteUser(string userIDList)
        {
            aidePlatformManagerData.DeleteUser(userIDList);
        }

        /// <summary>
        /// 管理员帐号是否存在
        /// </summary>
        /// <param name="accounts"></param>
        /// <returns></returns>
        public Message ExistUserAccounts(string accounts)
        {
            Base_Users user = aidePlatformManagerData.GetUserByAccounts(accounts);
            if (user != null && user.UserID > 0)
                return new Message(true, ResMessage.Error_ExistsUser);
            else
                return new Message(false);
        }
        #endregion

        #region  密码修改

        /// <summary>
        /// 验证用户密码
        /// </summary>
        /// <param name="userID"></param>
        /// <param name="logonPass"></param>
        /// <returns></returns>
        public Message ValidUserLogonPass(int userID, string logonPass)
        {
            Base_Users userExt = aidePlatformManagerData.GetUserByUserID(userID);
            if (userExt == null || userExt.UserID <= 0 ||
                !userExt.Password.Equals(logonPass, StringComparison.InvariantCultureIgnoreCase))
                return new Message(false, "帐号不存在或密码输入错误。");

            return new Message(true);
        }

        /// <summary>
        /// 修改密码(自动MD5加密)
        /// </summary>
        /// <param name="userExt"></param>
        /// <param name="oldPasswd">旧密码</param>
        /// <param name="newPasswd">新密码</param>
        /// <returns></returns>
        public Message ModifyUserLogonPass(Base_Users userExt, string oldPasswd, string newPasswd)
        {
            Message msg = GameWebRules.CheckUserPasswordForModify(ref oldPasswd, ref newPasswd);
            if (!msg.Success)
                return msg;

            msg = ValidUserLogonPass(userExt.UserID, oldPasswd);
            if (!msg.Success)
                return msg;

            aidePlatformManagerData.ModifyUserLogonPass(userExt, Utility.MD5(newPasswd));
            return new Message(true);
        }

        /// <summary>
        /// 修改其他管理员的密码
        /// </summary>
        /// <param name="admin">超级管理员</param>
        /// <param name="powerUser">修改密码的用户</param>
        /// <param name="newPasswd">新的密码</param>
        /// <returns></returns>
        public Message ModifyPowerUserLogonPass(Base_Users admin, Base_Users powerUser, string newPasswd)
        {
            if (admin.UserID != ApplicationConfig.SUPER_ADMINISTRATOR_ID
                || admin.RoleID != ApplicationConfig.SUPER_ADMINISTRATOR_ID)
                return new Message(false, "您没有修改用户密码的权限。");

            Message msg = GameWebRules.CheckedPassword(newPasswd);
            if (!msg.Success)
                return msg;

            newPasswd = TextEncrypt.EncryptPassword(newPasswd);
            aidePlatformManagerData.ModifyUserLogonPass(powerUser, newPasswd);

            return new Message(true);
        }

        #endregion

        #region  角色管理
        /// <summary>
        /// 获取角色列表
        /// </summary>
        /// <param name="pageIndex"></param>
        /// <param name="pageSize"></param>
        /// <param name="condition"></param>
        /// <param name="orderby"></param>
        /// <returns></returns>
        public PagerSet GetRoleList(int pageIndex, int pageSize, string condition, string orderby)
        {
            return aidePlatformManagerData.GetRoleList(pageIndex, pageSize, condition, orderby);
        }

        /// <summary>
        /// 获取角色实体
        /// </summary>
        /// <param name="roleID"></param>
        /// <returns></returns>
        public Base_Roles GetRoleInfo(int roleID)
        {
            return aidePlatformManagerData.GetRoleInfo(roleID);
        }

        /// <summary>
        /// 获得角色名称
        /// </summary>
        /// <param name="roleID"></param>
        /// <returns></returns>
        public string GetRolenameByRoleID(int roleID)
        {
            return aidePlatformManagerData.GetRolenameByRoleID(roleID);
        }

        /// <summary>
        /// 新增角色
        /// </summary>
        /// <param name="role"></param>
        public Message InsertRole(Base_Roles role)
        {
            aidePlatformManagerData.InsertRole(role);
            return new Message(true);
        }

        /// <summary>
        /// 更新角色
        /// </summary>
        /// <param name="role"></param>
        public Message UpdateRole(Base_Roles role)
        {
            aidePlatformManagerData.UpdateRole(role);
            return new Message(true);
        }

        /// <summary>
        /// 删除角色
        /// </summary>
        /// <param name="sqlQuery"></param>
        public void DeleteRole(string sqlQuery)
        {
            aidePlatformManagerData.DeleteRole(sqlQuery);
        }
        /// <summary>
        /// 删除角色
        /// </summary>
        /// <param name="sqlQuery"></param>
        public string DeleteRoleEx(string sqlQuery)
        {
            return aidePlatformManagerData.DeleteRoleEx(sqlQuery);
        }
        #endregion

        #region  菜单管理
        public DataSet GetDataSets(string sql)
        {
            return aidePlatformManagerData.GetDataSets(sql);
        }
        /// <summary>
        /// 获取菜单 by userID
        /// </summary>
        /// <param name="userID"></param>
        /// <returns></returns>
        public DataSet GetMenuByUserID(int userID)
        {
            DataSet ds = aidePlatformManagerData.GetMenuByUserID(userID);
            return ds;
        }
        public void ExecuteMenu(string sql)
        {
            aidePlatformManagerData.ExecuteMenu(sql);
        }
        /// <summary>
        /// 获取权限 by userID
        /// </summary>
        /// <param name="userID"></param>
        /// <returns></returns>
        public Dictionary<string, long> GetPermissionByUserID(int userID)
        {
            Dictionary<string, long> _rpDic = new Dictionary<string, long>();
            DataSet ds = aidePlatformManagerData.GetPermissionByUserID(userID);

            if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count != 0)
            {
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    _rpDic.Add(ds.Tables[0].Rows[i]["ModuleID"].ToString().Trim(), Utility.StrToInt(ds.Tables[0].Rows[i]["OperationPermission"].ToString().Trim(), 0));
                }
            }
            return _rpDic;
        }

        /// <summary>
        /// 获取父模块
        /// </summary>
        /// <returns></returns>
        public DataSet GetModuleParentList()
        {
            return aidePlatformManagerData.GetModuleParentList();
        }

        /// <summary>
        /// 获取子模块
        /// </summary>
        /// <param name="moduleID"></param>
        /// <returns></returns>
        public DataSet GetModuleListByModuleID(int moduleID)
        {
            return aidePlatformManagerData.GetModuleListByModuleID(moduleID);
        }

        /// <summary>
        /// 获取模块权限列表
        /// </summary>
        /// <param name="moduleID"></param>
        /// <returns></returns>
        public DataSet GetModulePermissionList(int moduleID)
        {
            return aidePlatformManagerData.GetModulePermissionList(moduleID);
        }

        /// <summary>
        /// 获取角色权限列表
        /// </summary>
        /// <param name="roleID"></param>
        /// <returns></returns>
        public DataSet GetRolePermissionList(int roleID)
        {
            return aidePlatformManagerData.GetRolePermissionList(roleID);
        }

        /// <summary>
        /// 新增角色权限
        /// </summary>
        /// <param name="rolePermission"></param>
        public Message InsertRolePermission(Base_RolePermission rolePermission)
        {
            aidePlatformManagerData.InsertRolePermission(rolePermission);
            return new Message(true);
        }

        /// <summary>
        /// 删除角色权限
        /// </summary>
        /// <param name="roleID"></param>
        public void DeleteRolePermission(int roleID)
        {
            aidePlatformManagerData.DeleteRolePermission(roleID);
        }

        #endregion

        #region 安全日志列表
        /// <summary>
        /// 获取安全日志列表
        /// </summary>
        /// <param name="pageIndex"></param>
        /// <param name="pageSize"></param>
        /// <param name="condition"></param>
        /// <param name="orderby"></param>
        /// <returns></returns>
        public PagerSet GetSystemSecurityList(int pageIndex, int pageSize, string condition, string orderby)
        {
            return aidePlatformManagerData.GetSystemSecurityList(pageIndex, pageSize, condition, orderby);
        }
        #endregion
        #region 系统配置
        /// <summary>
        /// 获取系统配置信息
        /// </summary>
        /// <param name="siteID"></param>
        /// <returns></returns>
        public QPAdminSiteInfo GetQPAdminSiteInfo(int siteID)
        {
            return aidePlatformManagerData.GetQPAdminSiteInfo(siteID);
        }
        /// <summary>
        /// 更新配置
        /// </summary>
        /// <param name="site"></param>
        public void UpdateQPAdminSiteInfo(QPAdminSiteInfo site)
        {
            aidePlatformManagerData.UpdateQPAdminSiteInfo(site);
        }
        #endregion

        #region 新增功能 2016-11-11
        /// <summary>
        /// 模块视图
        /// </summary>
        /// <param name="viewName"></param>
        /// <returns></returns>
        public DataTable GetViewsColumns(string viewName)
        {
            return aidePlatformManagerData.GetViewsColumns(viewName);
        }

        /// <summary>
        /// 代理商账号列表
        /// </summary>
        /// <param name="pageIndex"></param>
        /// <param name="pageSize"></param>
        /// <param name="condition"></param>
        /// <param name="orderby"></param>
        /// <returns></returns>
        public PagerSet GetSubAgentList(int pageIndex, int pageSize, string condition, string orderby)
        {
            return aidePlatformManagerData.GetSubAgentList(pageIndex, pageSize, condition, orderby);
        }

        public PagerSet GetSubAgentListEx(int pageIndex, int pageSize, Dictionary<string, object> conditions)
        {
            return aidePlatformManagerData.GetSubAgentListEx(pageIndex, pageSize, conditions);
        }

        public PagerSet GetSystemLog(int pageIndex, int pageSize, Dictionary<string, object> conditions)
        {
            return aidePlatformManagerData.GetSystemLog(pageIndex, pageSize, conditions);
        }

        public DataTable GetLogOperations()
        {
            return aidePlatformManagerData.GetLogOperations();
        }

        public bool IsAgent(int UserID)
        {
            return aidePlatformManagerData.IsAgent(UserID);
        }

        public int GetParentAgentID(int UserID)
        {
            return aidePlatformManagerData.GetParentAgentID(UserID);
        }

        public DataTable GetAgentsTree(int UserID, bool IsAgent)
        {
            return aidePlatformManagerData.GetAgentsTree(UserID, IsAgent);
        }

        public void AddUserSpreader(UserSpreader us)
        {
            aidePlatformManagerData.AddUserSpreader(us);
        }

        public int AddUser(Base_Users user)
        {
            return aidePlatformManagerData.AddUser(user);
        }

        public void UpdateUser(Base_Users user)
        {
            aidePlatformManagerData.UpdateUser(user);
        }

        public void UpdateUserByID(int UserID, Dictionary<string, object> KeyFields)
        {
            aidePlatformManagerData.UpdateUserByID(UserID, KeyFields);
        }

        public void UpdateUserBy(string condition, Dictionary<string, object> KeyFields)
        {
            aidePlatformManagerData.UpdateUserBy(condition, KeyFields);
        }

        public bool CheckUserPassword(int UserID, string pwd)
        {
            return aidePlatformManagerData.CheckUserPassword(UserID, pwd);
        }

        //public string DeleteUser(string ids)
        //{
        //    return aidePlatformManagerData.DeleteUser(UserID);
        //}

        //public DataTable GetUserSpreader()
        //{
        //    return aidePlatformManagerData.GetUserSpreader();
        //}

        public int GetSpreaderID()
        {
            return aidePlatformManagerData.GetSpreaderID();
        }

        public DataTable GetSpreaderID(int count)
        {
            return aidePlatformManagerData.GetSpreaderID(count);
        }

        public int UpdateSpreaderID(int UserID, string oldCode, string newCode)
        {
            return aidePlatformManagerData.UpdateSpreaderID(UserID, oldCode, newCode);
        }

        public PagerSet GetGamerListInfo(int pageIndex, int pageSize, Dictionary<string, object> conditions)
        {
            return aidePlatformManagerData.GetGamerListInfo(pageIndex, pageSize, conditions);
        }

        public PagerSet GetSubAgentListInfo(int pageIndex, int pageSize, Dictionary<string, object> conditions)
        {
            return aidePlatformManagerData.GetSubAgentListInfo(pageIndex, pageSize, conditions);
        }

        public void AddLog(int iOperator, int iOperation, string logContent, string loginIP, string module)
        {
            aidePlatformManagerData.AddLog(iOperator, iOperation, logContent, loginIP, module);
        }

        public DataTable GetAgent(int UserID)
        {
            return aidePlatformManagerData.GetAgent(UserID);
        }
        public string GetInitCodebyUserID(int UserID)
        {
            return aidePlatformManagerData.GetInitCodebyUserID(UserID);
        }

        public int ModifyUserPassword(int UserID, string oldPwd, string newPwd)
        {
            return aidePlatformManagerData.ModifyAdminPassword(UserID, oldPwd, newPwd);
        }

        public void ResetUserPassword(int UserID, string pwd)
        {
            aidePlatformManagerData.ResetUserPassword(UserID, pwd);
        }
        #endregion

        public void AddSpreaderOptions(Dictionary<string, object> keyValues)
        {
            aidePlatformManagerData.AddSpreaderOptions(keyValues);
        }

        public void SaveSpreaderOptions(DataTable dt)
        {
            aidePlatformManagerData.SaveSpreaderOptions(dt);
        }

        public void SaveAgentRevenesSet(DataTable dt)
        {
            aidePlatformManagerData.SaveAgentRevenesSet(dt);
        }

        public DataTable GetAgentSpreaderOptionBy(int RoleID, int GradeID)
        {
            return aidePlatformManagerData.GetAgentSpreaderOptionBy(RoleID, GradeID);
        }

        public DataTable GetAgentSpreaderOptions()
        {
            return aidePlatformManagerData.GetAgentSpreaderOptions();
        }

        public DataTable GetAgentRevenesSet()
        {
            return aidePlatformManagerData.GetAgentRevenesSet();
        }

        public DataSet GetGamerSpreadSumByDay(int UserID, string day)
        {
            return aidePlatformManagerData.GetGamerSpreadSumByDay(UserID, day);
        }

        public void AddSpreadSumEmail(string today)
        {
            aidePlatformManagerData.AddSpreadSumEmail(today);
        }

        public void AddAgentReveneSumEmail(string today)
        {
            aidePlatformManagerData.AddAgentReveneSumEmail(today);
        }

        public DataTable GetAgentGrades()
        {
            return aidePlatformManagerData.GetAgentGrades();
        }

        public DataTable GetAgentRoles(int AgentLevel)
        {
            return aidePlatformManagerData.GetAgentRoles(AgentLevel);
        }

        public int GetAgentLevel(int UserID)
        {
            return aidePlatformManagerData.GetAgentLevel(UserID);
        }

        public PagerSet GetSpreaderChildren(int pageIndex, int pageSize, Dictionary<string, object> conditions)
        {
            return aidePlatformManagerData.GetSpreaderChildren(pageIndex, pageSize, conditions);
        }

        public PagerSet GetSensitiveWordSet(string keyword, int pageIndex, int pageSize)
        {
            return aidePlatformManagerData.GetSensitiveWordSet(keyword, pageIndex, pageSize);
        }

        public void AddSensitiveWordSet(string sword)
        {
            aidePlatformManagerData.AddSensitiveWordSet(sword);
        }

        public void SaveSensitiveWordSet(int id, string sword)
        {
            aidePlatformManagerData.SaveSensitiveWordSet(id, sword);
        }

        public void DeleteSensitiveWordSet(string ids)
        {
            aidePlatformManagerData.DeleteSensitiveWordSet(ids);
        }
    }
}
