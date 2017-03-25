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
    public partial class vw_RecordMatchUserInout
    {

        // Fields
        public const string Tablename = "vw_RecordMatchUserInout";
        /// <summary>
        /// 房间名称
        /// </summary>
        public const string _ServerName = "ServerName";
        /// <summary>
        /// 游戏名称
        /// </summary>
        public const string _KindName = "KindName";
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


        private string m_ServerName;
        private string m_KindName;
        private int m_awardExperience;//奖励经验
        private long m_awardGold;//奖励金币
        private int m_awardMedal;//奖励奖牌
        private string m_enterClientIP;//登录地址
        private int m_enterExperience;//进入经验
        private string m_enterMachine;//进入机器
        private long m_enterScore;//进入积分
        private DateTime m_enterTime;//进入时间
        private int m_enterUserMedal;//进入奖牌
        private int m_iD;//索引标识
        private int m_kindID;//类型标识
        private string m_leaveClientIP;//离开地址
        private int m_leaveReason;//离开原因 0 正常结束离开  1 强退离开 2 未开赛离开
        private DateTime m_leaveTime;//离开时间
        private long m_matchFee;//报名费用
        private int m_matchID;//比赛ID
        private int m_matchNo;//比赛场次
        private int m_onLineTimeCount;//在线时间
        private int m_playTimeCount;//游戏时间
        private int m_rank;//比赛名次
        private long m_revenue;//税收/服务费
        private int m_serverID;//房间标识
        private int m_userID;//用户标识

        public vw_RecordMatchUserInout()
        {
            m_ServerName = string.Empty;
            m_KindName = string.Empty;
            m_awardExperience = 0;//奖励经验
            m_awardGold = 0;//奖励金币
            m_awardMedal = 0;//奖励奖牌
            m_enterClientIP = "";//登录地址
            m_enterExperience = 0;//进入经验
            m_enterMachine = "";//进入机器
            m_enterScore = 0;//进入积分
            m_enterTime = DateTime.Now;//进入时间
            m_enterUserMedal = 0;//进入奖牌
            m_iD = 0;//索引标识
            m_kindID = 0;//类型标识
            m_leaveClientIP = "";//离开地址
            m_leaveReason = 0;//离开原因 0 正常结束离开  1 强退离开 2 未开赛离开
            m_leaveTime = DateTime.Now;//离开时间
            m_matchFee = 0;//报名费用
            m_matchID = 0;//比赛ID
            m_matchNo = 0;//比赛场次
            m_onLineTimeCount = 0;//在线时间
            m_playTimeCount = 0;//游戏时间
            m_rank = 0;//比赛名次
            m_revenue = 0;//税收/服务费
            m_serverID = 0;//房间标识
            m_userID = 0;//用户标识
        }


        // Properties
        /// <summary>
        /// 房间名
        /// </summary>
        public string ServerName
        {
            get { return m_ServerName; }
            set { m_ServerName = value; }
        }
        /// <summary>
        /// 游戏名
        /// </summary>
        public string KindName
        {
            get { return m_KindName; }
            set { m_KindName = value; }
        }
        public int AwardExperience
        {
            get { return m_awardExperience; }
            set { m_awardExperience = value; }
        }
        public long AwardGold
        {
            get { return m_awardGold; }
            set { m_awardGold = value; }
        }
        public int AwardMedal
        {
            get { return m_awardMedal; }
            set { m_awardMedal = value; }
        }
        public string EnterClientIP
        {
            get { return m_enterClientIP; }
            set { m_enterClientIP = value; }
        }
        public int EnterExperience
        {
            get { return m_enterExperience; }
            set { m_enterExperience = value; }
        }
        public string EnterMachine
        {
            get { return m_enterMachine; }
            set { m_enterMachine = value; }
        }
        public long EnterScore
        {
            get { return m_enterScore; }
            set { m_enterScore = value; }
        }
        public DateTime EnterTime
        {
            get { return m_enterTime; }
            set { m_enterTime = value; }
        }
        public int EnterUserMedal
        {
            get { return m_enterUserMedal; }
            set { m_enterUserMedal = value; }
        }
        public int ID
        {
            get { return m_iD; }
            set { m_iD = value; }
        }
        public int KindID
        {
            get { return m_kindID; }
            set { m_kindID = value; }
        }
        public string LeaveClientIP
        {
            get { return m_leaveClientIP; }
            set { m_leaveClientIP = value; }
        }
        public int LeaveReason
        {
            get { return m_leaveReason; }
            set { m_leaveReason = value; }
        }
        public DateTime LeaveTime
        {
            get { return m_leaveTime; }
            set { m_leaveTime = value; }
        }
        public long MatchFee
        {
            get { return m_matchFee; }
            set { m_matchFee = value; }
        }
        public int MatchID
        {
            get { return m_matchID; }
            set { m_matchID = value; }
        }
        public int MatchNo
        {
            get { return m_matchNo; }
            set { m_matchNo = value; }
        }
        public int OnLineTimeCount
        {
            get { return m_onLineTimeCount; }
            set { m_onLineTimeCount = value; }
        }
        public int PlayTimeCount
        {
            get { return m_playTimeCount; }
            set { m_playTimeCount = value; }
        }
        public int Rank
        {
            get { return m_rank; }
            set { m_rank = value; }
        }
        public long Revenue
        {
            get { return m_revenue; }
            set { m_revenue = value; }
        }
        public int ServerID
        {
            get { return m_serverID; }
            set { m_serverID = value; }
        }
        public int UserID
        {
            get { return m_userID; }
            set { m_userID = value; }
        }

    }
}
