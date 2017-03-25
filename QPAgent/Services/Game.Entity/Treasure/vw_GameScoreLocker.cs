using System;
using System.Collections.Generic;

namespace Game.Entity.Treasure
{
    /// <summary>
    /// 实体类 vw_GameScoreLocker。
    /// </summary>
    [Serializable]
    public partial class vw_GameScoreLocker
    {
        #region 常量

        /// <summary>
        /// 表名
        /// </summary>
        public const string Tablename = "vw_GameScoreLocker";
        /// <summary>
        /// 房间名称
        /// </summary>
        public const string _ServerName = "ServerName";
        /// <summary>
        /// 游戏名称
        /// </summary>
        public const string _KindName = "KindName";
        /// <summary>
        /// 用户索引
        /// </summary>
        public const string _UserID = "UserID";

        /// <summary>
        /// 房间索引
        /// </summary>
        public const string _KindID = "KindID";

        /// <summary>
        /// 游戏标识
        /// </summary>
        public const string _ServerID = "ServerID";

        /// <summary>
        /// 进出索引
        /// </summary>
        public const string _EnterID = "EnterID";

        /// <summary>
        /// 进入地址
        /// </summary>
        public const string _EnterIP = "EnterIP";

        /// <summary>
        /// 进入机器
        /// </summary>
        public const string _EnterMachine = "EnterMachine";

        /// <summary>
        /// 录入日期
        /// </summary>
        public const string _CollectDate = "CollectDate";
        #endregion

        #region 私有变量
        private string m_KindName;				
        private string m_ServerName;				
        private int m_userID;					//用户索引
        private int m_kindID;					//房间索引
        private int m_serverID;					//游戏标识
        private int m_enterID;					//进出索引
        private string m_enterIP;				//进入地址
        private string m_enterMachine;			//进入机器
        private DateTime m_collectDate;			//录入日期
        #endregion

        #region 构造方法

        /// <summary>
        /// 初始化GameScoreLocker
        /// </summary>
        public vw_GameScoreLocker()
        {
            m_ServerName = string.Empty;
            m_KindName = string.Empty;
            m_userID = 0;
            m_kindID = 0;
            m_serverID = 0;
            m_enterID = 0;
            m_enterIP = "";
            m_enterMachine = "";
            m_collectDate = DateTime.Now;
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
        /// <summary>
        /// 游戏名
        /// </summary>
        public string KindName
        {
            get { return m_KindName; }
            set { m_KindName = value; }
        }
        /// <summary>
        /// 用户索引
        /// </summary>
        public int UserID
        {
            get { return m_userID; }
            set { m_userID = value; }
        }

        /// <summary>
        /// 房间索引
        /// </summary>
        public int KindID
        {
            get { return m_kindID; }
            set { m_kindID = value; }
        }

        /// <summary>
        /// 游戏标识
        /// </summary>
        public int ServerID
        {
            get { return m_serverID; }
            set { m_serverID = value; }
        }

        /// <summary>
        /// 进出索引
        /// </summary>
        public int EnterID
        {
            get { return m_enterID; }
            set { m_enterID = value; }
        }

        /// <summary>
        /// 进入地址
        /// </summary>
        public string EnterIP
        {
            get { return m_enterIP; }
            set { m_enterIP = value; }
        }

        /// <summary>
        /// 进入机器
        /// </summary>
        public string EnterMachine
        {
            get { return m_enterMachine; }
            set { m_enterMachine = value; }
        }

        /// <summary>
        /// 录入日期
        /// </summary>
        public DateTime CollectDate
        {
            get { return m_collectDate; }
            set { m_collectDate = value; }
        }
        #endregion
    }
}
