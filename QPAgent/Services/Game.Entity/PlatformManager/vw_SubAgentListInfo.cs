/*
 * 版本：4.0
 * 时间：2016-11-21
 * 作者：Levan
 * 描述：实体类
 *
 */

using System;
using System.Collections.Generic;

namespace Game.Entity.PlatformManager
{
    /// <summary>
    /// 实体类 Base_Roles。(属性说明自动提取数据库字段的描述信息)
    /// </summary>
    [Serializable]
    public partial class vw_SubAgentListInfo
    {
        /// <summary>
        /// 表名
        /// </summary>
        public const string Tablename = "vw_SubAgentListInfo";
        public const string _UserID = "UserID";
        public const string _UserName = "UserName";
        public const string _Recharge = "Recharge";
        public const string _OnlineCount = "OnlineCount";
        public const string _AllGamerCount = "AllGamerCount";
        public const string _AllGamerScore = "AllGamerScore";
        public const string _Percentage = "Percentage";
        public const string _SubAgentCount = "SubAgentCount";
        public const string _Status = "Status";
        public const string _SpreaderDate = "SpreaderDate";
        public const string _HigherAgentID = "HigherAgentID";
        public const string _HigherAgentName = "HigherAgentName";
        public const string _SpreaderID = "SpreaderID";

        public string UserID { get; set; }
        public string UserName { get; set; }
        public string Recharge { get; set; }
        public string OnlineCount { get; set; }
        public string AllGamerCount { get; set; }
        public string AllGamerScore { get; set; }
        public string Percentage { get; set; }
        public string SubAgentCount { get; set; }
        public string Status { get; set; }
        public string SpreaderDate { get; set; }
        public string HigherAgentID { get; set; }
        public string HigherAgentName { get; set; }
        public string SpreaderID { get; set; }
    }
}
