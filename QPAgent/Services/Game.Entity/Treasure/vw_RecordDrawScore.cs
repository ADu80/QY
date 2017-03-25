using System;
using System.Collections.Generic;

namespace Game.Entity.Treasure
{
    /// <summary>
    /// 实体类 vw_RecordDrawScore。(属性说明自动提取数据库字段的描述信息)
    /// </summary>
    [Serializable]
    public partial class vw_RecordDrawScore
    {
        #region 常量

        /// <summary>
        /// 表名
        /// </summary>
        public const string Tablename = "vw_RecordDrawScore";
        public const string _Accounts = "Accounts";
        public const string _IsAndroid = "IsAndroid";
        /// <summary>
        /// 局数标识
        /// </summary>
        public const string _DrawID = "DrawID";

        /// <summary>
        /// 用户标识
        /// </summary>
        public const string _UserID = "UserID";

        /// <summary>
        /// 椅子号码
        /// </summary>
        public const string _ChairID = "ChairID";

        /// <summary>
        /// 用户成绩
        /// </summary>
        public const string _Score = "Score";

        /// <summary>
        /// 用户积分
        /// </summary>
        public const string _Grade = "Grade";

        /// <summary>
        /// 税收数目
        /// </summary>
        public const string _Revenue = "Revenue";

        /// <summary>
        /// 用户奖牌
        /// </summary>
        public const string _UserMedal = "UserMedal";

        /// <summary>
        /// 游戏时长
        /// </summary>
        public const string _PlayTimeCount = "PlayTimeCount";

        /// <summary>
        /// 插入时间
        /// </summary>
        public const string _InsertTime = "InsertTime";
        #endregion

        #region 私有变量
        private int m_IsAndroid;
        private string m_Accounts;
        private int m_drawID;				//局数标识
        private int m_userID;				//用户标识
        private int m_chairID;				//椅子号码
        private long m_score;				//用户成绩
        private long m_grade;				//用户积分
        private long m_revenue;				//税收数目
        private int m_userMedal;			//用户奖牌
        private int m_playTimeCount;		//游戏时长
        private DateTime m_insertTime;		//插入时间
        #endregion

        #region 构造方法

        /// <summary>
        /// 初始化vw_RecordDrawScore
        /// </summary>
        public vw_RecordDrawScore()
        {
            m_Accounts = string.Empty;
            m_IsAndroid = 0;
            m_drawID = 0;
            m_userID = 0;
            m_chairID = 0;
            m_score = 0;
            m_grade = 0;
            m_revenue = 0;
            m_userMedal = 0;
            m_playTimeCount = 0;
            m_insertTime = DateTime.Now;
        }

        #endregion

        #region 公共属性
        public int IsAndroid
        {
            get { return m_IsAndroid; }
            set { m_IsAndroid = value; }
        }
        public string Accounts
        {
            get { return m_Accounts; }
            set { m_Accounts = value; }
        }
        /// <summary>
        /// 局数标识
        /// </summary>
        public int DrawID
        {
            get { return m_drawID; }
            set { m_drawID = value; }
        }

        /// <summary>
        /// 用户标识
        /// </summary>
        public int UserID
        {
            get { return m_userID; }
            set { m_userID = value; }
        }

        /// <summary>
        /// 椅子号码
        /// </summary>
        public int ChairID
        {
            get { return m_chairID; }
            set { m_chairID = value; }
        }

        /// <summary>
        /// 用户成绩
        /// </summary>
        public long Score
        {
            get { return m_score; }
            set { m_score = value; }
        }

        /// <summary>
        /// 用户积分
        /// </summary>
        public long Grade
        {
            get { return m_grade; }
            set { m_grade = value; }
        }

        /// <summary>
        /// 税收数目
        /// </summary>
        public long Revenue
        {
            get { return m_revenue; }
            set { m_revenue = value; }
        }

        /// <summary>
        /// 用户奖牌
        /// </summary>
        public int UserMedal
        {
            get { return m_userMedal; }
            set { m_userMedal = value; }
        }

        /// <summary>
        /// 游戏时长
        /// </summary>
        public int PlayTimeCount
        {
            get { return m_playTimeCount; }
            set { m_playTimeCount = value; }
        }

        /// <summary>
        /// 插入时间
        /// </summary>
        public DateTime InsertTime
        {
            get { return m_insertTime; }
            set { m_insertTime = value; }
        }
        #endregion
    }
}