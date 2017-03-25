using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Game.Entity.Treasure
{
    public class SpreadAdd
    {
        /// <summary>
        /// 表名
        /// </summary>
        public const string Tablename = "SpreadAddress";

       
     
        public const string _UserID = "UserID";

     
        public const string _Address = "Address";

        public const string _Addtime = "Addtime";


        private DateTime addtime;

        public DateTime Addtime
        {
            get
            {
                return addtime;
            }
            set
            {
                addtime = value;
            }
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

        private int userID;

        public int UserID
        {
            get
            {
                return userID;
            }
            set
            {
                userID = value;
            }
        }

      
        private string address;

        public string Address
        {
            get
            {
                return address;
            }
            set
            {
                address = value;
            }
        }


        
    }
}
