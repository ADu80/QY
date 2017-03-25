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
    public partial class vw_SubAgentList
    {
        #region 常量

        /// <summary>
        /// 表名
        /// </summary>
        public const string Tablename = "vw_SubAgentList";

        /// <summary>
        /// 角色流水标识
        /// </summary>
        public const string _UserID = "UserID";
        /// <summary>
        /// 角色流水标识
        /// </summary>
        public const string _UserName = "UserName";

        /// <summary>
        /// 角色名称
        /// </summary>
        public const string _RoleName = "RoleName";

        /// <summary>
        /// 角色描述
        /// </summary>
        public const string _Nullity = "Nullity";

        /// <summary>
        /// 操作人
        /// </summary>
        public const string _LastLogintime = "LastLogintime";

        /// <summary>
        /// 创建时间
        /// </summary>
        public const string _LastLoginIP = "LastLoginIP";

        #endregion


        #region 公共属性

        /// <summary>
        /// 角色流水标识
        /// </summary>
        public int UserID { get; set; }

        /// <summary>
        /// 代理商账号
        /// </summary>
        public string UserName { get; set; }

        /// <summary>
        /// 角色名称
        /// </summary>
        public string RoleName { get; set; }

        /// <summary>
        /// 角色描述
        /// </summary>
        public bool Nullity { get; set; }

        /// <summary>
        /// 操作人
        /// </summary>
        public DateTime LastLogintime { get; set; }

        /// <summary>
        /// 最近登录IP
        /// </summary>
        public string LastLoginIP { get; set; }


        #endregion
    }
}
