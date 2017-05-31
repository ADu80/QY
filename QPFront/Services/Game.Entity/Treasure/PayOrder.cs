/*
 * 版本：4.0
 * 时间：2011-8-1
 * 作者：http://www.foxuc.com
 *
 * 描述：实体类
 *
 */

using System;
using System.Collections.Generic;

namespace Game.Entity.Treasure
{
    /// <summary>
    /// 实体类 OnLineOrder。(属性说明自动提取数据库字段的描述信息)
    /// </summary>
    [Serializable]
    public partial class PayOrder
    {
        public string UserID { get; set; }
        public string PayState { get; set; }
        public string PayType { get; set; }
        public string BuyCount { get; set; }
        public string BackCount { get; set; }
        public string OrderID { get; set; }
        public string ChannelOrderID { get; set; }
        public string Present { get; set; }
    }
}
