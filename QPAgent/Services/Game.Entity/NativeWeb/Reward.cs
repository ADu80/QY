using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Game.Entity.NativeWeb
{
     public class Reward
    {
        /// <summary>
        /// 表名
        /// </summary>
        public const string Tablename = "Reward";
        public const string _id = "id";
        public const string _price = "price";

        public const string _addTime = "addTime";




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
        private int price;//

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
        private DateTime addTime;//时间 

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

        /// <summary>
        /// 无参构造方法
        /// </summary>
        public Reward()
        {
            this.id = 0;
            this.price = 0;
            this.addTime = DateTime.Now;
        }
    }
}
