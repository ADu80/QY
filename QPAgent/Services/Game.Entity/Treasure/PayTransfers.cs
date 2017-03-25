using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Game.Entity.Treasure
{
    [Serializable]
    public partial class PayTransfers
    {

        /// <summary>
        /// 表名
        /// </summary>
        public const string Tablename = "PayTransfer";


        private int plyid;//int identity(1,1) not null,

        public int Plyid
        {
            get
            {
                return plyid;
            }
            set
            {
                plyid = value;
            }
        }
        private int userID; //int not null,

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
        private string accounts;// nvarchar(30) not null,

        public string Accounts
        {
            get
            {
                return accounts;
            }
            set
            {
                accounts = value;
            }
        }
        private int cardTypeID;// int not null,

        public int CardTypeID
        {
            get
            {
                return cardTypeID;
            }
            set
            {
                cardTypeID = value;
            }
        }
        private decimal cardPrice;// decimal(18,2) not null,

        public decimal CardPrice
        {
            get
            {
                return cardPrice;
            }
            set
            {
                cardPrice = value;
            }
        }
        private string iPAddress; //nvarchar(15)not null

        public string IPAddress
        {
            get
            {
                return iPAddress;
            }
            set
            {
                iPAddress = value;
            }
        }
        private byte status;

        public byte Status
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

        private DateTime payDate;

        public DateTime PayDate
        {
            get
            {
                return payDate;
            }
            set
            {
                payDate = value;
            }
        }
    }
}
