/*
 * 版本：4.0
 * 时间：2011-8-30
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
    /// 实体类 QPAdminSiteInfo。(属性说明自动提取数据库字段的描述信息)
    /// </summary>
    [Serializable]
    public partial class QPAdminSiteInfo
    {
        #region 常量

        /// <summary>
        /// 表名
        /// </summary>
        public const string Tablename = "QPAdminSiteInfo";

        /// <summary>
        /// 
        /// </summary>
        public const string _MainLogo = "MainLogo";
        /// <summary>
        /// 
        /// </summary>
        public const string _LoginLogo = "LoginLogo";
        public const string _SmtpServer = "SmtpServer";
        public const string _SendEmailUser = "SendEmailUser";
        public const string _SendEmailPwd = "SendEmailPwd";
        public const string _minTradeScore = "minTradeScore";
        public const string _registerlink = "registerlink";
        public const string _generalAgent = "generalAgent";
        /// <summary>
        /// 
        /// </summary>
        public const string _SiteID = "SiteID";

        /// <summary>
        /// 
        /// </summary>
        public const string _SiteName = "SiteName";

        /// <summary>
        /// 
        /// </summary>
        public const string _PageSize = "PageSize";

        /// <summary>
        /// 
        /// </summary>
        public const string _CopyRight = "CopyRight";

        /// <summary>
        /// 
        /// </summary>
        public const string _WaterMark = "WaterMark";
        #endregion

        #region 私有变量
        private int m_siteID;				//
        private string m_siteName;			//
        private int m_pageSize;				//
        private string m_copyRight;			//
        private string m_LoginLogo;			//
        private string m_WaterMark;
        private string m_SmtpServer;
        private string m_SendEmailUser;
        private string m_SendEmailPwd;
        private int m_minTradeScore;
        private string m_registerlink;
        private int m_generalAgent;
        #endregion

        #region 构造方法

        /// <summary>
        /// 初始化QPAdminSiteInfo
        /// </summary>
        public QPAdminSiteInfo()
        {
            m_siteID = 0;
            m_siteName = "";
            m_pageSize = 50;
            m_copyRight = "";
            m_LoginLogo = "";
            m_WaterMark = "";
            m_SmtpServer = "";
            m_SendEmailUser = "";
            m_SendEmailPwd = "";
            m_minTradeScore = 0;
            m_registerlink = "";
            m_generalAgent = 2;
        }

        #endregion

        #region 公共属性

        /// <summary>
        /// 
        /// </summary>
        public int SiteID
        {
            get { return m_siteID; }
            set { m_siteID = value; }
        }
        /// <summary>
        /// 
        /// </summary>
        public string LoginLogo
        {
            get { return m_LoginLogo; }
            set { m_LoginLogo = value; }
        }
        /// <summary>
        /// 
        /// </summary>
        public string WaterMark
        {
            get { return m_WaterMark; }
            set { m_WaterMark = value; }
        }
        /// <summary>
        /// 
        /// </summary>
        public string SiteName
        {
            get { return m_siteName; }
            set { m_siteName = value; }
        }

        /// <summary>
        /// 
        /// </summary>
        public int PageSize
        {
            get { return m_pageSize; }
            set { m_pageSize = value; }
        }

        /// <summary>
        /// 
        /// </summary>
        public string CopyRight
        {
            get { return m_copyRight; }
            set { m_copyRight = value; }
        }
        public string SmtpServer
        {
            get { return m_SmtpServer; }
            set { m_SmtpServer = value; }
        }
        public string SendEmailUser
        {
            get { return m_SendEmailUser; }
            set { m_SendEmailUser = value; }
        }
        public string SendEmailPwd
        {
            get { return m_SendEmailPwd; }
            set { m_SendEmailPwd = value; }
        }
        public int minTradeScore
        {
            get { return m_minTradeScore; }
            set { m_minTradeScore = value; }
        }
        public int generalAgent
        {
            get { return m_generalAgent; }
            set { m_generalAgent = value; }
        }
        public string registerlink
        {
            get { return m_registerlink; }
            set { m_registerlink = value; }
        }
        #endregion
    }
}
