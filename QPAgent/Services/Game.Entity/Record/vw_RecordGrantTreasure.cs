using System;
using System.Collections.Generic;

namespace Game.Entity.Record
{
    /// <summary>
    /// 实体类 vw_RecordGrantTreasure。(属性说明自动提取数据库字段的描述信息)
    /// </summary>
    [Serializable]
    public partial class vw_RecordGrantTreasure
    {
        #region 常量

        /// <summary>
        /// 表名
        /// </summary>
        public const string Tablename = "vw_RecordGrantTreasure";
        public const string _Accounts = "Accounts";
        public const string _UserName = "UserName";
        public const string _AfterGold = "AfterGold";
        /// <summary>
        /// 记录标识
        /// </summary>
        public const string _RecordID = "RecordID";

        /// <summary>
        /// 管理员标识
        /// </summary>
        public const string _MasterID = "MasterID";

        /// <summary>
        /// 来访地址
        /// </summary>
        public const string _ClientIP = "ClientIP";

        /// <summary>
        /// 操作日期
        /// </summary>
        public const string _CollectDate = "CollectDate";

        /// <summary>
        /// 用户标识
        /// </summary>
        public const string _UserID = "UserID";

        /// <summary>
        /// 当前金币
        /// </summary>
        public const string _CurGold = "CurGold";

        /// <summary>
        /// 增加金币
        /// </summary>
        public const string _AddGold = "AddGold";

        /// <summary>
        /// 操作理由
        /// </summary>
        public const string _Reason = "Reason";
        #endregion

        #region 私有变量
        private string m_Accounts;
        private string m_UserName;
        private int m_AfterGold;
        private int m_recordID;					//记录标识
        private int m_masterID;					//管理员标识
        private string m_clientIP;				//来访地址
        private DateTime m_collectDate;			//操作日期
        private int m_userID;					//用户标识
        private long m_curGold;					//当前金币
        private long m_addGold;					//增加金币
        private string m_reason;				//操作理由
        #endregion

        #region 构造方法

        /// <summary>
        /// 初始化vw_RecordGrantTreasure
        /// </summary>
        public vw_RecordGrantTreasure()
        {
            m_Accounts = "";
            m_UserName = string.Empty;
            m_AfterGold = 0;
            m_recordID = 0;
            m_masterID = 0;
            m_clientIP = "";
            m_collectDate = DateTime.Now;
            m_userID = 0;
            m_curGold = 0;
            m_addGold = 0;
            m_reason = "";
        }

        #endregion

        #region 公共属性
        public string Accounts
        {
            get { return m_Accounts; }
            set { m_Accounts = value; }
        }
        public string UserName
        {
            get { return m_UserName; }
            set { m_UserName = value; }
        }
        public int AfterGold
        {
            get { return m_AfterGold; }
            set { m_AfterGold = value; }
        }
        /// <summary>
        /// 记录标识
        /// </summary>
        public int RecordID
        {
            get { return m_recordID; }
            set { m_recordID = value; }
        }

        /// <summary>
        /// 管理员标识
        /// </summary>
        public int MasterID
        {
            get { return m_masterID; }
            set { m_masterID = value; }
        }

        /// <summary>
        /// 来访地址
        /// </summary>
        public string ClientIP
        {
            get { return m_clientIP; }
            set { m_clientIP = value; }
        }

        /// <summary>
        /// 操作日期
        /// </summary>
        public DateTime CollectDate
        {
            get { return m_collectDate; }
            set { m_collectDate = value; }
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
        /// 当前金币
        /// </summary>
        public long CurGold
        {
            get { return m_curGold; }
            set { m_curGold = value; }
        }

        /// <summary>
        /// 增加金币
        /// </summary>
        public long AddGold
        {
            get { return m_addGold; }
            set { m_addGold = value; }
        }

        /// <summary>
        /// 操作理由
        /// </summary>
        public string Reason
        {
            get { return m_reason; }
            set { m_reason = value; }
        }
        #endregion
    }
}