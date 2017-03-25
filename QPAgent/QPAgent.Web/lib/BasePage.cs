using System;
using System.Web;
using System.Collections.Generic;
using System.Text;

using Game.Facade;
using Game.Utils;
using Game.Entity;
using Game.Entity.Platform;
using Game.Entity.Treasure;
using Game.Entity.GameScore;
using Game.Entity.Accounts;
using Game.Entity.PlatformManager;
using Game.Entity.Enum;
using System.Web.UI.WebControls;
using System.Data;
using System.IO;

namespace Game.Web
{
    public partial class BasePage : System.Web.UI.Page
    {
        public BasePage()
        {
            ////登录判断
            //userExt = AdminCookie.GetUserFromCookie();
            //if (userExt == null || userExt.UserID <= 0 || userExt.RoleID <= 0)
            //{
            //    outputJscript(String.Format("window.top.location=\"{0}/Login.aspx?errtype=overtime\";", FullPath));
            //}
            //else
            //{
            //    //更新凭证
            //    AdminCookie.SetUserCookie(userExt);
            //    //获取权限
            //    __Module = aidePlatformManagerFacade.GetDataSets(string.Format("SELECT ModuleID,OperationPermission,StateFlag FROM Base_RolePermission WHERE RoleID={0};SELECT ModuleID,PermissionValue,StateFlag FROM Base_ModulePermission", userExt.RoleID));
            //    __Role = __Module.Tables[0].DefaultView;
            //    __Power = __Module.Tables[1].DefaultView;
            //    //系统配置信息
            //    if (siteInfo == null)
            //    {
            //        siteInfo = aidePlatformManagerFacade.GetQPAdminSiteInfo(1);
            //    }
            //}
        }
        protected void Page_Init(object sender, EventArgs e)
        {
            //relId = Request["relId"];
            //FullPath = string.Concat(Request.Url.Scheme, "://", Request.Url.Host, ":", Request.Url.Port);
            //if (userExt == null || userExt.UserID <= 0 || userExt.RoleID <= 0)
            //{
            //    if (!string.IsNullOrEmpty(relId))
            //    {
            //        outputJson(new MessageBox("301", false, string.Empty));
            //    }
            //    else
            //    {
            //        outputJscript(String.Format("window.top.location=\"{0}/Login.aspx?errtype=overtime\";", FullPath));
            //    }
            //}
            //else
            //{
            //    //权限判断
            //    if (!string.IsNullOrEmpty(Request.QueryString["moduleID"]))
            //    {
            //        moduleID = GameRequest.GetQueryInt("moduleID", 0);
            //        __Role.RowFilter = string.Format("moduleID={0} AND StateFlag=0", moduleID);
            //        __Power.RowFilter = string.Format("moduleID={0} AND StateFlag=0", moduleID);
            //    }
            //    //页面分页大小
            //    numPerPage = GameRequest.GetFormInt("numPerPage", siteInfo.PageSize);
            //    //当前第多少页
            //    pageNum = GameRequest.GetFormInt("pageNum", 1);
            //    //查询条件
            //    strWhere = new StringBuilder(" WHERE (1=1) ");
            //}
        }
        /// <summary>
        /// 当前帐号权限
        /// </summary>
        protected DataSet __Module;
        private DataView __Role;
        private DataView __Power;
        protected bool IsAuthUserOperationPermission(Permission permission)
        {
            bool IsHas = false;
            Int64 action = (int)permission;
            //判断是否启用该栏目所有权限
            __Role.RowFilter = string.Format("moduleID={0} AND StateFlag=0", moduleID);
            //判断是否启用该栏目操作权限
            __Power.RowFilter = string.Format("moduleID={0} AND PermissionValue={1} AND StateFlag=0", moduleID, action);
            if (__Power.Count == 1 && __Role.Count == 1)
            {
                Int64 p = Convert.ToInt64(__Role[0]["OperationPermission"]);
                IsHas = action == (p & action);
            }
            else
            {
                IsHas = userExt.RoleID == 1;
            }
            return IsHas;
        }
        protected void AuthUserOperationPermission(Permission permission)
        {
            if (!IsAuthUserOperationPermission(permission))
            {
                outputJscript("navTab.closeCurrentTab(\"" + relId + "\");navTab.openTab(\"unopower\",\"../NotPower.htm\", {title:\"无权访问\", fresh:false, data:{} });alertMsg.warn(\"抱歉，你没有该操作权限！\");");
            }
        }




        #region Fields
        protected static Game.Entity.PlatformManager.QPAdminSiteInfo siteInfo = null;
        /// <summary>
        /// 前台外观
        /// </summary>
        protected internal NativeWebFacade aideNativeWebFacade = new NativeWebFacade();

        /// <summary>
        /// 后台外观
        /// </summary>
        protected PlatformManagerFacade aidePlatformManagerFacade = new PlatformManagerFacade();
        /// <summary>
        /// 平台外观
        /// </summary>
        protected internal PlatformFacade aidePlatformFacade = new PlatformFacade();

        /// <summary>
        /// 金币库外观
        /// </summary>
        protected internal TreasureFacade aideTreasureFacade = new TreasureFacade();

        /// <summary>
        /// 帐号库外观
        /// </summary>
        protected internal AccountsFacade aideAccountsFacade = new AccountsFacade();

        /// <summary>
        /// 记录库外观
        /// </summary>
        protected internal RecordFacade aideRecordFacade = new RecordFacade();

        /// <summary>
        /// 比赛库外观
        /// </summary>
        protected internal GameMatchFacade aideGameMatchFacade = new GameMatchFacade();

        /// <summary>
        /// 比赛库外观
        /// </summary>
        protected internal AccountsFacade accountFacade = new AccountsFacade();

        /// <summary>
        /// 模块标识
        /// </summary>
        protected static int moduleID;

        /// <summary>
        /// 用户对象
        /// </summary>
        protected internal Base_Users userExt;

        /// <summary>
        /// 可管理站点
        /// </summary>
        protected string _ownStation;
        //页面代码
        #endregion
        #region Cookie 检查

        /// <summary>
        /// Cookie 检查
        /// </summary>
        /// <returns></returns>
        protected bool CheckedCookie()
        {
            return AdminCookie.CheckedUserLogon();
        }

        #endregion
        #region 公共方法部分

        /// <summary>
        /// 根据IP的地理位置
        /// </summary>
        /// <param name="IP">IP</param>
        /// <returns>地理位置</returns>
        protected string GetAddressWithIP(string IP)
        {
            IPSelect IPSelect = new IPSelect();
            try
            {
                return IPSelect.GetIPLocation(IP);
            }
            catch
            {
                return "";
            }
        }
        /// <summary>
        /// 获取会员级别名称
        /// </summary>
        /// <param name="order"></param>
        /// <returns></returns>
        protected string GetMemberName(byte order)
        {
            string resultValue = "";
            string MemberName = Enum.GetName(typeof(MemberOrderStatus), order);
            switch (order)
            {
                case 0:
                    resultValue = "{0}";//普通会员
                    break;
                case 1:
                    resultValue = "<b style='color:#15599f;'>{0}会员</b>";//蓝钻
                    break;
                case 2:
                    resultValue = "<b style='color:#d16213;'>{0}会员</b>";//黄钻
                    break;
                case 3:
                    resultValue = "<b style='color:#777777;'>{0}会员</b>";//白钻
                    break;
                case 4:
                    resultValue = "<b style='color:#b70000;'>{0}会员</b>";//红钻
                    break;
                case 5:
                    resultValue = "<b style='color:#EB4019;'>{0}会员</b>";//红钻
                    break;
                default:
                    resultValue = "{0}";//普通会员
                    break;

            }
            return string.Format(resultValue, MemberName);
        }
        protected string GetMemberName1(byte order)
        {
            string resultValue = "";
            string MemberName = Enum.GetName(typeof(MemberOrderStatus), order);
            switch (order)
            {
                case 0:
                    resultValue = "{0}";//普通会员
                    break;
                case 1:
                    resultValue = "{0}会员";//蓝钻
                    break;
                case 2:
                    resultValue = "{0}会员";//黄钻
                    break;
                case 3:
                    resultValue = "{0}会员";//白钻
                    break;
                case 4:
                    resultValue = "{0}会员";//红钻
                    break;
                case 5:
                    resultValue = "{0}会员";//红钻
                    break;
                default:
                    resultValue = "{0}";//普通会员
                    break;

            }
            return string.Format(resultValue, MemberName);
        }
        /// <summary>
        /// 会员卡使用范围
        /// </summary>
        /// <param name="rangeid"></param>
        /// <returns></returns>
        protected string GetUserRange(int rangeid)
        {
            string strResult = "";
            switch (rangeid)
            {
                case 0:
                    strResult = "全部用户";
                    break;
                case 1:
                    strResult = "新注册用户";
                    break;
                case 2:
                    strResult = "第一次充值用户";
                    break;
                default:
                    strResult = "";
                    break;
            }
            return strResult;
        }
        /// <summary>
        /// 兑换场所(0:大厅,1:网页)
        /// </summary>
        /// <param name="IsGamePlaza"></param>
        /// <returns></returns>
        protected string GetExchangePlace(int IsGamePlaza)
        {
            if (IsGamePlaza == 0)
            {
                return "<center>大厅</center>";
            }
            else
            {
                return "<center style='color:#EB4019;'>网页</center>";
            }
        }
        /// <summary>
        /// 给出状态(全局通用0:启用; 1:禁止)
        /// </summary>
        /// <param name="nullity"></param>
        /// <returns></returns>
        protected string GetNullityStatus(byte nullity)
        {
            if (nullity == 0)
            {
                return "<center style='color:#1023F4;'>启用</center>";
            }
            else
            {
                return "<center style='color:#EB4019;'>禁用</center>";
            }
        }
        protected string GetNullityStatus1(byte nullity)
        {
            if (nullity == 1)
            {
                return "<center style='color:#1023F4;'>启用</center>";
            }
            else
            {
                return "<center style='color:#EB4019;'>关闭</center>";
            }
        }
        protected void DeleteFile(String iFile)
        {
            if (!String.IsNullOrEmpty(iFile))
            {
                iFile = iFile.Replace(string.Concat("http://", Request.Url.Authority), "");
                try
                {
                    string myFile = HttpContext.Current.Server.MapPath(iFile);
                    if (File.Exists(myFile))
                    {
                        File.Delete(myFile);
                    }
                }
                catch (Exception)
                { }
            }
        }
        /// <summary>
        /// 获取身份类型
        /// </summary>
        /// <param name="type"></param>
        /// <returns></returns>
        protected string GetPassPortType(Byte type)
        {
            string returnValue = "";
            switch (type)
            {
                case 0:
                    returnValue = "没有设置";
                    break;
                case 1:
                    returnValue = "身份证";
                    break;
                case 2:
                    returnValue = "护照";
                    break;
                case 3:
                    returnValue = "军官证";
                    break;
                case 4:
                    returnValue = "驾驶执照";
                    break;
                default:
                    returnValue = "其他";
                    break;
            }
            return returnValue;
        }
        /// <summary>
        /// MD5混合加密
        /// </summary>
        /// <param name="password">明文密码</param>
        /// <returns>string</returns>
        protected string SetMD5(string password)
        {
            return Utility.MD5(password);
        }
        /// <summary>
        /// 获取订单状态
        /// </summary>
        /// <param name="status"></param>
        /// <returns></returns>
        protected string GetOnLineOrderStatus(byte status)
        {
            string returnValue = "";
            switch (status)
            {
                case 0:
                    returnValue = "<center style='color:#EB4019;'>未付款</center>";
                    break;
                case 1:
                    returnValue = "<center>待处理</center>";
                    break;
                case 2:
                    returnValue = "<center>完成</center>";
                    break;
                default:
                    break;
            }
            return returnValue;
        }


        /// <summary>
        /// 计算版本号
        /// </summary>
        /// <param name="version"></param>
        /// <returns></returns>
        protected string CalVersion(int version)
        {
            string returnValue = "";
            returnValue += (version >> 24).ToString() + ".";
            returnValue += (((version >> 16) << 24) >> 24).ToString() + ".";
            returnValue += (((version >> 8) << 24) >> 24).ToString() + ".";
            returnValue += ((version << 24) >> 24).ToString();
            return returnValue;
        }

        /// <summary>
        /// 还原版本号
        /// </summary>
        /// <param name="version"></param>
        /// <returns></returns>
        protected int CalVersion2(string version)
        {
            int rValue = 0;
            string[] verArray = version.Split('.');
            rValue = (int.Parse(verArray[0]) << 24) | (int.Parse(verArray[1]) << 16) | (int.Parse(verArray[2]) << 8) | int.Parse(verArray[3]);
            return rValue;
        }

        /// <summary>
        /// 对数字添加”,“号，可以处理负数以及带有小数的情况
        /// </summary>
        /// <param name="version"></param>
        /// <returns></returns>
        protected string FormatMoney(string money)
        {
            //处理带有负号情况
            int negNumber = money.IndexOf("-");
            string prefix = string.Empty;
            if (negNumber != -1)
            {
                prefix = "-";
                money = money.Substring(1);
            }
            //处理有小数位情况
            int decNumber = money.IndexOf(".");
            string postfix = string.Empty;
            if (decNumber != -1)
            {
                postfix = money.Substring(decNumber);
                money = money.Substring(0, decNumber - 1);
            }
            //开始添加”,“号
            if (money.Length > 3)
            {
                string str1 = money.Substring(0, money.Length - 3);
                string str2 = money.Substring(money.Length - 3, 3);
                if (str1.Length > 3)
                {
                    return prefix + FormatMoney(str1) + "," + str2 + postfix;
                }
                else
                {
                    return prefix + str1 + "," + str2 + postfix;
                }
            }
            else
            {
                return prefix + money + postfix;
            }
        }

        #endregion
        #region 平台库部分

        /// <summary>
        /// 获取类型名称
        /// </summary>
        /// <param name="typeID"></param>
        /// <returns></returns>
        protected string GetGameTypeName(int typeID)
        {
            GameTypeItem gameType = aidePlatformFacade.GetGameTypeItemInfo(typeID);
            if (gameType == null)
            {
                return "";
            }
            return gameType.TypeName;
        }

        /// <summary>
        /// 获取游戏名称
        /// </summary>
        /// <param name="kindID"></param>
        /// <returns></returns>
        protected string GetGameKindName(int kindID)
        {
            GameKindItem gameKind = aidePlatformFacade.GetGameKindItemInfo(kindID);
            if (gameKind == null)
            {
                return "";
            }
            return gameKind.KindName;
        }

        /// <summary>
        /// 获取模块名称
        /// </summary>
        /// <param name="gameID"></param>
        /// <returns></returns>
        protected string GetGameGameName(int gameID)
        {
            GameGameItem gameitem = aidePlatformFacade.GetGameGameItemInfo(gameID);
            if (gameitem == null)
            {
                return "";
            }
            return gameitem.GameName;
        }

        /// <summary>
        /// 获取房间名称
        /// </summary>
        /// <param name="serverID"></param>
        /// <returns></returns>
        protected string GetGameRoomName(int serverID)
        {
            GameRoomInfo gameRoom = aidePlatformFacade.GetGameRoomInfoInfo(serverID);
            if (gameRoom == null)
            {
                return "";
            }
            return gameRoom.ServerName;
        }

        /// <summary>
        /// 获取房间类型名称
        /// </summary>
        /// <param name="type"></param>
        /// <returns></returns>
        protected string GetSupporTypeName(object type)
        {
            return EnumDescription.GetFieldText((SupporTypeStatus)type);
        }

        /// <summary>
        /// 获取游戏节点名称
        /// </summary>
        /// <param name="nodeID"></param>
        /// <returns></returns>
        protected string GetGameNodeName(int nodeID)
        {
            if (nodeID <= 0)
                return "无挂接";
            GameNodeItem gameNode = aidePlatformFacade.GetGameNodeItemInfo(nodeID);
            if (gameNode == null)
                return "无挂接";
            else
                return gameNode.NodeName;

        }
        #endregion
        #region 管理库

        /// <summary>
        /// 获取管理员帐号
        /// </summary>
        /// <param name="masterID"></param>
        /// <returns></returns>
        protected string GetMasterName(int masterID)
        {
            return aidePlatformManagerFacade.GetAccountsByUserID(masterID);
        }

        /// <summary>
        /// 获取角色名称
        /// </summary>
        /// <param name="roleID"></param>
        /// <returns></returns>
        protected string GetRoleName(int roleID)
        {
            Base_Roles role = aidePlatformManagerFacade.GetRoleInfo(roleID);
            if (role == null)
            {
                return "";
            }
            return role.RoleName;
        }
        #endregion
        #region 帐号库部分

        /// <summary>
        /// 获取用户帐号
        /// </summary>
        /// <param name="userID"></param>
        /// <returns></returns>
        protected string GetAccounts(int userID)
        {
            AccountsInfo accounts = aideAccountsFacade.GetAccountInfoByUserID(userID);
            if (accounts == null)
            {
                return "";
            }
            return TextUtility.CutString(accounts.Accounts, 0, 10);
        }
        /// <summary>
        /// 获得昵称
        /// </summary>
        /// <param name="userID">用户UserID</param>
        /// <returns></returns>
        public string GetNickNameByUserID(int userID)
        {
            AccountsInfo model = aideAccountsFacade.GetAccountInfoByUserID(userID);
            if (model != null)
                return TextUtility.CutString(model.NickName, 0, 10);
            else
                return "";
        }
        /// <summary>
        /// 获取用户游戏ID
        /// </summary>
        /// <param name="userID"></param>
        /// <returns></returns>
        protected string GetGameID(int userID)
        {
            AccountsInfo accounts = aideAccountsFacade.GetAccountInfoByUserID(userID);
            if (accounts == null)
            {
                return "0";
            }
            return accounts.GameID.ToString();
        }
        /// <summary>
        /// 获取魅力值
        /// </summary>
        /// <param name="userID"></param>
        /// <returns></returns>
        protected string GetLoveLinessByUserID(int userID)
        {
            AccountsInfo accounts = aideAccountsFacade.GetAccountInfoByUserID(userID);
            if (accounts == null)
            {
                return "0";
            }
            return accounts.LoveLiness.ToString();
        }
        /// <summary>
        /// 获取已兑换的魅力值
        /// </summary>
        /// <param name="userID"></param>
        /// <returns></returns>
        protected string GetPresentByUserID(int userID)
        {
            AccountsInfo accounts = aideAccountsFacade.GetAccountInfoByUserID(userID);
            if (accounts == null)
            {
                return "0";
            }
            return accounts.Present.ToString();
        }
        /// <summary>
        /// 获取经验值
        /// </summary>
        /// <param name="userID"></param>
        /// <returns></returns>
        protected string GetExperienceByUserID(int userID)
        {
            AccountsInfo accounts = aideAccountsFacade.GetAccountInfoByUserID(userID);
            if (accounts == null)
            {
                return "0";
            }
            return accounts.Experience.ToString();
        }
        /// <summary>
        /// 获取奖牌数
        /// </summary>
        /// <param name="userID"></param>
        /// <returns></returns>
        protected string GetUserMedalByUserID(int userID)
        {
            AccountsInfo accounts = aideAccountsFacade.GetAccountInfoByUserID(userID);
            if (accounts == null)
            {
                return "0";
            }
            return accounts.UserMedal.ToString();
        }

        /// <summary>
        /// 判断是否机器人
        /// </summary>
        /// <param name="userID"></param>
        /// <returns></returns>
        protected bool IsAndroid(int userID)
        {
            AccountsInfo accounts = aideAccountsFacade.GetAccountInfoByUserID(userID);
            if (accounts == null)
            {
                return false;
            }
            if (accounts.IsAndroid == 1)
            {
                return true;
            }
            else
            {
                return false;
            }
        }


        #endregion
        #region 金币库部分

        /// <summary>
        /// 获取金币
        /// </summary>
        /// <param name="userID"></param>
        /// <returns></returns>
        protected string GetScoreByUserID(int userID)
        {
            Game.Entity.Treasure.GameScoreInfo model = aideTreasureFacade.GetGameScoreInfoByUserID(userID);
            if (model == null)
                return "0";
            return model.Score.ToString();
        }
        /// <summary>
        /// 获取银行金币
        /// </summary>
        /// <param name="userID"></param>
        /// <returns></returns>
        protected string GetInsureScoreByUserID(int userID)
        {
            return aideTreasureFacade.GetGameScoreByUserID(userID).ToString();
        }


        /// <summary>
        /// 获取服务名称
        /// </summary>
        /// <param name="shareID"></param>
        /// <returns></returns>
        protected string GetShareName(int shareID)
        {
            GlobalShareInfo globalShare = aideTreasureFacade.GetGlobalShareByShareID(shareID);
            if (globalShare == null)
            {
                return "";
            }
            else
            {
                return globalShare.ShareName.Trim();
            }
        }

        /// <summary>
        /// 获取实卡名称
        /// </summary>
        /// <param name="typeID"></param>
        /// <returns></returns>
        protected string GetCardTypeName(int typeID)
        {
            GlobalLivcard card = aideTreasureFacade.GetGlobalLivcardInfo(typeID);
            if (card == null)
                return "";
            return card.CardName;
        }

        #endregion
    }
}