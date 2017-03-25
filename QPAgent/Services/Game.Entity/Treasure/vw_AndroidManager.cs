using System;
using System.Collections.Generic;

namespace Game.Entity.Treasure
{
    /// <summary>
    /// 实体类 AndroidManager。(属性说明自动提取数据库字段的描述信息)
    /// </summary>
    [Serializable]
    public partial class vw_AndroidManager
    {
        #region 常量

        /// <summary>
        /// 表名
        /// </summary>
        public const string Tablename = "vw_AndroidManager";
        public const string _ServerName = "ServerName";
        /// <summary>
        /// GameID
        /// </summary>
        public const string _GameID = "GameID";
        /// <summary>
        /// Accounts
        /// </summary>
        public const string _Accounts = "Accounts";
        /// <summary>
        /// NickName
        /// </summary>
        public const string _NickName = "NickName";
        /// <summary>
        /// FaceID
        /// </summary>
        public const string _FaceID = "FaceID";
        /// <summary>
        /// 用户标识
        /// </summary>
        public const string _UserID = "UserID";

        /// <summary>
        /// 房间标识
        /// </summary>
        public const string _ServerID = "ServerID";

        /// <summary>
        /// 最少局数
        /// </summary>
        public const string _MinPlayDraw = "MinPlayDraw";

        /// <summary>
        /// 最大局数
        /// </summary>
        public const string _MaxPlayDraw = "MaxPlayDraw";

        /// <summary>
        /// 最少分数
        /// </summary>
        public const string _MinTakeScore = "MinTakeScore";

        /// <summary>
        /// 最高分数
        /// </summary>
        public const string _MaxTakeScore = "MaxTakeScore";

        /// <summary>
        /// 最少休息
        /// </summary>
        public const string _MinReposeTime = "MinReposeTime";

        /// <summary>
        /// 最大休息
        /// </summary>
        public const string _MaxReposeTime = "MaxReposeTime";

        /// <summary>
        /// 
        /// </summary>
        public const string _ServiceTime = "ServiceTime";

        /// <summary>
        /// 服务类型
        /// </summary>
        public const string _ServiceGender = "ServiceGender";

        /// <summary>
        /// 禁止标志
        /// </summary>
        public const string _Nullity = "Nullity";

        /// <summary>
        /// 
        /// </summary>
        public const string _CreateDate = "CreateDate";

        /// <summary>
        /// 备注信息
        /// </summary>
        public const string _AndroidNote = "AndroidNote";
        #endregion

        #region 私有变量
        private string m_ServerName;	
        private int m_GameID;
        private string m_Accounts;
        private string m_NickName;
        private int m_FaceID;	
        private int m_userID;				//用户标识
        private int m_serverID;				//房间标识
        private int m_minPlayDraw;			//最少局数
        private int m_maxPlayDraw;			//最大局数
        private long m_minTakeScore;		//最少分数
        private long m_maxTakeScore;		//最高分数
        private int m_minReposeTime;		//最少休息
        private int m_maxReposeTime;		//最大休息
        private int m_serviceTime;			//
        private int m_serviceGender;		//服务类型
        private byte m_nullity;				//禁止标志
        private DateTime m_createDate;		//
        private string m_androidNote;		//备注信息
        #endregion

        #region 构造方法

        /// <summary>
        /// 初始化vw_AndroidManager
        /// </summary>
        public vw_AndroidManager()
        {
            m_ServerName = string.Empty;
            m_Accounts = string.Empty;
            m_GameID = 0;
            m_NickName = string.Empty;
            m_FaceID = 0;
            m_userID = 0;
            m_serverID = 0;
            m_minPlayDraw = 0;
            m_maxPlayDraw = 0;
            m_minTakeScore = 0;
            m_maxTakeScore = 0;
            m_minReposeTime = 0;
            m_maxReposeTime = 0;
            m_serviceTime = 0;
            m_serviceGender = 0;
            m_nullity = 0;
            m_createDate = DateTime.Now;
            m_androidNote = "";
        }

        #endregion

        #region 公共属性
        /// <summary>
        /// 房间名
        /// </summary>
        public string ServerName
        {
            get { return m_ServerName; }
            set { m_ServerName = value; }
        }
        public int GameID
        {
            get
            {
                return m_GameID;
            }
            set
            {
                m_GameID = value;
            }
        }
        public int FaceID
        {
            get
            {
                return m_FaceID;
            }
            set
            {
                m_FaceID = value;
            }
        }
        public string Accounts
        {
            get
            {
                return m_Accounts;
            }
            set
            {
                m_Accounts = value;
            }
        }
        public string NickName
        {
            get
            {
                return m_NickName;
            }
            set
            {
                m_NickName = value;
            }
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
        /// 房间标识
        /// </summary>
        public int ServerID
        {
            get { return m_serverID; }
            set { m_serverID = value; }
        }

        /// <summary>
        /// 最少局数
        /// </summary>
        public int MinPlayDraw
        {
            get { return m_minPlayDraw; }
            set { m_minPlayDraw = value; }
        }

        /// <summary>
        /// 最大局数
        /// </summary>
        public int MaxPlayDraw
        {
            get { return m_maxPlayDraw; }
            set { m_maxPlayDraw = value; }
        }

        /// <summary>
        /// 最少分数
        /// </summary>
        public long MinTakeScore
        {
            get { return m_minTakeScore; }
            set { m_minTakeScore = value; }
        }

        /// <summary>
        /// 最高分数
        /// </summary>
        public long MaxTakeScore
        {
            get { return m_maxTakeScore; }
            set { m_maxTakeScore = value; }
        }

        /// <summary>
        /// 最少休息
        /// </summary>
        public int MinReposeTime
        {
            get { return m_minReposeTime; }
            set { m_minReposeTime = value; }
        }

        /// <summary>
        /// 最大休息
        /// </summary>
        public int MaxReposeTime
        {
            get { return m_maxReposeTime; }
            set { m_maxReposeTime = value; }
        }

        /// <summary>
        /// 
        /// </summary>
        public int ServiceTime
        {
            get { return m_serviceTime; }
            set { m_serviceTime = value; }
        }

        /// <summary>
        /// 服务类型
        /// </summary>
        public int ServiceGender
        {
            get { return m_serviceGender; }
            set { m_serviceGender = value; }
        }

        /// <summary>
        /// 禁止标志
        /// </summary>
        public byte Nullity
        {
            get { return m_nullity; }
            set { m_nullity = value; }
        }

        /// <summary>
        /// 
        /// </summary>
        public DateTime CreateDate
        {
            get { return m_createDate; }
            set { m_createDate = value; }
        }

        /// <summary>
        /// 备注信息
        /// </summary>
        public string AndroidNote
        {
            get { return m_androidNote; }
            set { m_androidNote = value; }
        }
        #endregion
    }
}
