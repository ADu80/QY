using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Game.Entity.Treasure
{
    public class MobliePay
    {

        #region 常量

        /// <summary>
        /// 表名
        /// </summary>
        public const string Tablename = "MobliePay";

        public const string _id = "id";

        public const string _userId = "userid";
        public const string _orderid = "orderid";
        public const string _price = "price";
        public const string _addTime = "addTime";
        public const string _status = "status";
        public const string _contents = "contents";
        public const string _typeId = "typeid";
        public const string _score = "score";

        #endregion


        /// <summary>
        /// 无参构造方法
        /// </summary>

        public MobliePay()
        {
            this.id = 0;
            this.userId = 0;
            this.orderid = "";
            this.price = 0;
            this.addTime = DateTime.Now;
            this.status = 0;
            this.contents = "";
            this.typeId = 0;
            this.score = 0;
        }

        private int id;
        public int Id
        {
            get
            {
                return id;
            }
            set
            {
                id = value;
            }
        }

        private int userId;
        public int UserId
        {
            get
            {
                return userId;
            }
            set
            {
                userId = value;
            }
        }

        private string orderid;
        public string Orderid
        {
            get
            {
                return orderid;
            }
            set
            {
                orderid = value;
            }
        }

        private int price;
        public int Price
        {
            get
            {
                return price;
            }
            set
            {
                price = value;
            }
        }

        private DateTime addTime;
        public DateTime AddTime
        {
            get
            {
                return addTime;
            }
            set
            {
                addTime = value;
            }
        }

        private int status;
        public int Status
        {
            get
            {
                return status;
            }
            set
            {
                status = value;
            }
        }

        private string contents;
        public string Contents
        {
            get
            {
                return contents;
            }
            set
            {
                contents = value;
            }
        }

        private int typeId;
        public int TypeId
        {
            get
            {
                return typeId;
            }
            set
            {
                typeId = value;
            }
        }

        private int score;
        public int Score
        {
            get
            {
                return score;
            }
            set
            {
                score = value;
            }
        }
    }
}
