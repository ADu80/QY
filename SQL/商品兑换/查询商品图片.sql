Use QPPlatformManagerDB
GO


IF EXISTS(SELECT 1 FROM dbo.SYSOBJECTS WHERE xtype='P' AND OBJECT_ID('EC_Get_Goods_Images_ByID')=ID)
	DROP PROC EC_Get_Goods_Images_ByID
GO
CREATE PROCEDURE  EC_Get_Goods_Images_ByID
	@GoodID INT
AS
BEGIN
	IF @GoodID IS NULL
		SELECT * FROM dbo.EC_GoodsImages	
	ELSE
		SELECT * FROM dbo.EC_GoodsImages WHERE @GoodID=GoodID
END

GO