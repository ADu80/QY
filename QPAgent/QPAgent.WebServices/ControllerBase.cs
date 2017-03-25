using Game.Entity.PlatformManager;
using Game.Facade;
using Game.Kernel;
using Game.Utils;
using QPAgent.WebServices.Helpers;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;

namespace QPAgent.WebServices
{
    public abstract class ControllerBase : IController
    {
        protected AdminCookie.SesionUser userExt = AdminCookie.GetUserFromCookie();
        protected TreasureFacade aideTreasureFacade = new TreasureFacade();
        protected AccountsFacade aideAccountsFacade = new AccountsFacade();
        protected PlatformFacade aidePlatformFacade = new PlatformFacade();
        public static PlatformManagerFacade aidePlatformManagerFacade = new PlatformManagerFacade();
        //  public static bool isDone = false;
        public static string Login(HttpRequest req)
        {
            string username = req.Form["username"].Trim();
            string password = req.Form["password"];//CryptHelper.Descrypt(username, GameRequest.GetFormString("password"));
            try
            {
                if (!Validate.IsUserName(username))
                {
                    return JsonResultHelper.GetErrorJson("用户名格式不正确！");
                }
                else
                {
                    Base_Users user = new Base_Users();
                    user.Username = username;
                    user.Password = Utility.MD5(password);
                    user.LastLoginIP = GameRequest.GetUserIP();
                    Message msg = aidePlatformManagerFacade.UserLogon(user);
                    if (!msg.Success)
                    {
                        LogHelper2.SaveErrLog("用户名格式不正确", "", user.UserID, (int)LogOperationEnum.AddGamer, GameRequest.GetUserIP(), "登录模块");
                        return JsonResultHelper.GetErrorJson(msg.Content);
                    }
                    else
                    {
                        //   isDone = false;
                        LogHelper2.SaveSuccessLog("[" + username + "]成功登录", user.UserID, (int)LogOperationEnum.AddGamer, GameRequest.GetUserIP(), "登录模块");
                        return JsonResultHelper.GetSuccessJson(msg.Content);
                    }
                }
            }
            catch (Exception ex)
            {
                return JsonResultHelper.GetErrorJson(ex.Message);
            }
        }

        public static string Logout()
        {
            string json = "";
            AdminCookie.SesionUser userExt = AdminCookie.GetUserFromCookie();
            try
            {
                aidePlatformManagerFacade.UserLogout();
                LogHelper2.SaveSuccessLog("[" + userExt.Username + "]退出成功", userExt.UserID, (int)LogOperationEnum.Logout, GameRequest.GetUserIP(), "登录模块");
                json = JsonResultHelper.GetSuccessJson("退出成功");
            }
            catch (Exception ex)
            {
                LogHelper2.SaveErrLog("[" + userExt.Username + "]退出失败", "", userExt.UserID, (int)LogOperationEnum.Login, GameRequest.GetUserIP(), "登录模块");
                json = JsonResultHelper.GetErrorJson(ex.Message);
            }
            return json;
        }

        public string ajax(HttpRequest req)
        {
            if (!CheckUser())
            {
                return JsonResultHelper.GetLoginErrorJson("登录已过期！");
            }
            string type = req["type"];
            string json = "";
            switch (type)
            {
                case "Delete":
                    json = Delete(req);
                    break;
                case "New":
                    json = New(req);
                    break;
                case "Edit":
                    json = Edit(req);
                    break;
                case "Index":
                    json = Index(req);
                    break;
                default:
                    return JsonResultHelper.GetErrorJson("type参数不正确");
            }
            return json;
        }

        protected bool CheckUser()
        {
            userExt = AdminCookie.GetUserFromCookie();

            if (userExt == null || userExt.UserID <= 0 || userExt.RoleID <= 0)
            {
                return false;
            }
            return true;
        }

        protected bool IsAuthUserOperationPermission()
        {
            return true;
        }

        protected string GetJsonByDataTable(DataTable dt)
        {
            string strcol = "";
            string strrow = "";
            foreach (DataRow dr in dt.Rows)
            {
                strcol = "\"checked\":false,\"selected\":false,";
                foreach (DataColumn dc in dt.Columns)
                {
                    strcol += "\"" + dc.ColumnName + "\":\"" + ReplaceEntityString(dr[dc.ColumnName].ToString().Trim()) + "\",";
                }
                strrow += "{" + strcol.Trim().Trim(',') + "},";
            }
            string json = "[" + strrow.Trim().Trim(',') + "]";
            return json;
        }

        protected string ReplaceEntityString(string str)
        {
            str = str.Replace("'", "\'");
            str = str.Replace("\"", "\\\"");
            str = str.Replace("\0", "");
            return str;
        }

        protected string GetJsonByDataTableEx(DataTable dt)
        {
            string strcol = "";
            string strrow = "";
            if (dt.Rows.Count == 0)
            {
                strcol = "\"checked\":false,\"selected\":false,";
                foreach (DataColumn dc in dt.Columns)
                {
                    strcol += "\"" + dc.ColumnName + "\":\"\",";
                }
                strrow += "{" + strcol.Trim().Trim(',') + "},";
            }
            else
            {
                foreach (DataRow dr in dt.Rows)
                {
                    strcol = "\"checked\":false,\"selected\":false,";
                    foreach (DataColumn dc in dt.Columns)
                    {
                        strcol += "\"" + dc.ColumnName + "\":\"" + ReplaceEntityString(dr[dc.ColumnName].ToString().Trim()) + "\",";
                    }
                    strrow += "{" + strcol.Trim().Trim(',') + "},";
                }
            }
            string json = "[" + strrow.Trim().Trim(',') + "]";
            return json;
        }

        protected string GetColumnsAppendBy(string view)
        {
            DataTable dtVC = aidePlatformManagerFacade.GetViewsColumns(view);
            string colsstr = "\"checked\",\"selected\",";
            foreach (DataRow dr in dtVC.Rows)
            {
                string column = dr["ColumnName"].ToString();
                string caption = dr["ColumnCaption"].ToString();
                colsstr += "{\"column\":\"" + column + "\"caption\":\"" + caption + "\"},";
            }
            return colsstr.Trim().Trim(',');
        }

        protected string GetResultMessage(string module, string dataAppend, int totalcount, int pageSize)
        {
            return "{\"data\":" + dataAppend + ",\"totalPage\":" + Math.Ceiling((double)totalcount / pageSize) + ",\"totalCount\":" + totalcount.ToString() + ",\"module\":\"" + module + "\"}";
        }

        protected string GetStringByStream(Stream stream)
        {
            StreamReader sr = new StreamReader(stream, Encoding.UTF8);
            string r = sr.ReadToEnd();
            return r;
        }

        protected string GetResponse(string module, string view, DataTable dt, int pageSize, int totalCount)
        {
            string dataAppend = GetJsonByDataTable(dt);
            //string columnsAppend = GetColumnsAppendBy(view);

            string message = GetResultMessage(module, dataAppend, totalCount, pageSize);
            string json = JsonResultHelper.GetSuccessJsonByArray(message);
            return json;
        }

        protected string JsonUrlEncode(string value)
        {
            return HttpUtility.UrlDecode(value);
        }

        protected DataTable JsonToDataTable(string json, List<string> cols)
        {
            DataTable dataTable = new DataTable();  //实例化
            DataTable result;
            try
            {
                JavaScriptSerializer javaScriptSerializer = new JavaScriptSerializer();
                javaScriptSerializer.MaxJsonLength = Int32.MaxValue; //取得最大数值
                ArrayList arrayList = javaScriptSerializer.Deserialize<ArrayList>(json);
                if (arrayList.Count > 0)
                {
                    foreach (Dictionary<string, object> dictionary in arrayList)
                    {
                        if (dictionary.Keys.Count == 0)
                        {
                            result = dataTable;
                            return result;
                        }
                        if (dataTable.Columns.Count == 0)
                        {
                            foreach (string current in dictionary.Keys)
                            {
                                if (cols.Contains(current))
                                {
                                    dataTable.Columns.Add(current, dictionary[current].GetType());
                                }
                            }
                        }
                        DataRow dataRow = dataTable.NewRow();
                        foreach (string current in dictionary.Keys)
                        {
                            if (cols.Contains(current))
                            {
                                dataRow[current] = dictionary[current];
                            }
                        }
                        dataTable.Rows.Add(dataRow); //循环添加行到DataTable中
                    }
                }
            }
            catch { }
            result = dataTable;
            return result;
        }

        public virtual string Delete(HttpRequest req)
        {
            throw new NotImplementedException();
        }

        public virtual string Edit(HttpRequest req)
        {
            throw new NotImplementedException();
        }

        public virtual string Index(HttpRequest req)
        {
            throw new NotImplementedException();
        }

        public virtual string New(HttpRequest req)
        {
            throw new NotImplementedException();
        }

        protected string GetModuleName(int mt)
        {
            string res = "";
            switch (mt)
            {
                case (int)ModuleType.AgentInfo:
                    res = "代理信息";
                    break;
                case (int)ModuleType.SubAgents:
                    res = "代理商账号";
                    break;
                case (int)ModuleType.Admin:
                    res = "管理员账号";
                    break;
                case (int)ModuleType.Roles:
                    res = "角色管理";
                    break;
                case (int)ModuleType.SpreadOption:
                    res = "返利配置";
                    break;
                case (int)ModuleType.SystemLog:
                    res = "操作日志";
                    break;
                case (int)ModuleType.SensitiveWord:
                    res = "敏感词过滤";
                    break;
                default:
                    res = "代理信息";
                    break;
            }
            return res;
        }

        protected enum ModuleType
        {
            AgentInfo = 1,
            SubAgents,
            Admin,
            Roles,
            SpreadOption,
            SystemLog,
            SensitiveWord
        }
    }
}
