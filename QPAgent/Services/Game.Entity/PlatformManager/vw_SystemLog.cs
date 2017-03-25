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
    /// 实体类 Base_Roles。(属性说明自动提取数据库字段的描述信息)
    /// </summary>
    [Serializable]
    public partial class vw_SystemLog
    {
        #region 常量

        /// <summary>
        /// 表名
        /// </summary>
        public const string Tablename = "vw_SystemLog";

        /// <summary>
        /// ID
        /// </summary>
        public const string _ID = "ID";

        /// <summary>
        /// 日志内容
        /// </summary>
        public const string _LogContent = "LogContent";

        /// <summary>
        /// 日志时间
        /// </summary>
        public const string _LogTime = "LogTime";

        /// <summary>
        /// 操作人
        /// </summary>
        public const string _Operator = "Operator";

        /// <summary>
        /// 登录IP
        /// </summary>
        public const string _LoginIP = "LoginIP";

        /// <summary>
        /// 
        /// </summary>
        public const string _Operation = "Operation";

        #endregion


        #region 公共属性

        /// <summary>
        /// ID
        /// </summary>
        public int ID { get; set; }

        /// <summary>
        /// 内容
        /// </summary>
        public string LogContent { get; set; }

        /// <summary>
        /// 记录时间
        /// </summary>
        public DateTime LogTime { get; set; }

        /// <summary>
        /// 操作人
        /// </summary>
        public string Operator { get; set; }

        /// <summary>
        /// 登录IP
        /// </summary>
        public string LoginIP { get; set; }

        /// <summary>
        /// 操作类型
        /// </summary>
        public string Operation { get; set; }


        #endregion
    }
}
