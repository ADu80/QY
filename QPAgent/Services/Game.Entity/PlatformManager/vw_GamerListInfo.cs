using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Game.Entity.PlatformManager
{
    public class vw_GamerListInfo
    {
        /// <summary>
        /// 表名
        /// </summary>
        public const string Tablename = "vw_GamerListInfo";

        public const string _UserID = "UserID";
        public const string _UserName = "UserName";
        public const string _AllScore = "AllScore";
        public const string _InsureScore = "InsureScore";
        public const string _Score = "Score";
        public const string _YuanBao = "YuanBao";
        public const string _RoomCard = "RoomCard";
        public const string _Waste = "Waste";
        public const string _Recharge = "Recharge";
        public const string _LoginStatus = "LoginStatus";
        public const string _LoginTimes = "LoginTimes";
        public const string _Nullity = "Nullity";
        public const string _AgentName = "AgentName";
        public const string _SpreaderDate = "SpreaderDate";

        public string UserID { get; set; }
        public string UserName { get; set; }
        public string AllScore { get; set; }
        public string InsureScore { get; set; }
        public string Score { get; set; }
        public string YuanBao { get; set; }
        public string RoomCard { get; set; }
        public string Waste { get; set; }
        public string Recharge { get; set; }
        public string LoginStatus { get; set; }
        public string LoginTimes { get; set; }
        public string Nullity { get; set; }
        public string AgentName { get; set; }
        public string SpreaderDate { get; set; }
    }
}
