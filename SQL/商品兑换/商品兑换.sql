Use QPPlatformManagerDB
GO


------表名：商品信息表------
IF NOT EXISTS(SELECT 1 FROM dbo.SYSOBJECTS WHERE xtype='U' AND OBJECT_ID('EC_Goods')=ID)
	CREATE TABLE EC_Goods(
		ID INT IDENTITY(1,1) PRIMARY KEY,
		GoodNo VARCHAR(20),
		GoodName VARCHAR(50),
		CategoryID INT,
		PointPrice DECIMAL(30,2),	
		ScorePrice DECIMAL(30,2),	
		DiamondPrice DECIMAL(30,2),	
		Intro VARCHAR(50),
		IntroImg VARCHAR(50),
		OnShelfDate DateTime,
		OffShelfDate DateTime,
		ShelfStatus BIT,
		Created DateTime,
		Modified DateTime,
	)

GO


------表名：商品分类------
IF NOT EXISTS(SELECT 1 FROM dbo.SYSOBJECTS WHERE xtype='U' AND OBJECT_ID('EC_GoodsCategory')=ID)
	CREATE TABLE EC_GoodsCategory(
		ID INT IDENTITY(1,1) PRIMARY KEY,
		Category VARCHAR(20)
	)

GO



------表名：商品图片------
--DROP TABLE EC_GoodsImages
IF NOT EXISTS(SELECT 1 FROM dbo.SYSOBJECTS WHERE xtype='U' AND OBJECT_ID('EC_GoodsImages')=ID)
	CREATE TABLE EC_GoodsImages(
		GoodID INT NOT NULL,
		ImgUrl VARCHAR(200),
		ImgCode VARCHAR(MAX)
	)

GO

------表名：订单列表------
IF NOT EXISTS(SELECT 1 FROM dbo.SYSOBJECTS WHERE xtype='U' AND OBJECT_ID('EC_Order')=ID)
	CREATE TABLE EC_Order(
		ID INT IDENTITY(1,1) PRIMARY KEY,
		OrderNo VARCHAR(20),
		GameID INT,
		Num INT,
		Amount DECIMAL(30,2),
		OrderDate DateTime,
		PayType INT,
		AddrID INT,
		[Status] INT,
		ExpressNo INT,
		Created DateTime,
		Modified DateTime,
	)

GO

------表名：订单详情------
IF NOT EXISTS(SELECT 1 FROM dbo.SYSOBJECTS WHERE xtype='U' AND OBJECT_ID('EC_OrderDetail')=ID)
	CREATE TABLE EC_OrderDetail(
		ID INT IDENTITY(1,1) PRIMARY KEY,
		OrderID INT,
		GoodID INT,
		Num INT,
		Price DECIMAL(30,2),
		CostPrice DECIMAL(30,2)
	)

GO


------表名：兑换方式------
IF NOT EXISTS(SELECT 1 FROM dbo.SYSOBJECTS WHERE xtype='U' AND OBJECT_ID('EC_PayType')=ID)
	CREATE TABLE EC_PayType(
		ID INT IDENTITY(1,1) PRIMARY KEY,
		PayType VARCHAR(20)
	)

GO


------表名：收货人地址------
--DROP TABLE EC_OrderAddr

IF NOT EXISTS(SELECT 1 FROM dbo.SYSOBJECTS WHERE xtype='U' AND OBJECT_ID('EC_OrderAddr')=ID)
	CREATE TABLE EC_OrderAddr(
		ID INT IDENTITY(1,1) PRIMARY KEY,
		GameID INT,
		ReceiverName VARCHAR(30),
		ReceiverMobile VARCHAR(30),
		Addr VARCHAR(200),
		CountryID INT,
		ProviceID INT,
		CityID INT,
		DistrictID INT,
		Street  VARCHAR(200)
	)

GO


------表名：购物车------
IF NOT EXISTS(SELECT 1 FROM dbo.SYSOBJECTS WHERE xtype='U' AND OBJECT_ID('EC_ShopCar')=ID)
	CREATE TABLE EC_ShopCar(
		ID INT IDENTITY(1,1) PRIMARY KEY,
		GameID INT,
		GoodID INT,
		Num INT,
		Created DateTime,
		Modified DateTime
	)

GO


ALTER TABLE EC_Goods
ADD CONSTRAINT fk_EC_Goods_CategoryID FOREIGN KEY(CategoryID) REFERENCES EC_GoodsCategory(ID)

GO

ALTER TABLE EC_Order
ADD CONSTRAINT fk_EC_Goods_AddrID FOREIGN KEY(AddrID) REFERENCES EC_OrderAddr(ID)

GO

ALTER TABLE EC_OrderDetail
ADD CONSTRAINT fk_EC_OrderDetail_OrderID FOREIGN KEY(OrderID) REFERENCES EC_Order(ID)
,CONSTRAINT fk_EC_OrderDetail_GoodID FOREIGN KEY(GoodID) REFERENCES EC_Goods(ID)

GO

ALTER TABLE EC_ShopCar
ADD CONSTRAINT fk_EC_ShopCar_GoodID FOREIGN KEY(GoodID) REFERENCES EC_Goods(ID)

GO


ALTER TABLE EC_OrderAddr
ADD 		ReceiverName VARCHAR(30),
		ReceiverMobile VARCHAR(30)
GO


