/*
 * 版本：4.0
 * 时间：2011-12-12
 * 作者：http://www.foxuc.com
 *
 * 描述：实体类
 *
 */

using System;
using System.Collections.Generic;

namespace Game.Entity.PlatformManager
{
	/// <summary>
	/// 实体类 Base_Users。(属性说明自动提取数据库字段的描述信息)
	/// </summary>
	[Serializable]
	public partial class Base_Users  
	{
		#region 常量

		/// <summary>
		/// 表名
		/// </summary>
		public const string Tablename = "Base_Users" ;
        /// <summary>
        /// NULL为管理员 大于为代理
        /// </summary>
        public const string _VipID = "VipID";
        /// <summary>
        /// NULL为管理员 大于为代理
        /// </summary>
        public const string _AgentID = "AgentID";
		/// <summary>
		/// 管理员ID
		/// </summary>
		public const string _UserID = "UserID" ;

		/// <summary>
		/// 帐号
		/// </summary>
		public const string _Username = "Username" ;

		/// <summary>
		/// 密码
		/// </summary>
		public const string _Password = "Password" ;

		/// <summary>
		/// 角色ID
		/// </summary>
		public const string _RoleID = "RoleID" ;

		/// <summary>
		/// 冻结标志 0-启用，1-冻结
		/// </summary>
		public const string _Nullity = "Nullity" ;

		/// <summary>
		/// 
		/// </summary>
		public const string _PreLogintime = "PreLogintime" ;

		/// <summary>
		/// 
		/// </summary>
		public const string _PreLoginIP = "PreLoginIP" ;

		/// <summary>
		/// 
		/// </summary>
		public const string _LastLogintime = "LastLogintime" ;

		/// <summary>
		/// 
		/// </summary>
		public const string _LastLoginIP = "LastLoginIP" ;

		/// <summary>
		/// 
		/// </summary>
		public const string _LoginTimes = "LoginTimes" ;

		/// <summary>
		/// 绑定IP 0-绑定 1-未绑定
		/// </summary>
		public const string _IsBand = "IsBand" ;

		/// <summary>
		/// 
		/// </summary>
		public const string _BandIP = "BandIP" ;

        public const string _Percentage = "Percentage";

        public const string _AgentLevel = "AgentLevel";

        /// <summary>
        /// 是否可以发展下级代理
        /// </summary>
        public const string _canHasSubAgent = "canHasSubAgent";

        /// <summary>
        /// 可发展代理层级
        /// </summary>
        public const string _AgentLevelLimit = "AgentLevelLimit";


        #endregion

        #region 私有变量
        private int m_VipID;
        private int m_AgentID;
		private int m_userID;						//管理员ID
		private string m_username;					//帐号
		private string m_password;					//密码
		private int m_roleID;						//角色ID
		private byte m_nullity;						//冻结标志 0-启用，1-冻结
		private DateTime m_preLogintime;			//
		private string m_preLoginIP;				//
		private DateTime m_lastLogintime;			//
		private string m_lastLoginIP;				//
		private int m_loginTimes;					//
		private int m_isBand;						//绑定IP 0-绑定 1-未绑定
		private string m_bandIP;					//
        private int m_percentage;

        public int Percentage
        {
            get
            {
                return m_percentage;
            }
            set
            {
                m_percentage = value;
            }
        }	

		#endregion

		#region 构造方法

		/// <summary>
		/// 初始化Base_Users
		/// </summary>
		public Base_Users()
		{
            m_VipID = 0;
            m_AgentID = 0;
			m_userID=0;
			m_username="";
			m_password="";
			m_roleID=0;
			m_nullity=0;
			m_preLogintime=DateTime.Now;
			m_preLoginIP="";
			m_lastLogintime=DateTime.Now;
			m_lastLoginIP="";
			m_loginTimes=0;
			m_isBand=0;
			m_bandIP="";
		}

		#endregion

		#region 公共属性
        public int VipID
        {
            get { return m_VipID; }
            set { m_VipID = value; }
        }
        public int AgentID
        {
            get { return m_AgentID; }
            set { m_AgentID = value; }
        }
		/// <summary>
		/// 管理员ID
		/// </summary>
		public int UserID
		{
			get { return m_userID; }
			set { m_userID = value; }
		}

		/// <summary>
		/// 帐号
		/// </summary>
		public string Username
		{
			get { return m_username; }
			set { m_username = value; }
		}

		/// <summary>
		/// 密码
		/// </summary>
		public string Password
		{
			get { return m_password; }
			set { m_password = value; }
		}

		/// <summary>
		/// 角色ID
		/// </summary>
		public int RoleID
		{
			get { return m_roleID; }
			set { m_roleID = value; }
		}

		/// <summary>
		/// 冻结标志 0-启用，1-冻结
		/// </summary>
		public byte Nullity
		{
			get { return m_nullity; }
			set { m_nullity = value; }
		}

		/// <summary>
		/// 
		/// </summary>
		public DateTime PreLogintime
		{
			get { return m_preLogintime; }
			set { m_preLogintime = value; }
		}

		/// <summary>
		/// 
		/// </summary>
		public string PreLoginIP
		{
			get { return m_preLoginIP; }
			set { m_preLoginIP = value; }
		}

		/// <summary>
		/// 
		/// </summary>
		public DateTime LastLogintime
		{
			get { return m_lastLogintime; }
			set { m_lastLogintime = value; }
		}

		/// <summary>
		/// 
		/// </summary>
		public string LastLoginIP
		{
			get { return m_lastLoginIP; }
			set { m_lastLoginIP = value; }
		}

		/// <summary>
		/// 
		/// </summary>
		public int LoginTimes
		{
			get { return m_loginTimes; }
			set { m_loginTimes = value; }
		}

		/// <summary>
		/// 绑定IP 0-绑定 1-未绑定
		/// </summary>
		public int IsBand
		{
			get { return m_isBand; }
			set { m_isBand = value; }
		}

		/// <summary>
		/// 
		/// </summary>
		public string BandIP
		{
			get { return m_bandIP; }
			set { m_bandIP = value; }
		}
        #endregion

        #region 新增 2016-11-18 10:36
        /// <summary>
        /// 代理层级
        /// </summary>
        public int AgentLevel { get; set; }

        /// <summary>
        /// 是否可以发展下级代理
        /// </summary>
        public byte canHasSubAgent { get; set; }

        /// <summary>
        /// 可发展代理层级
        /// </summary>
        public int AgentLevelLimit { get; set; }
        public int GradeID { get; set; }
        #endregion

        public int IsJsCount { get; set; }
    }
}
