using System;

namespace QPNativeWebDB.DbEntity
{
    #region 封装类t_Products
    /// <summary>
    /// t_Products商品表 商品表
    /// </summary>
    [Serializable]
    public partial class mol_t_Products
    {
        #region 构造方法
        /// <summary>
        /// 无参构造方法
        /// </summary>
        public mol_t_Products()
        {
        }
        /// <summary>
        /// 带参构造方法(非空字段)
        /// </summary>
        public mol_t_Products(Int32 Id, String maxImage, Int32 Costnum, Int32 Stocknum, Boolean State, DateTime CreateDate, String ProductName, Int32 SalePrice, String Description, String minImage)
        {
            this.__Id = Id;
            this.__maxImage = maxImage;
            this.__Costnum = Costnum;
            this.__Stocknum = Stocknum;
            this.__State = State;
            this.__CreateDate = CreateDate;
            this.__ProductName = ProductName;
            this.__SalePrice = SalePrice;
            this.__Description = Description;
            this.__minImage = minImage;
        }
        #endregion

        #region 私有属性
        private Int32 __Id;
        private String __maxImage;
        private Int32 __Costnum;
        private Int32 __Stocknum;
        private Boolean __State;
        private DateTime __CreateDate;
        private String __ProductName;
        private Int32 __SalePrice;
        private String __Description;
        private String __minImage;
        #endregion

        #region 公有属性
        /// <summary>
        /// 编号 NOT NULL
        /// </summary>
        public Int32 Id
        {
            set { __Id = value; }
            get { return __Id; }
        }
        /// <summary>
        /// 明细图片 明细图片 NOT NULL
        /// </summary>
        public String maxImage
        {
            set { __maxImage = value; }
            get { return __maxImage; }
        }
        /// <summary>
        /// 已兑换数 已兑换数 NOT NULL
        /// </summary>
        public Int32 Costnum
        {
            set { __Costnum = value; }
            get { return __Costnum; }
        }
        /// <summary>
        /// 库存数量 库存数量 NOT NULL
        /// </summary>
        public Int32 Stocknum
        {
            set { __Stocknum = value; }
            get { return __Stocknum; }
        }
        /// <summary>
        /// 是否发布 是否发布 NOT NULL
        /// </summary>
        public Boolean State
        {
            set { __State = value; }
            get { return __State; }
        }
        /// <summary>
        /// 上架时间 上架时间 NOT NULL
        /// </summary>
        public DateTime CreateDate
        {
            set { __CreateDate = value; }
            get { return __CreateDate; }
        }
        /// <summary>
        /// 商品名称 商品名称 NOT NULL
        /// </summary>
        public String ProductName
        {
            set { __ProductName = value; }
            get { return __ProductName; }
        }
        /// <summary>
        /// 价格 价格 NOT NULL
        /// </summary>
        public Int32 SalePrice
        {
            set { __SalePrice = value; }
            get { return __SalePrice; }
        }
        /// <summary>
        /// 商品描述 商品描述 NOT NULL
        /// </summary>
        public String Description
        {
            set { __Description = value; }
            get { return __Description; }
        }
        /// <summary>
        /// 展示图片 展示图片 NOT NULL
        /// </summary>
        public String minImage
        {
            set { __minImage = value; }
            get { return __minImage; }
        }
        #endregion
    }
    #endregion
    #region 封装类t_ExchapgerecOrd
    /// <summary>
    /// t_ExchapgerecOrd兑换记录 兑换记录
    /// </summary>
    [Serializable]
    public partial class mol_t_ExchapgerecOrd
    {
        #region 构造方法
        /// <summary>
        /// 无参构造方法
        /// </summary>
        public mol_t_ExchapgerecOrd()
        {
        }
        /// <summary>
        /// 带参构造方法(非空字段)
        /// </summary>
        public mol_t_ExchapgerecOrd(Int32 Id, Int32 Rid, Int32 UserID, Int32 Price, Int32 Num, DateTime CreateDate)
        {
            this.__Id = Id;
            this.__Rid = Rid;
            this.__UserID = UserID;
            this.__Price = Price;
            this.__Num = Num;
            this.__CreateDate = CreateDate;
        }
        #endregion

        #region 私有属性
        private Int32 __Id;
        private Int32 __Rid;
        private Int32 __UserID;
        private Int32 __Price;
        private Int32 __Num;
        private DateTime __CreateDate;
        #endregion

        #region 公有属性
        /// <summary>
        /// 编号 NOT NULL
        /// </summary>
        public Int32 Id
        {
            set { __Id = value; }
            get { return __Id; }
        }
        /// <summary>
        /// 兑换商品 兑换商品 NOT NULL
        /// </summary>
        public Int32 Rid
        {
            set { __Rid = value; }
            get { return __Rid; }
        }
        /// <summary>
        /// 用户标识 用户标识 NOT NULL
        /// </summary>
        public Int32 UserID
        {
            set { __UserID = value; }
            get { return __UserID; }
        }
        /// <summary>
        /// 兑换价格 兑换价格 NOT NULL
        /// </summary>
        public Int32 Price
        {
            set { __Price = value; }
            get { return __Price; }
        }
        /// <summary>
        /// 兑换数量 兑换数量 NOT NULL
        /// </summary>
        public Int32 Num
        {
            set { __Num = value; }
            get { return __Num; }
        }
        /// <summary>
        /// 兑换时间 兑换时间 NOT NULL
        /// </summary>
        public DateTime CreateDate
        {
            set { __CreateDate = value; }
            get { return __CreateDate; }
        }
        #endregion
    }
    #endregion
    #region 封装类t_Orders
    /// <summary>
    /// t_Orders兑换订单 兑换订单
    /// </summary>
    [Serializable]
    public partial class mol_t_Orders
    {
        #region 构造方法
        /// <summary>
        /// 无参构造方法
        /// </summary>
        public mol_t_Orders()
        {
        }
        /// <summary>
        /// 带参构造方法(非空字段)
        /// </summary>
        public mol_t_Orders(Int32 Id, Int32 opratorId, String PROCESS, String Email, String Postalcode, String TellPhone, DateTime CreateDate, Int32 Cost, Int32 UserID, String OrderId, Int32 States, String UserName, String AddDress)
        {
            this.__Id = Id;
            this.__opratorId = opratorId;
            this.__PROCESS = PROCESS;
            this.__Email = Email;
            this.__Postalcode = Postalcode;
            this.__TellPhone = TellPhone;
            this.__CreateDate = CreateDate;
            this.__Cost = Cost;
            this.__UserID = UserID;
            this.__OrderId = OrderId;
            this.__States = States;
            this.__UserName = UserName;
            this.__AddDress = AddDress;
        }
        #endregion

        #region 私有属性
        private Int32 __Id;
        private Int32 __opratorId;
        private String __PROCESS;
        private String __Email;
        private String __Postalcode;
        private String __TellPhone;
        private DateTime __CreateDate;
        private Int32 __Cost;
        private Int32 __UserID;
        private String __OrderId;
        private Int32 __States;
        private String __UserName;
        private String __AddDress;
        private Int32 __Cost2;
        private String __Remarks;
        private Int32 __Cost1;
        private Int32 __Rid;
        #endregion

        #region 公有属性
        /// <summary>
        /// 编号 NOT NULL
        /// </summary>
        public Int32 Id
        {
            set { __Id = value; }
            get { return __Id; }
        }
        /// <summary>
        /// 管理员 管理员 NOT NULL
        /// </summary>
        public Int32 opratorId
        {
            set { __opratorId = value; }
            get { return __opratorId; }
        }
        /// <summary>
        /// 订单处理过程 订单处理过程 NOT NULL
        /// </summary>
        public String PROCESS
        {
            set { __PROCESS = value; }
            get { return __PROCESS; }
        }
        /// <summary>
        /// 有效邮箱 有效邮箱 NOT NULL
        /// </summary>
        public String Email
        {
            set { __Email = value; }
            get { return __Email; }
        }
        /// <summary>
        /// 邮政编码 邮政编码 NOT NULL
        /// </summary>
        public String Postalcode
        {
            set { __Postalcode = value; }
            get { return __Postalcode; }
        }
        /// <summary>
        /// 联系号码 联系号码 NOT NULL
        /// </summary>
        public String TellPhone
        {
            set { __TellPhone = value; }
            get { return __TellPhone; }
        }
        /// <summary>
        /// 下单时间 下单时间 NOT NULL
        /// </summary>
        public DateTime CreateDate
        {
            set { __CreateDate = value; }
            get { return __CreateDate; }
        }
        /// <summary>
        /// 消费价格 消费价格 NOT NULL
        /// </summary>
        public Int32 Cost
        {
            set { __Cost = value; }
            get { return __Cost; }
        }
        /// <summary>
        /// 用户标识 用户标识 NOT NULL
        /// </summary>
        public Int32 UserID
        {
            set { __UserID = value; }
            get { return __UserID; }
        }
        /// <summary>
        /// 订单号 订单号 NOT NULL
        /// </summary>
        public String OrderId
        {
            set { __OrderId = value; }
            get { return __OrderId; }
        }
        /// <summary>
        /// 订单状态 订单状态 NOT NULL
        /// </summary>
        public Int32 States
        {
            set { __States = value; }
            get { return __States; }
        }
        /// <summary>
        /// 收件人 收件人 NOT NULL
        /// </summary>
        public String UserName
        {
            set { __UserName = value; }
            get { return __UserName; }
        }
        /// <summary>
        /// 收货地址 收货地址 NOT NULL
        /// </summary>
        public String AddDress
        {
            set { __AddDress = value; }
            get { return __AddDress; }
        }
        /// <summary>
        /// 消费后 消费后 NULL
        /// </summary>
        public Int32 Cost2
        {
            set { __Cost2 = value; }
            get { return __Cost2; }
        }
        /// <summary>
        /// 注意事项 注意事项 NULL
        /// </summary>
        public String Remarks
        {
            set { __Remarks = value; }
            get { return __Remarks; }
        }
        /// <summary>
        /// 消费前 消费前 NULL
        /// </summary>
        public Int32 Cost1
        {
            set { __Cost1 = value; }
            get { return __Cost1; }
        }
        /// <summary>
        /// 商品标识 商品标识 NULL
        /// </summary>
        public Int32 Rid
        {
            set { __Rid = value; }
            get { return __Rid; }
        }
        #endregion
    }
    #endregion
}