using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Kernel;
using Game.IData;
using Game.Entity.PlatformManager;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;

namespace Game.Data
{
    /// <summary>
    /// 后台数据层
    /// </summary>
    public class PlatformManagerDataProvider : BaseDataProvider, IPlatformManagerDataProvider
    {
        #region Fields
        private ITableProvider aideUserProvider;
        private ITableProvider aideRoleProvider;
        private ITableProvider aideDocProvider;
        private ITableProvider aideRolePermissionProvider;
        private ITableProvider aideQPAdminSiteInfoProvider;

        //2016-11-18 20:00
        private ITableProvider aideUSProvider;
        #endregion

        #region 构造方法
        /// <summary>
        /// 构造函数
        /// </summary>
        public PlatformManagerDataProvider(string connString)
            : base(connString)
        {
            aideUserProvider = GetTableProvider(Base_Users.Tablename);
            aideRoleProvider = GetTableProvider(Base_Roles.Tablename);
            aideRolePermissionProvider = GetTableProvider(Base_RolePermission.Tablename);
            aideQPAdminSiteInfoProvider = GetTableProvider(QPAdminSiteInfo.Tablename);
            aideDocProvider = GetTableProvider(docunmentinfo.Tablename);

            //2016-11-18 20:00
            aideUSProvider = GetTableProvider(UserSpreader.Tablename);
        }
        #endregion


        #region Doc
        public PagerSet GetDocList(int pageIndex, int pageSize, string condition, string orderby)
        {
            PagerParameters pagerPrams = new PagerParameters(docunmentinfo.Tablename, orderby, condition, pageIndex, pageSize);

            return GetPagerSet2(pagerPrams);
        }
        public docunmentinfo GetDocInfo(int docID)
        {
            string sqlQuery = string.Format("(NOLOCK) WHERE RoleID= {0}", docID);
            docunmentinfo doc = aideRoleProvider.GetObject<docunmentinfo>(sqlQuery);
            return doc;
        }
        public void InsertDoc(docunmentinfo doc)
        {
            StringBuilder sqlQuery = new StringBuilder();
            sqlQuery.Append("INSERT INTO docunmentinfo(docname,docowner,docpath,docsize,docstate,doctime,doctype,docuserid,docnote) values(")
                    .Append("@docname ,")
                    .Append("@docowner ,")
                    .Append("@docpath ,")
                    .Append("@docsize ,")
                    .Append("@docstate ,")
                    .Append("@doctime ,")
                    .Append("@doctype ,")
                    .Append("@docuserid ,")
                    .Append("@docnote ")
                    .Append(")");
            var prams = new List<DbParameter>();
            prams.Add(Database.MakeInParam("docname", doc.docname));
            prams.Add(Database.MakeInParam("docowner", doc.docowner));
            prams.Add(Database.MakeInParam("docpath", doc.docpath));
            prams.Add(Database.MakeInParam("docsize", doc.docsize));
            prams.Add(Database.MakeInParam("docstate", doc.docstate));
            prams.Add(Database.MakeInParam("doctime", doc.doctime));
            prams.Add(Database.MakeInParam("doctype", doc.doctype));
            prams.Add(Database.MakeInParam("docuserid", doc.docuserid));
            prams.Add(Database.MakeInParam("docnote", doc.docnote));
            Database.ExecuteNonQuery(CommandType.Text, sqlQuery.ToString(), prams.ToArray());

        }
        public void UpdateDoc(docunmentinfo doc)
        {
            StringBuilder sqlQuery = new StringBuilder();
            sqlQuery.Append("UPDATE docunmentinfo SET ")
                    .Append("docname=@docname ,")
                    .Append("docowner=@docowner ,")
                    .Append("docpath=@docpath ,")
                    .Append("docsize=@docsize ,")
                    .Append("docstate=@docstate ,")
                    .Append("doctime=@doctime ,")
                    .Append("doctype=@doctype ,")
                    .Append("docuserid=@docuserid ,")
                    .Append("docnote=@docnote ")
                    .Append("WHERE RoleID= @RoleID");
            var prams = new List<DbParameter>();
            prams.Add(Database.MakeInParam("docname", doc.docname));
            prams.Add(Database.MakeInParam("docowner", doc.docowner));
            prams.Add(Database.MakeInParam("docpath", doc.docpath));
            prams.Add(Database.MakeInParam("docsize", doc.docsize));
            prams.Add(Database.MakeInParam("docstate", doc.docstate));
            prams.Add(Database.MakeInParam("doctime", doc.doctime));
            prams.Add(Database.MakeInParam("doctype", doc.doctype));
            prams.Add(Database.MakeInParam("docuserid", doc.docuserid));
            prams.Add(Database.MakeInParam("docnote", doc.docnote));
            prams.Add(Database.MakeInParam("docid", doc.docid));
            Database.ExecuteNonQuery(CommandType.Text, sqlQuery.ToString(), prams.ToArray());
        }
        public void DeleteDoc(string sqlQuery)
        {
            aideDocProvider.Delete(sqlQuery);
        }
        #endregion


        #region 管理员管理
        /// <summary>
        /// 管理员登录
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        public Message UserLogon(Base_Users user)
        {
            var prams = new List<DbParameter>();
            prams.Add(Database.MakeInParam("strUserName", user.Username));
            prams.Add(Database.MakeInParam("strPassword", user.Password));
            prams.Add(Database.MakeInParam("strClientIP", user.LastLoginIP));
            prams.Add(Database.MakeOutParam("strErrorDescribe", typeof(string), 127));

            Message msg = MessageHelper.GetMessageForObject<Base_Users>(Database, "NET_PM_UserLogon", prams);
            return msg;
        }

        /// <summary>
        /// 添加管理员用户
        /// </summary>
        /// <param name="user"></param>
        public void Register(Base_Users user)
        {
            DataRow dr = aideUserProvider.NewRow();

            dr[Base_Users._Username] = user.Username;
            dr[Base_Users._Password] = user.Password;
            dr[Base_Users._RoleID] = user.RoleID;
            dr[Base_Users._Nullity] = user.Nullity;
            dr[Base_Users._PreLoginIP] = user.PreLoginIP;
            dr[Base_Users._PreLogintime] = user.PreLogintime;
            dr[Base_Users._LastLoginIP] = user.LastLoginIP;
            dr[Base_Users._LastLogintime] = user.LastLogintime;
            dr[Base_Users._LoginTimes] = user.LoginTimes;
            dr[Base_Users._IsBand] = user.IsBand;
            dr[Base_Users._BandIP] = user.BandIP;
            dr[Base_Users._AgentLevel] = user.AgentLevel;
            dr[Base_Users._canHasSubAgent] = user.canHasSubAgent;
            dr[Base_Users._AgentLevelLimit] = user.AgentLevelLimit;
            aideUserProvider.Insert(dr);
        }

        /// <summary>
        /// 删除用户
        /// </summary>
        /// <param name="userIDList"></param>
        public void DeleteUser(string userIDList)
        {
            aideUserProvider.Delete(string.Format("WHERE UserID in ({0})", userIDList));
        }

        /// <summary>
        /// 修改密码
        /// </summary>
        /// <param name="user"></param>
        /// <param name="newLogonPass"></param>
        public void ModifyUserLogonPass(Base_Users user, string newLogonPass)
        {
            string sqlQuery = "UPDATE Base_Users SET Password = @Password WHERE UserID= @UserID";

            var prams = new List<DbParameter>();
            prams.Add(Database.MakeInParam("UserID", user.UserID));
            prams.Add(Database.MakeInParam("Password", newLogonPass));

            Database.ExecuteNonQuery(CommandType.Text, sqlQuery, prams.ToArray());
        }

        /// <summary>
        /// 封停帐号
        /// </summary>
        /// <param name="userIDList"></param>
        /// <param name="nullity"></param>
        public void ModifyUserNullity(string userIDList, bool nullity)
        {
            string sqlQuery = string.Format("UPDATE Base_Users SET Nullity = @Nullity WHERE UserID IN ({0})", userIDList);

            var prams = new List<DbParameter>();
            prams.Add(Database.MakeInParam("Nullity", nullity));

            Database.ExecuteNonQuery(CommandType.Text, sqlQuery, prams.ToArray());
        }

        /// <summary>
        /// 修改资料
        /// </summary>
        /// <param name="userExt"></param>
        public void ModifyUserInfo(Base_Users user)
        {
            var parms = new List<DbParameter>();
            parms.Add(Database.MakeInParam("UserName", user.Username));
            parms.Add(Database.MakeInParam("Nullity", user.Nullity));
            parms.Add(Database.MakeInParam("canHasSubAgent", user.canHasSubAgent));
            parms.Add(Database.MakeInParam("RoleID", user.RoleID));
            parms.Add(Database.MakeInParam("GradeID", user.GradeID));
            parms.Add(Database.MakeInParam("AgentLevelLimit", user.AgentLevelLimit));
            parms.Add(Database.MakeInParam("Percentage", user.Percentage));
            parms.Add(Database.MakeInParam("UserID", user.UserID));

            Database.RunProc("p_ModifyBaseUser_ByID", parms);
        }

        /// <summary>
        /// 获取用户对象 by userName
        /// </summary>
        /// <param name="accounts"></param>
        /// <returns></returns>
        public Base_Users GetUserByAccounts(string userName)
        {
            string sqlQuery = string.Format("(NOLOCK) WHERE UserName= N'{0}'", userName);
            Base_Users user = aideUserProvider.GetObject<Base_Users>(sqlQuery);
            return user;
        }


        public Base_Users GetUserByAccountsAndUserId(int uid, string userName)
        {
            string sqlQuery = string.Format("(NOLOCK) WHERE UserName= N'{0}' and UserID !='" + uid + "'", userName);
            Base_Users user = aideUserProvider.GetObject<Base_Users>(sqlQuery);
            return user;
        }

        /// <summary>
        /// 获取用户对象 by userID
        /// </summary>
        /// <param name="userID"></param>
        /// <returns></returns>
        public Base_Users GetUserByUserID(int userID)
        {
            string sqlQuery = string.Format("(NOLOCK) WHERE UserID={0}", userID);
            Base_Users user = aideUserProvider.GetObject<Base_Users>(sqlQuery);
            return user;
        }

        /// <summary>
        /// 获取用户列表 by roleID
        /// </summary>
        /// <param name="roleID"></param>
        /// <returns></returns>
        public DataSet GetUserListByRoleID(int roleID)
        {
            return aideUserProvider.Get(string.Format("(NOLOCK) WHERE RoleID={0}", roleID));
        }

        /// <summary>
        /// 获取用户列表
        /// </summary>
        /// <returns></returns>
        public DataSet GetUserList()
        {
            StringBuilder sqlQuery = new StringBuilder();
            sqlQuery.AppendFormat(@"SELECT UserID, RoleID")
            .AppendFormat(@"      ,Rolename=")
            .AppendFormat(@"         CASE UserID")
            .AppendFormat(@"             WHEN 1 THEN N'超级管理员'")
            .AppendFormat(@"             ELSE (SELECT RoleName FROM Base_Roles(NOLOCK) WHERE RoleID=u.RoleID)")
            .AppendFormat(@"         END")
            .AppendFormat(@"      ,UserName,PreLogintime,PreLoginIP,LastLogintime,LastLoginIP")
            .AppendFormat(@"      ,LoginTimes,IsBand,BandIP")
            .AppendFormat(@"  FROM Base_Users(NOLOCK) AS u")
            .Append(@" WHERE UserID>1");

            return Database.ExecuteDataset(sqlQuery.ToString());
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
            PagerParameters pagerPrams = new PagerParameters(vw_Base_Users.Tablename, orderby, condition, pageIndex, pageSize);
            return GetPagerSet2(pagerPrams);
        }
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
        public PagerSet GetRoleList(int pageIndex, int pageSize, string condition, string orderby)
        {
            PagerParameters pagerPrams = new PagerParameters(Base_Roles.Tablename, orderby, condition, pageIndex, pageSize);

            return GetPagerSet2(pagerPrams);
        }

        /// <summary>
        /// 获取角色实体
        /// </summary>
        /// <param name="roleID"></param>
        /// <returns></returns>
        public Base_Roles GetRoleInfo(int roleID)
        {
            string sqlQuery = string.Format("(NOLOCK) WHERE RoleID= {0}", roleID);
            Base_Roles role = aideRoleProvider.GetObject<Base_Roles>(sqlQuery);
            return role;
        }

        /// <summary>
        /// 获得角色名称
        /// </summary>
        /// <param name="roleID"></param>
        /// <returns></returns>
        public string GetRolenameByRoleID(int roleID)
        {
            string sqlQuery = string.Format("(NOLOCK) WHERE RoleID={0}", roleID);
            Base_Roles userRolesInfo = aideRoleProvider.GetObject<Base_Roles>(sqlQuery);
            if (userRolesInfo == null)
                return "";
            return userRolesInfo.RoleName;
        }

        /// <summary>
        /// 新增角色
        /// </summary>
        /// <param name="role"></param>
        public void InsertRole(Base_Roles role)
        {
            DataRow dr = aideRoleProvider.NewRow();

            dr[Base_Roles._RoleID] = role.RoleID;
            dr[Base_Roles._RoleName] = role.RoleName;
            dr[Base_Roles._Description] = role.Description;
            //dr[Base_Roles._AgentLevel] = role.AgentLevel;
            dr[Base_Roles._Operator] = role.Operator;
            dr[Base_Roles._Created] = role.Created;
            dr[Base_Roles._Modified] = role.Modified;

            aideRoleProvider.Insert(dr);
        }

        /// <summary>
        /// 更新角色
        /// </summary>
        /// <param name="role"></param>
        public void UpdateRole(Base_Roles role)
        {
            StringBuilder sqlQuery = new StringBuilder();
            sqlQuery.Append("UPDATE Base_Roles SET ")
                    .Append("RoleName=@RoleName,")
                    .Append("Description=@Description,")
                    .Append("Operator=@Operator,")
                    .Append("Modified=@Modified")
                    .Append(" WHERE RoleID= @RoleID");

            var prams = new List<DbParameter>();
            prams.Add(Database.MakeInParam("RoleName", role.RoleName));
            prams.Add(Database.MakeInParam("Description", role.Description));
            prams.Add(Database.MakeInParam("Operator", role.Operator));
            prams.Add(Database.MakeInParam("Modified", role.Modified));
            prams.Add(Database.MakeInParam("RoleID", role.RoleID));
            Database.ExecuteNonQuery(CommandType.Text, sqlQuery.ToString(), prams.ToArray());
        }

        /// <summary>
        /// 删除角色
        /// </summary>
        /// <param name="sqlQuery"></param>
        public void DeleteRole(string sqlQuery)
        {
            aideRoleProvider.Delete(sqlQuery);
        }
        /// <summary>
        /// 删除角色
        /// </summary>
        /// <param name="sqlQuery"></param>
        public string DeleteRoleEx(string rIds)
        {
            StringBuilder sb = new StringBuilder();
            sb.AppendLine("SELECT DISTINCT u.RoleID,r.RoleName FROM dbo.Base_Users u INNER JOIN dbo.Base_Roles r ON u.RoleID=r.RoleID  WHERE u.RoleID IN (" + rIds + ")");
            DataTable dt = Database.ExecuteDataset(sb.ToString()).Tables[0];
            string ids = "";
            foreach (DataRow dr in dt.Rows)
            {
                ids += "[" + dr["RoleID"].ToString() + "]" + dr["RoleName"] + ",";
            }
            if (ids != "") return ids.Trim().Trim(',');

            aideRoleProvider.Delete(" WHERE RoleID IN (" + rIds + ")");
            return "success";
        }
        #endregion

        #region 菜单列表
        public DataSet GetDataSets(string sql)
        {
            return Database.ExecuteDataset(sql);
        }
        /// <summary>
        /// 获取菜单 by userID
        /// </summary>
        /// <param name="userID"></param>
        /// <returns></returns>
        public DataSet GetMenuByUserID(int userID)
        {
            var prams = new List<DbParameter>();
            prams.Add(Database.MakeInParam("dwUserID", userID));

            DataSet ds;
            Database.RunProc("NET_PM_GetMenuByUserID", prams, out ds);
            return ds;
        }
        public void ExecuteMenu(string sql)
        {
            Database.ExecuteNonQuery(sql);
        }
        /// <summary>
        /// 获取权限 by userID
        /// </summary>
        /// <param name="userID"></param>
        /// <returns></returns>
        public DataSet GetPermissionByUserID(int userID)
        {
            var prams = new List<DbParameter>();
            prams.Add(Database.MakeInParam("dwUserID", userID));

            DataSet ds;
            Database.RunProc("NET_PM_GetPermissionByUserID", prams, out ds);
            return ds;
        }

        /// <summary>
        /// 获取父模块
        /// </summary>
        /// <returns></returns>
        public DataSet GetModuleParentList()
        {
            string sqlQuery = "SELECT * FROM Base_Module WHERE ParentID=0 ORDER BY OrderNo";

            return Database.ExecuteDataset(CommandType.Text, sqlQuery);
        }

        /// <summary>
        /// 获取子模块
        /// </summary>
        /// <param name="moduleID"></param>
        /// <returns></returns>
        public DataSet GetModuleListByModuleID(int moduleID)
        {
            string sqlQuery = string.Format("SELECT * FROM Base_Module WHERE ParentID={0} ORDER BY OrderNo", moduleID);

            return Database.ExecuteDataset(CommandType.Text, sqlQuery);
        }

        /// <summary>
        /// 获取模块权限列表
        /// </summary>
        /// <param name="moduleID"></param>
        /// <returns></returns>
        public DataSet GetModulePermissionList(int moduleID)
        {
            string sqlQuery = string.Format("SELECT * FROM Base_ModulePermission WHERE ModuleID={0}", moduleID);

            return Database.ExecuteDataset(CommandType.Text, sqlQuery);
        }

        /// <summary>
        /// 获取角色权限列表
        /// </summary>
        /// <param name="roleID"></param>
        /// <returns></returns>
        public DataSet GetRolePermissionList(int roleID)
        {
            string sqlQuery = string.Format("SELECT * FROM Base_RolePermission WHERE RoleID={0}", roleID);

            return Database.ExecuteDataset(CommandType.Text, sqlQuery);
        }

        /// <summary>
        /// 新增角色权限
        /// </summary>
        /// <param name="rolePermission"></param>
        public void InsertRolePermission(Base_RolePermission rolePermission)
        {
            DataRow dr = aideRolePermissionProvider.NewRow();

            dr[Base_RolePermission._RoleID] = rolePermission.RoleID;
            dr[Base_RolePermission._ModuleID] = rolePermission.ModuleID;
            dr[Base_RolePermission._ManagerPermission] = rolePermission.ManagerPermission;
            dr[Base_RolePermission._OperationPermission] = rolePermission.OperationPermission;
            dr[Base_RolePermission._StateFlag] = rolePermission.StateFlag;

            aideRolePermissionProvider.Insert(dr);
        }

        /// <summary>
        /// 删除角色权限
        /// </summary>
        /// <param name="roleID"></param>
        public void DeleteRolePermission(int roleID)
        {
            aideRolePermissionProvider.Delete(string.Format("WHERE RoleID = ({0})", roleID));
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
            PagerParameters pagerPrams = new PagerParameters(SystemSecurity.Tablename, orderby, condition, pageIndex, pageSize);

            return GetPagerSet2(pagerPrams);
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
            string sqlQuery = string.Format("(NOLOCK) WHERE SiteID= {0}", siteID);
            QPAdminSiteInfo site = aideQPAdminSiteInfoProvider.GetObject<QPAdminSiteInfo>(sqlQuery);
            return site;
        }
        /// <summary>
        /// 更新配置
        /// </summary>
        /// <param name="site"></param>
        public void UpdateQPAdminSiteInfo(QPAdminSiteInfo site)
        {
            StringBuilder sqlQuery = new StringBuilder();
            sqlQuery.Append("UPDATE QPAdminSiteInfo SET ")
                    .Append("SiteName=@SiteName ,")
                    .Append("PageSize=@PageSize ,")
                    .Append("LoginLogo=@LoginLogo ,")
                    .Append("WaterMark=@WaterMark ,")
                    .Append("SmtpServer=@SmtpServer ,")
                    .Append("SendEmailUser=@SendEmailUser ,")
                    .Append("SendEmailPwd=@SendEmailPwd ,")
                    .Append("minTradeScore=@minTradeScore ,")
                    .Append("registerlink=@registerlink ,")
                    .Append("generalAgent=@generalAgent ,")
                    .Append("CopyRight=@CopyRight ")
                    .Append("WHERE SiteID= @SiteID");

            var prams = new List<DbParameter>();
            prams.Add(Database.MakeInParam("SiteName", site.SiteName));
            prams.Add(Database.MakeInParam("PageSize", site.PageSize));
            prams.Add(Database.MakeInParam("CopyRight", site.CopyRight));
            prams.Add(Database.MakeInParam("WaterMark", site.WaterMark));
            prams.Add(Database.MakeInParam("LoginLogo", site.LoginLogo));
            prams.Add(Database.MakeInParam("SmtpServer", site.SmtpServer));
            prams.Add(Database.MakeInParam("SendEmailUser", site.SendEmailUser));
            prams.Add(Database.MakeInParam("SendEmailPwd", site.SendEmailPwd));
            prams.Add(Database.MakeInParam("minTradeScore", site.minTradeScore));
            prams.Add(Database.MakeInParam("registerlink", site.registerlink));
            prams.Add(Database.MakeInParam("generalAgent", site.generalAgent));
            prams.Add(Database.MakeInParam("SiteID", site.SiteID));
            Database.ExecuteNonQuery(CommandType.Text, sqlQuery.ToString(), prams.ToArray());
        }
        #endregion

        #region 新增功能 2016-11-14
        /// <summary>
        /// 视图字段名
        /// </summary>
        /// <param name="viewName"></param>
        /// <returns></returns>
        public DataTable GetViewsColumns(string viewName)
        {
            StringBuilder sb = new StringBuilder();
            sb.AppendLine("SELECT * FROM dbo.ViewsColumns WHERE ViewName='" + viewName + "'");
            DataSet ds = Database.ExecuteDataset(sb.ToString());
            if (ds == null || ds.Tables.Count == 0) return null;
            return ds.Tables[0];
        }

        /// <summary>
        /// 子代理商列表
        /// </summary>
        /// <param name="UserID"></param>
        /// <returns></returns>
        public PagerSet GetSubAgentList(int pageIndex, int pageSize, string condition, string orderby)
        {
            PagerParameters pagerPrams = new PagerParameters(vw_SubAgentList.Tablename, orderby, condition, pageIndex, pageSize);
            return GetPagerSet2(pagerPrams);
        }

        public PagerSet GetSubAgentListEx(int pageIndex, int pageSize, Dictionary<string, object> conditions)
        {
            var prams = new List<DbParameter>();
            prams.Add(Database.MakeInParam("pageIndex", pageIndex));
            prams.Add(Database.MakeInParam("pageSize", pageSize));
            foreach (var item in conditions)
            {
                prams.Add(Database.MakeInParam(item.Key, item.Value));
            }

            DataSet ds;
            Database.RunProc("p_GetpSubAgentList", prams, out ds);
            int totalCount = Convert.ToInt32(ds.Tables[0].Rows[0]["totalCount"]);
            int totalPage = (int)Math.Ceiling((double)totalCount / pageSize);
            PagerSet pageSet = new PagerSet(pageIndex, pageSize, totalPage, totalCount, ds);
            return pageSet;
        }

        /// <summary>
        /// 日志查询
        /// </summary>
        /// <param name="pageIndex"></param>
        /// <param name="pageSize"></param>
        /// <param name="condition"></param>
        /// <param name="orderby"></param>
        /// <returns></returns>
        public PagerSet GetSystemLog(int pageIndex, int pageSize, Dictionary<string, object> conditions)
        {
            var prams = new List<DbParameter>();
            prams.Add(Database.MakeInParam("pageIndex", pageIndex));
            prams.Add(Database.MakeInParam("pageSize", pageSize));
            foreach (var item in conditions)
            {
                prams.Add(Database.MakeInParam(item.Key, item.Value));
            }

            DataSet ds;
            Database.RunProc("p_GetSystemLog", prams, out ds);
            int totalCount = Convert.ToInt32(ds.Tables[0].Rows[0]["totalCount"]);
            int totalPage = (int)Math.Ceiling((double)totalCount / pageSize);
            PagerSet pageSet = new PagerSet(pageIndex, pageSize, totalPage, totalCount, ds);
            return pageSet;
        }

        public DataTable GetLogOperations()
        {
            StringBuilder sb = new StringBuilder();
            sb.AppendLine("SELECT * FROM dbo.SystemLogOperation");
            DataSet ds = Database.ExecuteDataset(sb.ToString());
            if (ds == null || ds.Tables.Count == 0) return null;
            return ds.Tables[0];
        }

        public bool IsAgent(int UserID)
        {
            StringBuilder sb = new StringBuilder();
            sb.Length = 0;
            sb.AppendLine("SELECT 1 FROM QPAccountsDB.dbo.AccountsInfo a INNER JOIN dbo.Base_Users b ON a.UserID=b.AgentID WHERE a.IsAgent=1 AND b.UserID=" + UserID);
            object o = Database.ExecuteScalar(CommandType.Text, sb.ToString());
            if (o != null && o.ToString() == "1")
            {
                return true;
            }
            return false;
        }

        public int GetParentAgentID(int UserID)
        {
            StringBuilder sb = new StringBuilder();
            sb.Length = 0;
            sb.AppendLine("SELECT a.AgentID FROM QPAccountsDB.dbo.AccountsInfo a INNER JOIN dbo.Base_Users b ON a.UserID=b.AgentID WHERE a.IsAgent=1 AND b.UserID=" + UserID);
            object o = Database.ExecuteScalar(CommandType.Text, sb.ToString());
            if (o == null || o == DBNull.Value)
                return -1;
            return Convert.ToInt32(o);
        }

        public DataTable GetAgentsTree(int UserID, bool IsAgent)
        {
            var prams = new List<DbParameter>();
            prams.Add(Database.MakeInParam("UserID", UserID));
            prams.Add(Database.MakeInParam("IsAgent", IsAgent ? 1 : 0));
            DataSet ds;
            Database.RunProc("p_GetAgentsTree", prams, out ds);
            return ds.Tables[0];
        }

        public void AddUserSpreader(UserSpreader us)
        {
            DataRow dr = aideUSProvider.NewRow();

            dr[UserSpreader._Created] = us.Created;
            dr[UserSpreader._Creator] = us.Creator;
            dr[UserSpreader._Modified] = us.Modified;
            dr[UserSpreader._Modifior] = us.Modifior;
            dr[UserSpreader._SpreaderID] = us.SpreaderID;
            dr[UserSpreader._UserID] = us.UserID;

            aideUSProvider.Insert(dr);
        }

        public void UpdateUserSpreader(UserSpreader us)
        {
            StringBuilder sqlQuery = new StringBuilder();
            sqlQuery.Append("UPDATE dbo." + UserSpreader.Tablename + " SET ")
                    .Append("[" + UserSpreader._SpreaderID + "]" + "= @" + UserSpreader._SpreaderID + ",")
                    .Append("[" + UserSpreader._Modified + "]" + "= @" + UserSpreader._Modified + ",")
                    .Append("[" + UserSpreader._Modifior + "]" + "= @" + UserSpreader._Modifior)
                    .Append("WHERE " + "[" + UserSpreader._UserID + "]" + "= @" + UserSpreader._UserID);

            var prams = new List<DbParameter>();
            prams.Add(Database.MakeInParam(UserSpreader._SpreaderID, us.SpreaderID));
            prams.Add(Database.MakeInParam(UserSpreader._Modified, us.Modified));
            prams.Add(Database.MakeInParam(UserSpreader._Modifior, us.Modifior));
            prams.Add(Database.MakeInParam(UserSpreader._UserID, us.UserID));
            Database.ExecuteNonQuery(CommandType.Text, sqlQuery.ToString(), prams.ToArray());
        }

        /// <summary>
        /// 新增管理员
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        public int AddUser(Base_Users user)
        {
            try
            {
                var prams = new List<DbParameter>();
                prams.Add(Database.MakeInParam(Base_Users._Username, user.Username));
                prams.Add(Database.MakeInParam(Base_Users._Password, user.Password));
                prams.Add(Database.MakeInParam(Base_Users._RoleID, user.RoleID));
                prams.Add(Database.MakeInParam(Base_Users._Nullity, user.Nullity));
                prams.Add(Database.MakeInParam(Base_Users._PreLoginIP, user.PreLoginIP));
                prams.Add(Database.MakeInParam(Base_Users._PreLogintime, user.PreLogintime));
                prams.Add(Database.MakeInParam(Base_Users._LastLoginIP, user.LastLoginIP));
                prams.Add(Database.MakeInParam(Base_Users._LastLogintime, user.LastLogintime));
                prams.Add(Database.MakeInParam(Base_Users._LoginTimes, user.LoginTimes));
                prams.Add(Database.MakeInParam(Base_Users._IsBand, user.IsBand));
                prams.Add(Database.MakeInParam(Base_Users._BandIP, user.BandIP));
                //prams.Add(Database.MakeInParam(Base_Users._AgentLevel, user.AgentLevel));
                prams.Add(Database.MakeInParam(Base_Users._canHasSubAgent, user.canHasSubAgent));
                prams.Add(Database.MakeInParam(Base_Users._AgentLevelLimit, user.AgentLevelLimit));
                StringBuilder sb = new StringBuilder();
                sb.Append("INSERT " + Base_Users.Tablename + "(");
                sb.Append("[" + Base_Users._Username + "]" + ",[" + Base_Users._Password + "],");
                sb.Append("[" + Base_Users._RoleID + "]" + ",[" + Base_Users._Nullity + "],");
                sb.Append("[" + Base_Users._PreLoginIP + "]" + ",[" + Base_Users._PreLogintime + "],");
                sb.Append("[" + Base_Users._LastLoginIP + "]" + ",[" + Base_Users._LastLogintime + "],");
                sb.Append("[" + Base_Users._LoginTimes + "]" + ",[" + Base_Users._IsBand + "],");
                sb.Append("[" + Base_Users._BandIP + "],");
                sb.AppendFormat("[" + Base_Users._canHasSubAgent + "]" + ",[" + Base_Users._AgentLevelLimit + "])\n");
                sb.Append("VALUES(@" + Base_Users._Username + "," + "@" + Base_Users._Password + ",");
                sb.Append("@" + Base_Users._RoleID + "," + "@" + Base_Users._Nullity + ",");
                sb.Append("@" + Base_Users._PreLoginIP + "," + "@" + Base_Users._PreLogintime + ",");
                sb.Append("@" + Base_Users._LastLoginIP + "," + "@" + Base_Users._LastLogintime + ",");
                sb.Append("@" + Base_Users._LoginTimes + "," + "@" + Base_Users._IsBand + ",");
                sb.Append("@" + Base_Users._BandIP + ",");
                sb.Append("@" + Base_Users._canHasSubAgent + "," + "@" + Base_Users._AgentLevelLimit + ")");
                sb.AppendFormat("\n");
                int id;
                Database.ExecuteNonQuery2(out id, CommandType.Text, sb.ToString(), prams.ToArray());
                return id;
            }
            catch (Exception)
            {
                return -1;
            }
        }

        /// <summary>
        /// 修改管理员
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        public void UpdateUser(Base_Users user)
        {
            var prams = new List<DbParameter>();
            prams.Add(Database.MakeInParam(Base_Users._UserID, user.UserID));
            prams.Add(Database.MakeInParam(Base_Users._Username, user.Username));
            prams.Add(Database.MakeInParam(Base_Users._Password, user.Password));
            prams.Add(Database.MakeInParam(Base_Users._RoleID, user.RoleID));
            prams.Add(Database.MakeInParam(Base_Users._Nullity, user.Nullity));
            prams.Add(Database.MakeInParam(Base_Users._PreLoginIP, user.PreLoginIP));
            prams.Add(Database.MakeInParam(Base_Users._PreLogintime, user.PreLogintime));
            prams.Add(Database.MakeInParam(Base_Users._LastLoginIP, user.LastLoginIP));
            prams.Add(Database.MakeInParam(Base_Users._LastLogintime, user.LastLogintime));
            prams.Add(Database.MakeInParam(Base_Users._LoginTimes, user.LoginTimes));
            prams.Add(Database.MakeInParam(Base_Users._IsBand, user.IsBand));
            prams.Add(Database.MakeInParam(Base_Users._BandIP, user.BandIP));
            prams.Add(Database.MakeInParam(Base_Users._AgentLevel, user.AgentLevel));
            prams.Add(Database.MakeInParam(Base_Users._canHasSubAgent, user.canHasSubAgent));
            prams.Add(Database.MakeInParam(Base_Users._AgentLevelLimit, user.AgentLevelLimit));
            StringBuilder sb = new StringBuilder();
            sb.AppendLine("UPDATE dbo." + Base_Users.Tablename);
            sb.AppendLine("SET " + Base_Users._Username + "=@" + Base_Users._Username + ",");
            sb.AppendLine("[" + Base_Users._Password + "]" + "=@" + Base_Users._Password + ",");
            sb.AppendLine("[" + Base_Users._RoleID + "]" + "=@" + Base_Users._RoleID + ",");
            sb.AppendLine("[" + Base_Users._Nullity + "]" + "=@" + Base_Users._Nullity + ",");
            sb.AppendLine("[" + Base_Users._PreLoginIP + "]" + "=@" + Base_Users._PreLoginIP + ",");
            sb.AppendLine("[" + Base_Users._PreLogintime + "]" + "=@" + Base_Users._PreLogintime + ",");
            sb.AppendLine("[" + Base_Users._LastLoginIP + "]" + "=@" + Base_Users._LastLoginIP + ",");
            sb.AppendLine("[" + Base_Users._LastLogintime + "]" + "=@" + Base_Users._LastLogintime + ",");
            sb.AppendLine("[" + Base_Users._LoginTimes + "]" + "=@" + Base_Users._LoginTimes + ",");
            sb.AppendLine("[" + Base_Users._IsBand + "]" + "=@" + Base_Users._IsBand + ",");
            sb.AppendLine("[" + Base_Users._BandIP + "]" + "=@" + Base_Users._BandIP + ",");
            sb.AppendLine("[" + Base_Users._AgentLevel + "]" + "=@" + Base_Users._AgentLevel + ",");
            sb.AppendLine("[" + Base_Users._canHasSubAgent + "]" + "=@" + Base_Users._canHasSubAgent + ",");
            sb.AppendLine("[" + Base_Users._AgentLevelLimit + "]" + "=@" + Base_Users._AgentLevelLimit + ",");
            sb.AppendLine("WHERE " + Base_Users._UserID + "=@" + Base_Users._UserID);
            Database.ExecuteNonQuery(CommandType.Text, sb.ToString(), prams.ToArray());
        }

        public void UpdateUserByID(int UserID, Dictionary<string, object> KeyFields)
        {
            StringBuilder sqlAppend = new StringBuilder();
            var prams = new List<DbParameter>();
            prams.Add(Database.MakeInParam(Base_Users._UserID, UserID));
            foreach (var item in KeyFields)
            {
                prams.Add(Database.MakeInParam(item.Key, item.Value));
                sqlAppend.Append(item.Key + "=@" + item.Key + ",");
            }

            StringBuilder sb = new StringBuilder();
            sb.AppendLine("UPDATE dbo." + Base_Users.Tablename);
            sb.AppendLine("SET " + sqlAppend.ToString().Trim().Trim(','));
            sb.AppendLine("WHERE " + Base_Users._UserID + "=@" + Base_Users._UserID);
            Database.ExecuteNonQuery(CommandType.Text, sb.ToString(), prams.ToArray());
        }

        public void UpdateUserBy(string condition, Dictionary<string, object> KeyFields)
        {
            StringBuilder sqlAppend = new StringBuilder();
            var prams = new List<DbParameter>();
            foreach (var item in KeyFields)
            {
                prams.Add(Database.MakeInParam(item.Key, item.Value));
                sqlAppend.Append(item.Key + "=@" + item.Key + ",");
            }

            StringBuilder sb = new StringBuilder();
            sb.AppendLine("UPDATE dbo." + Base_Users.Tablename);
            sb.AppendLine("SET " + sqlAppend.ToString().Trim().Trim(','));
            sb.AppendLine("WHERE 1=1 " + condition);
            Database.ExecuteNonQuery(CommandType.Text, sb.ToString(), prams.ToArray());
        }

        public bool CheckUserPassword(int UserID, string pwd)
        {
            StringBuilder sb = new StringBuilder();
            sb.AppendLine("SELECT 1 FROM dbo." + Base_Users.Tablename);
            sb.AppendLine("WHERE UserID=" + UserID + " AND Password='" + pwd + "'");
            object o = Database.ExecuteScalar(CommandType.Text, sb.ToString());
            if (o != null && o != DBNull.Value && o.ToString() == "1")
            {
                return true;
            }
            return false;
        }

        public int GetSpreaderID()
        {
            string sql = "SELECT TOP 1 CodeID FROM [QPPlatformDB].[dbo].[InviteCode] WHERE IsLiang = 0 AND IsUse = 0";
            object id = Database.ExecuteScalar(CommandType.Text, sql);
            return Convert.ToInt32(id);
        }

        public DataTable GetSpreaderID(int count)
        {
            string sql = "SELECT TOP " + count + " CodeID FROM [QPPlatformDB].[dbo].[InviteCode] WHERE IsLiang = 0 AND IsUse = 0 ORDER BY NewID()";
            DataSet ds = Database.ExecuteDataset(sql);
            return ds.Tables[0];
        }

        public int UpdateSpreaderID(int UserID, string oldCode, string newCode)
        {
            List<DbParameter> parms = new List<DbParameter>();
            parms.Add(Database.MakeInParam("UserID", UserID));
            parms.Add(Database.MakeInParam("oldCode", oldCode));
            parms.Add(Database.MakeInParam("newCode", newCode));
            int r = Database.RunProc("p_UpdateSpreaderID", parms);
            return r;
        }

        public PagerSet GetGamerListInfo(int pageIndex, int pageSize, Dictionary<string, object> conditions)
        {
            var prams = new List<DbParameter>();
            prams.Add(Database.MakeInParam("pageIndex", pageIndex));
            prams.Add(Database.MakeInParam("pageSize", pageSize));
            foreach (var item in conditions)
            {
                prams.Add(Database.MakeInParam(item.Key, item.Value));
            }
            int startSum= (pageIndex-1)*pageSize;
            int endSum= pageIndex  * pageSize;
            DataSet ds;
            Database.RunProc("p_Get_GamerListInfoNew", prams, out ds); 

            int totalCount = Convert.ToInt32(ds.Tables[0].Rows[0]["totalCount"]);
            int totalPage = (int)Math.Ceiling((double)totalCount / pageSize);
            PagerSet pageSet = new PagerSet(pageIndex, pageSize, totalPage, totalCount, ds);
            return pageSet;

           
        }

        public PagerSet GetSubAgentListInfo(int pageIndex, int pageSize, Dictionary<string, object> conditions)
        {
            var prams = new List<DbParameter>();
            prams.Add(Database.MakeInParam("pageIndex", pageIndex));
            prams.Add(Database.MakeInParam("pageSize", pageSize));
            foreach (var item in conditions)
            {
                prams.Add(Database.MakeInParam(item.Key, item.Value));
            }

            DataSet ds;
            Database.RunProc("p_Get_SubAgentListInfo", prams, out ds);
            int totalCount = Convert.ToInt32(ds.Tables[0].Rows[0]["totalCount"]);
            int totalPage = (int)Math.Ceiling((double)totalCount / pageSize);
            PagerSet pageSet = new PagerSet(pageIndex, pageSize, totalPage, totalCount, ds);
            return pageSet;
        }

        public void AddLog(int iOperator, int iOperation, string logContent, string loginIP, string module)
        {
            StringBuilder sqlAppend = new StringBuilder();
            sqlAppend.AppendLine("INSERT dbo.SystemLog(LogContent,LogTime,Operator,LoginIP,Operation,Module)");
            sqlAppend.AppendLine("VALUES('" + logContent + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "'," + iOperator + ",'" + loginIP + "'," + iOperation + ",'" + module + "')");
            Database.ExecuteNonQuery(sqlAppend.ToString());
        }

        public DataTable GetAgent(int UserID)
        {
            StringBuilder sqlAppend = new StringBuilder();
            sqlAppend.AppendLine("SELECT a.UserID, a.Accounts UserName,a.NickName Nick,Gender Sex,u.canHasSubAgent canHasSub, u.AgentLevelLimit,u.Percentage Revenue, u.RoleID,u.GradeID,u.Nullity AgentStatus");
            sqlAppend.AppendLine("FROM QPAccountsDB.dbo.AccountsInfo a");
            sqlAppend.AppendLine("INNER JOIN dbo.Base_Users u ON a.UserID=u.AgentID");
            sqlAppend.AppendLine("WHERE a.UserID=" + UserID);
            DataTable dt = Database.ExecuteDataset(sqlAppend.ToString()).Tables[0];
            return dt;
        }

        public string GetInitCodebyUserID(int UserID)
        {
            StringBuilder sqlAppend = new StringBuilder();
            //sqlAppend.AppendLine("SELECT UserID,IsNull(IsAgent,0) IsAgent,IsNull(AgentID,0) AgentID FROM QPAccountsDB.dbo.AccountsInfo WHERE UserID=" + UserID);
            //DataTable dt = Database.ExecuteDataset(sqlAppend.ToString()).Tables[0];
            //if (dt.Rows.Count == 0)
            //{
            //    return "{\"status\":false,\"message\":\"用户不存在！\"}";
            //}
            //bool IsAgent = Convert.ToBoolean(dt.Rows[0]["IsAgent"]);
            //int AgentID = IsAgent ? UserID : Convert.ToInt32(dt.Rows[0]["AgentID"]);
            //sqlAppend.Clear();
            sqlAppend.AppendLine("SELECT InviteCode FROM [QPAccountsDB].[dbo].[AccountsInfoEx] WHERE UserID=" + UserID);
            object oCode = Database.ExecuteScalar(CommandType.Text, sqlAppend.ToString());
            if (oCode == DBNull.Value || oCode == null)
                return "{\"status\":true,\"message\":\"888888\"}";
            return "{\"status\":true,\"message\":\"" + oCode.ToString() + "\"}";
        }

        public int ModifyAdminPassword(int UserID, string oldPwd, string newPwd)
        {
            StringBuilder sqlAppend = new StringBuilder();
            List<DbParameter> parms = new List<DbParameter>();
            parms.Add(Database.MakeInParam("UserID", UserID));
            parms.Add(Database.MakeInParam("oldPwd", oldPwd));
            parms.Add(Database.MakeInParam("newPwd", newPwd));
            int r = Database.RunProc("p_UpdateAdminPassword", parms);
            return r;
        }

        public void ResetUserPassword(int UserID, string pwd)
        {
            StringBuilder sqlAppend = new StringBuilder();
            List<DbParameter> parms = new List<DbParameter>();
            parms.Add(Database.MakeInParam("UserID", UserID));
            parms.Add(Database.MakeInParam("defaulPwd", pwd));
            Database.RunProc("p_ReSetAgentPassword", parms);
        }
        #endregion

        public void AddSpreaderOptions(Dictionary<string, object> keyValues)
        {
            List<DbParameter> parms = new List<DbParameter>();
            foreach (var item in keyValues)
            {
                parms.Add(Database.MakeInParam(item.Key, item.Value));
            }
            Database.RunProc("p_AddSpreaderOptions", parms);
        }

        public void SaveSpreaderOptions(DataTable dt)
        {
            List<DbParameter> parms = new List<DbParameter>();
            parms.Add(Database.MakeInParam("ASOtable", dt));
            Database.RunProc("p_Update_AgentSpreaderOptions", parms);
        }

        public void SaveAgentRevenesSet(DataTable dt)
        {
            List<DbParameter> parms = new List<DbParameter>();
            parms.Add(Database.MakeInParam("table", dt));
            Database.RunProc("p_Update_AgentRevenesSet", parms);
        }

        public DataTable GetAgentSpreaderOptionBy(int RoleID, int GradeID)
        {
            StringBuilder sb = new StringBuilder();
            sb.AppendLine("SELECT [RoleID],[GradeID],[TotalSpreaderRate],[ASpreaderRate],[BSpreaderRate],[CSpreaderRate] FROM dbo.[AgentSpreaderOptions]");
            sb.AppendLine("WHERE RoleID=" + RoleID + " AND GradeID=" + GradeID);
            DataSet ds = Database.ExecuteDataset(CommandType.Text, sb.ToString());
            return ds.Tables[0];
        }

        public DataTable GetAgentSpreaderOptions()
        {
            StringBuilder sb = new StringBuilder();
            sb.AppendLine("SELECT r.[RoleID], r.RoleName, g.[GradeID], g.GradeDes,[TotalSpreaderRate] Rate");
            sb.AppendLine(",[ASpreaderRate] ARate,[BSpreaderRate] BRate,[CSpreaderRate] CRate");
            sb.AppendLine("FROM dbo.[Base_Roles] r");
            sb.AppendLine("INNER JOIN dbo.[Base_AgentGrades] g ON IsNull(r.AgentLevel,0) = g.AgentLevel");
            sb.AppendLine("LEFT JOIN dbo.[AgentSpreaderOptions] o ON o.RoleID = r.RoleID AND g.GradeID = o.GradeID");
            DataSet ds = Database.ExecuteDataset(CommandType.Text, sb.ToString());
            return ds.Tables[0];
        }

        public DataTable GetAgentRevenesSet()
        {
            StringBuilder sb = new StringBuilder();
            sb.AppendLine("SELECT DISTINCT a.UserID,a.GameID,a.Accounts,u.RoleID,r.RoleName,ag.GradeDes,u.Percentage FROM dbo.Base_Users u ");
            sb.AppendLine("INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON u.AgentID = a.UserID");
            sb.AppendLine("INNER JOIN dbo.Base_Roles r ON u.RoleID = r.RoleID");
            sb.AppendLine("INNER JOIN dbo.[Base_AgentGrades] ag ON u.GradeID = ag.GradeID");
            DataSet ds = Database.ExecuteDataset(CommandType.Text, sb.ToString());
            return ds.Tables[0];
        }

        public DataSet GetGamerSpreadSumByDay(int UserID, string day)
        {
            List<DbParameter> parms = new List<DbParameter>();
            parms.Add(Database.MakeInParam("UserID", UserID));
            parms.Add(Database.MakeInParam("day", day));
            DataSet ds;
            Database.RunProc("p_GetGamerSpreaderSumByDay", parms, out ds);
            return ds;
        }

        public void AddSpreadSumEmail(string today)
        {
            List<DbParameter> parms = new List<DbParameter>();
            parms.Add(Database.MakeInParam("Today", today));
            Database.RunProc("p_AddSpreadSumEmail", parms);
        }

        public void AddAgentReveneSumEmail(string today)
        {
            List<DbParameter> parms = new List<DbParameter>();
            parms.Add(Database.MakeInParam("Today", today));
            Database.RunProc("p_AddAgentReveneSumEmail", parms);
        }

        public DataTable GetAgentGrades()
        {
            StringBuilder sb = new StringBuilder();
            sb.AppendLine("SELECT GradeID,GradeDes,RoleID FROM dbo.Base_AgentGrades g ");
            sb.AppendLine("INNER JOIN dbo.Base_Roles r ON r.AgentLevel IS NOT NULL AND r.AgentLevel = g.AgentLevel");
            DataTable dt = Database.ExecuteDataset(sb.ToString()).Tables[0];
            return dt;
        }

        /// <summary>
        /// 代理角色
        /// </summary>
        /// <param name="isTop">是否取顶级代理</param>
        /// <returns></returns>
        public DataTable GetAgentRoles(int AgentLevel)
        {
            StringBuilder sb = new StringBuilder();
            sb.AppendLine("SELECT RoleID,RoleName,AgentLevel FROM dbo.Base_Roles");
            if (AgentLevel == -1)
                sb.AppendLine("WHERE AgentLevel>0");
            else
                sb.AppendLine("WHERE AgentLevel=" + AgentLevel);
            DataTable dt = Database.ExecuteDataset(sb.ToString()).Tables[0];
            return dt;
        }

        public int GetAgentLevel(int UserID)
        {
            StringBuilder sb = new StringBuilder();
            sb.AppendLine("SELECT IsNull(r.AgentLevel,0) FROM dbo.Base_Users u");
            sb.AppendLine("INNER JOIN dbo.Base_Roles r ON u.RoleID=r.RoleID");
            sb.AppendLine("WHERE u.UserID=" + UserID);
            object o = Database.ExecuteScalar(CommandType.Text, sb.ToString());
            if (o == DBNull.Value || o == null)
                return 0;
            else
                return Convert.ToInt32(o);
        }

        public PagerSet GetSpreaderChildren(int pageIndex, int pageSize, Dictionary<string, object> conditions)
        {
            var prams = new List<DbParameter>();
            prams.Add(Database.MakeInParam("pageIndex", pageIndex));
            prams.Add(Database.MakeInParam("pageSize", pageSize));
            foreach (var item in conditions)
            {
                prams.Add(Database.MakeInParam(item.Key, item.Value));
            }

            DataSet ds;
            Database.RunProc("p_GetChildrenSpreader", prams, out ds);
            int totalCount = Convert.ToInt32(ds.Tables[0].Rows[0]["totalCount"]);
            int totalPage = (int)Math.Ceiling((double)totalCount / pageSize);
            PagerSet pageSet = new PagerSet(pageIndex, pageSize, totalPage, totalCount, ds);
            return pageSet;
        }

        public PagerSet GetSensitiveWordSet(string keyword, int pageIndex, int pageSize)
        {
            var prams = new List<DbParameter>();
            prams.Add(Database.MakeInParam("keyword", keyword));
            prams.Add(Database.MakeInParam("pageIndex", pageIndex));
            prams.Add(Database.MakeInParam("pageSize", pageSize));
            DataSet ds;
            Database.RunProc("p_GetSensitiveWordSet", prams, out ds);
            int totalCount = Convert.ToInt32(ds.Tables[0].Rows[0]["totalCount"]);
            int totalPage = (int)Math.Ceiling((double)totalCount / pageSize);
            PagerSet pageSet = new PagerSet(pageIndex, pageSize, totalPage, totalCount, ds);
            return pageSet;
        }

        public void AddSensitiveWordSet(string sword)
        {
            var prams = new List<DbParameter>();
            prams.Add(Database.MakeInParam("SensitiveWord", sword));

            StringBuilder sb = new StringBuilder();
            sb.AppendLine("INSERT SensitiveWordSet(SensitiveWord,LastTime)");
            sb.AppendLine("VALUES(@SensitiveWord,GETDATE())");
            Database.ExecuteNonQuery(CommandType.Text, sb.ToString(), prams.ToArray());
        }

        public void SaveSensitiveWordSet(int id, string sword)
        {
            var prams = new List<DbParameter>();
            prams.Add(Database.MakeInParam("ID", id));
            prams.Add(Database.MakeInParam("SensitiveWord", sword));

            StringBuilder sb = new StringBuilder();
            sb.AppendLine("UPDATE SensitiveWordSet");
            sb.AppendLine("SET SensitiveWord=@SensitiveWord");
            sb.AppendLine("WHERE ID=@ID");
            Database.ExecuteNonQuery(CommandType.Text, sb.ToString(), prams.ToArray());
        }


        public void DeleteSensitiveWordSet(string ids)
        {
            StringBuilder sb = new StringBuilder();
            sb.AppendLine("DELETE SensitiveWordSet");
            sb.AppendLine("WHERE ID IN (" + ids + ")");
            Database.ExecuteNonQuery(CommandType.Text, sb.ToString());
        }
    }
}
