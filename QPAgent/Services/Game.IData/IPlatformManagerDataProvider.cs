using System.Collections.Generic;
using Game.Kernel;
using Game.Entity.PlatformManager;
using System.Data;

namespace Game.IData
{
    /// <summary>
    /// 后台数据层接口
    /// </summary>
    public interface IPlatformManagerDataProvider //: IProvider
    {

        #region 角色管理
        PagerSet GetDocList(int pageIndex, int pageSize, string condition, string orderby);
        docunmentinfo GetDocInfo(int docID);
        void InsertDoc(docunmentinfo doc);
        void UpdateDoc(docunmentinfo doc);
        void DeleteDoc(string sqlQuery);
        #endregion


        #region 管理员管理
        /// <summary>
        /// 管理员登录
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        Message UserLogon(Base_Users user);

        /// <summary>
        /// 添加管理员用户
        /// </summary>
        /// <param name="user"></param>
        void Register(Base_Users user);

        /// <summary>
        /// 删除用户
        /// </summary>
        /// <param name="userIDList"></param>
        void DeleteUser(string userIDList);

        /// <summary>
        /// 修改密码
        /// </summary>
        /// <param name="user"></param>
        /// <param name="newLogonPass"></param>
        void ModifyUserLogonPass(Base_Users user, string newLogonPass);

        /// <summary>
        /// 封停帐号
        /// </summary>
        /// <param name="userIDList"></param>
        /// <param name="nullity"></param>
        void ModifyUserNullity(string userIDList, bool nullity);

        /// <summary>
        /// 修改资料
        /// </summary>
        /// <param name="userExt"></param>
        void ModifyUserInfo(Base_Users user);

        /// <summary>
        /// 获取用户对象 by userName
        /// </summary>
        /// <param name="userName"></param>
        /// <returns></returns>
        Base_Users GetUserByAccounts(string userName);

        Base_Users GetUserByAccountsAndUserId(int uid, string userName);

        /// <summary>
        /// 获取用户对象 by userID
        /// </summary>
        /// <param name="userID"></param>
        /// <returns></returns>
        Base_Users GetUserByUserID(int userID);

        /// <summary>
        /// 获取用户列表 by roleID
        /// </summary>
        /// <param name="roleID"></param>
        /// <returns></returns>
        DataSet GetUserListByRoleID(int roleID);

        /// <summary>
        /// 获取用户列表
        /// </summary>
        /// <returns></returns>
        DataSet GetUserList();

        /// <summary>
        /// 获取用户列表
        /// </summary>
        /// <param name="pageIndex"></param>
        /// <param name="pageSize"></param>
        /// <param name="condition"></param>
        /// <param name="orderby"></param>
        /// <returns></returns>
        PagerSet GetUserList(int pageIndex, int pageSize, string condition, string orderby);
        #endregion

        #region 角色管理
        /// <summary>
        /// 获取角色列表
        /// </summary>
        /// <param name="pageIndex"></param>
        /// <param name="pageSize"></param>
        /// <param name="condition"></param>
        /// <param name="orderby"></param>
        /// <returns></returns>
        PagerSet GetRoleList(int pageIndex, int pageSize, string condition, string orderby);

        /// <summary>
        /// 获取角色实体
        /// </summary>
        /// <param name="roleID"></param>
        /// <returns></returns>
        Base_Roles GetRoleInfo(int roleID);

        /// <summary>
        /// 获得角色名称
        /// </summary>
        /// <param name="roleID"></param>
        /// <returns></returns>
        string GetRolenameByRoleID(int roleID);

        /// <summary>
        /// 新增角色
        /// </summary>
        /// <param name="role"></param>
        void InsertRole(Base_Roles role);

        /// <summary>
        /// 更新角色
        /// </summary>
        /// <param name="role"></param>
        void UpdateRole(Base_Roles role);

        /// <summary>
        /// 删除角色
        /// </summary>
        /// <param name="sqlQuery"></param>
        void DeleteRole(string sqlQuery);
        string DeleteRoleEx(string sqlQuery);
        #endregion

        #region 菜单管理
        DataSet GetDataSets(string sql);
        /// <summary>
        /// 获取菜单 by userID
        /// </summary>
        /// <param name="userID"></param>
        /// <returns></returns>
        DataSet GetMenuByUserID(int userID);
        void ExecuteMenu(string sql);
        /// <summary>
        /// 获取权限 by userID
        /// </summary>
        /// <param name="userID"></param>
        /// <returns></returns>
        DataSet GetPermissionByUserID(int userID);

        /// <summary>
        /// 获取父模块
        /// </summary>
        /// <returns></returns>
        DataSet GetModuleParentList();

        /// <summary>
        /// 获取子模块
        /// </summary>
        /// <param name="moduleID"></param>
        /// <returns></returns>
        DataSet GetModuleListByModuleID(int moduleID);

        /// <summary>
        /// 获取模块权限列表
        /// </summary>
        /// <param name="moduleID"></param>
        /// <returns></returns>
        DataSet GetModulePermissionList(int moduleID);

        /// <summary>
        /// 获取角色权限列表
        /// </summary>
        /// <param name="roleID"></param>
        /// <returns></returns>
        DataSet GetRolePermissionList(int roleID);

        /// <summary>
        /// 新增角色权限
        /// </summary>
        /// <param name="rolePermission"></param>
        void InsertRolePermission(Base_RolePermission rolePermission);

        /// <summary>
        /// 删除角色权限
        /// </summary>
        /// <param name="roleID"></param>
        void DeleteRolePermission(int roleID);

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
        PagerSet GetSystemSecurityList(int pageIndex, int pageSize, string condition, string orderby);
        #endregion
        #region 系统配置
        /// <summary>
        /// 获取系统配置信息
        /// </summary>
        /// <param name="siteID"></param>
        /// <returns></returns>
        QPAdminSiteInfo GetQPAdminSiteInfo(int siteID);
        /// <summary>
        /// 更新配置
        /// </summary>
        /// <param name="site"></param>
        void UpdateQPAdminSiteInfo(QPAdminSiteInfo site);
        #endregion

        #region 改版 2016-11-12
        /// <summary>
        /// 获取视图的字段名称
        /// </summary>
        /// <returns></returns>
        DataTable GetViewsColumns(string viewName);

        /// <summary>
        /// 子代理商列表
        /// </summary>
        /// <param name="pageIndex"></param>
        /// <param name="pageSize"></param>
        /// <param name="condition"></param>
        /// <param name="orderby"></param>
        /// <returns></returns>
        PagerSet GetSubAgentList(int pageIndex, int pageSize, string condition, string orderby);

        PagerSet GetSubAgentListEx(int pageIndex, int pageSize, Dictionary<string, object> conditions);

        /// <summary>
        /// 日志查询
        /// </summary>
        /// <param name="pageIndex"></param>
        /// <param name="pageSize"></param>
        /// <param name="condition"></param>
        /// <param name="orderby"></param>
        /// <returns></returns>
        PagerSet GetSystemLog(int pageIndex, int pageSize, Dictionary<string, object> conditions);

        /// <summary>
        /// 获取日志的操作类型
        /// </summary>
        /// <returns></returns>
        DataTable GetLogOperations();


        bool IsAgent(int UserID);
        int GetParentAgentID(int UserID);
        /// <summary>
        /// 代理商信息 左边树
        /// </summary>
        /// <returns></returns>
        DataTable GetAgentsTree(int UserID, bool IsAgent);

        void AddUserSpreader(UserSpreader us);
        void UpdateUserSpreader(UserSpreader us);

        /// <summary>
        /// 新增管理员
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        int AddUser(Base_Users user);

        /// <summary>
        /// 修改管理员
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        void UpdateUser(Base_Users user);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="UserID"></param>
        /// <param name="KeyFields"></param>
        /// <returns></returns>
        void UpdateUserByID(int UserID, Dictionary<string, object> KeyFields);
        void UpdateUserBy(string condition, Dictionary<string, object> KeyFields);
        bool CheckUserPassword(int UserID, string pwd);


        /// <summary>
        /// 获取邀请码列表
        /// </summary>
        /// <returns></returns>
        //DataTable GetUserSpreader();

        int GetSpreaderID();
        DataTable GetSpreaderID(int count);

        int UpdateSpreaderID(int UserID, string oldCode, string newCode);

        /// <summary>
        /// 玩家
        /// </summary>
        /// <returns></returns>
        PagerSet GetGamerListInfo(int pageIndex, int pageSize, Dictionary<string, object> conditions);

        /// <summary>
        /// 子代理
        /// </summary>
        /// <returns></returns>
        PagerSet GetSubAgentListInfo(int pageIndex, int pageSize, Dictionary<string, object> conditions);

        void AddLog(int iOperator, int iOperation, string logContent, string loginIP, string module);

        DataTable GetAgent(int UserID);

        string GetInitCodebyUserID(int UserID);

        int ModifyAdminPassword(int UserID, string oldPwd, string newPwd);
        void ResetUserPassword(int UserID, string pwd);
        #endregion

        void AddSpreaderOptions(Dictionary<string, object> keyValues);

        void SaveSpreaderOptions(DataTable dt);

        void SaveAgentRevenesSet(DataTable dt);

        DataTable GetAgentSpreaderOptionBy(int RoleID, int GradeID);

        DataTable GetAgentSpreaderOptions();

        DataTable GetAgentRevenesSet();

        DataSet GetGamerSpreadSumByDay(int UserID, string day);

        void AddSpreadSumEmail(string today);

        void AddAgentReveneSumEmail(string today);

        DataTable GetAgentGrades();

        DataTable GetAgentRoles(int AgentLevel);

        int GetAgentLevel(int UserID);

        PagerSet GetSpreaderChildren(int pageIndex, int pageSize, Dictionary<string, object> conditions);

        PagerSet GetSensitiveWordSet(string keyword, int pageIndex, int pageSize);

        void AddSensitiveWordSet(string sword);
        void DeleteSensitiveWordSet(string ids);
        void SaveSensitiveWordSet(int id, string sword);
    }

}
