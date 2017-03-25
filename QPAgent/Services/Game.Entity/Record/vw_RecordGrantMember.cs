using System;
using System.Collections.Generic;

namespace Game.Entity.Record
{
    /// <summary>
    /// 实体类 vw_RecordGrantMember。(属性说明自动提取数据库字段的描述信息)
    /// </summary>
    [Serializable]
    public partial class vw_RecordGrantMember
    {
        #region 常量

        /// <summary>
        /// 表名
        /// </summary>
        public const string Tablename = "vw_RecordGrantMember";

        public const string _Accounts = "Accounts";
        public const string _UserName = "UserName";
        /// <summary>
        /// 记录标识
        /// </summary>
        public const string _RecordID = "RecordID";

        /// <summary>
        /// 管理员
        /// </summary>
        public const string _MasterID = "MasterID";

        /// <summary>
        /// 客户端IP
        /// </summary>
        public const string _ClientIP = "ClientIP";

        /// <summary>
        /// 赠送时间
        /// </summary>
        public const string _CollectDate = "CollectDate";

        /// <summary>
        /// 玩家标识
        /// </summary>
        public const string _UserID = "UserID";

        /// <summary>
        /// 赠送的会员卡类别
        /// </summary>
        public const string _GrantCardType = "GrantCardType";

        /// <summary>
        /// 赠送会员卡原因
        /// </summary>
        public const string _Reason = "Reason";

        /// <summary>
        /// 
        /// </summary>
        public const string _MemberDays = "MemberDays";
        #endregion

        #region 私有变量
        private string m_Accounts;
        private string m_UserName;
        private int m_recordID;				//记录标识
        private int m_masterID;				//管理员
        private string m_clientIP;			//客户端IP
        private DateTime m_collectDate;		//赠送时间
        private int m_userID;				//玩家标识
        private int m_grantCardType;		//赠送的会员卡类别
        private string m_reason;			//赠送会员卡原因
        private int m_memberDays;			//
        #endregion

        #region 构造方法

        /// <summary>
        /// 初始化vw_RecordGrantMember
        /// </summary>
        public vw_RecordGrantMember()
        {
            m_Accounts = "";
            m_UserName = string.Empty;
            m_recordID = 0;
            m_masterID = 0;
            m_clientIP = "";
            m_collectDate = DateTime.Now;
            m_userID = 0;
            m_grantCardType = 0;
            m_reason = "";
            m_memberDays = 0;
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
        /// <summary>
        /// 记录标识
        /// </summary>
        public int RecordID
        {
            get { return m_recordID; }
            set { m_recordID = value; }
        }

        /// <summary>
        /// 管理员
        /// </summary>
        public int MasterID
        {
            get { return m_masterID; }
            set { m_masterID = value; }
        }

        /// <summary>
        /// 客户端IP
        /// </summary>
        public string ClientIP
        {
            get { return m_clientIP; }
            set { m_clientIP = value; }
        }

        /// <summary>
        /// 赠送时间
        /// </summary>
        public DateTime CollectDate
        {
            get { return m_collectDate; }
            set { m_collectDate = value; }
        }

        /// <summary>
        /// 玩家标识
        /// </summary>
        public int UserID
        {
            get { return m_userID; }
            set { m_userID = value; }
        }

        /// <summary>
        /// 赠送的会员卡类别
        /// </summary>
        public int GrantCardType
        {
            get { return m_grantCardType; }
            set { m_grantCardType = value; }
        }

        /// <summary>
        /// 赠送会员卡原因
        /// </summary>
        public string Reason
        {
            get { return m_reason; }
            set { m_reason = value; }
        }

        /// <summary>
        /// 
        /// </summary>
        public int MemberDays
        {
            get { return m_memberDays; }
            set { m_memberDays = value; }
        }
        #endregion
    }
}
