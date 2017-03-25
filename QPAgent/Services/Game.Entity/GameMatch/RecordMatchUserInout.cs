using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Game.Entity.GameMatch
{
    /// <summary>
    /// 实体类 RecordMatchUserInout   进出比赛记录表 (属性说明自动提取数据库字段的描述信息)
	/// </summary>
	[Serializable]
	public partial class RecordMatchUserInout
    {

        // Fields
        public const string Tablename = "RecordMatchUserInout";
        public const string _AwardExperience = "AwardExperience";
        public const string _AwardGold = "AwardGold";
        public const string _AwardMedal = "AwardMedal";
        public const string _EnterClientIP = "EnterClientIP";
        public const string _EnterExperience = "EnterExperience";
        public const string _EnterMachine = "EnterMachine";
        public const string _EnterScore = "EnterScore";
        public const string _EnterTime = "EnterTime";
        public const string _EnterUserMedal = "EnterUserMedal";
        public const string _ID = "ID";
        public const string _KindID = "KindID";
        public const string _LeaveClientIP = "LeaveClientIP";
        public const string _LeaveReason = "LeaveReason";
        public const string _LeaveTime = "LeaveTime";
        public const string _MatchFee = "MatchFee";
        public const string _MatchID = "MatchID";
        public const string _MatchNo = "MatchNo";
        public const string _OnLineTimeCount = "OnLineTimeCount";
        public const string _PlayTimeCount = "PlayTimeCount";
        public const string _Rank = "Rank";
        public const string _Revenue = "Revenue";
        public const string _ServerID = "ServerID";
        public const string _UserID = "UserID";



        //private int m_awardExperience;//奖励经验
        //private long m_awardGold;//奖励金币
        //private int m_awardMedal;//奖励奖牌
        //private string m_enterClientIP;//登录地址
        //private int m_enterExperience;//进入经验
        //private string m_enterMachine;//进入机器
        //private long m_enterScore;//进入积分
        //private DateTime m_enterTime;//进入时间
        //private int m_enterUserMedal;//进入奖牌
        //private int m_iD;//索引标识
        //private int m_kindID;//类型标识
        //private string m_leaveClientIP;//离开地址
        //private int m_leaveReason;//离开原因 0 正常结束离开  1 强退离开 2 未开赛离开
        //private DateTime m_leaveTime;//离开时间
        //private long m_matchFee;//报名费用
        //private int m_matchID;//比赛ID
        //private int m_matchNo;//比赛场次
        //private int m_onLineTimeCount;//在线时间
        //private int m_playTimeCount;//游戏时间
        //private int m_rank;//比赛名次
        //private long m_revenue;//税收/服务费
        //private int m_serverID;//房间标识
        //private int m_userID;//用户标识
       

      

        // Properties
        public int AwardExperience
        {
            get;
            set;
        }
        public long AwardGold
        {
            get;
            set;
        }
        public int AwardMedal
        {
            get;
            set;
        }
        public string EnterClientIP
        {
            get;
            set;
        }
        public int EnterExperience
        {
            get;
            set;
        }
        public string EnterMachine
        {
            get;
            set;
        }
        public long EnterScore
        {
            get;
            set;
        }
        public DateTime EnterTime
        {
            get;
            set;
        }
        public int EnterUserMedal
        {
            get;
            set;
        }
        public int ID
        {
            get;
            set;
        }
        public int KindID
        {
            get;
            set;
        }
        public string LeaveClientIP
        {
            get;
            set;
        }
        public int LeaveReason
        {
            get;
            set;
        }
        public DateTime LeaveTime
        {
            get;
            set;
        }
        public long MatchFee
        {
            get;
            set;
        }
        public int MatchID
        {
            get;
            set;
        }
        public int MatchNo
        {
            get;
            set;
        }
        public int OnLineTimeCount
        {
            get;
            set;
        }
        public int PlayTimeCount
        {
            get;
            set;
        }
        public int Rank
        {
            get;
            set;
        }
        public long Revenue
        {
            get;
            set;
        }
        public int ServerID
        {
            get;
            set;
        }
        public int UserID
        {
            get;
            set;
        }

    }
}
