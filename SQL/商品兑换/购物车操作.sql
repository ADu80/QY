-- =============================================
-- @GameID:	    游戏ID
-- @GoodID:		商品ID
-- @Num  : 数量
-- @EditType:	1 加入购物 2 修改 3删除
-- =============================================
CREATE PROCEDURE [dbo].[EC_P_OnShopCar]
    @GameID INT,
	@GoodID INT,
	@Num INT,
	@PayType nchar(1),
	@EditType INT
AS
BEGIN
	BEGIN TRAN
	BEGIN TRY
	    DECLARE @OrgNum int
	    IF @EditType=1
		BEGIN
		IF NOT EXISTS(SELECT 1 FROM [QPPlatformManagerDB].[dbo].[EC_ShopCar] WHERE GameID=@GameID and GoodID= @GoodID and PayType=@PayType)
		BEGIN
		      INSERT [QPPlatformManagerDB].[dbo].[EC_ShopCar]([GameID],[GoodID],[Num],[Created],[Modified],PayType)
			  VALUES(@GameID,@GoodID,@Num,GETDATE(),GETDATE(),@PayType)
			   
		END
		Else 
		BEGIN
			 
			  SELECT  @OrgNum =Num FROM [QPPlatformManagerDB].[dbo].[EC_ShopCar] WHERE GameID=@GameID and GoodID= @GoodID and PayType=@PayType
			  
			  UPDATE [QPPlatformManagerDB].[dbo].[EC_ShopCar]
			  SET [Num]= @Num+ @OrgNum ,  [Modified]=GETDATE()
			  WHERE  GameID=@GameID and GoodID= @GoodID
			 
	    END
		END

		IF @EditType=2
		BEGIN   
			  UPDATE [QPPlatformManagerDB].[dbo].[EC_ShopCar]
			  SET [Num]= @Num  ,  [Modified]=GETDATE()
			  WHERE  GameID=@GameID and GoodID= @GoodID  and PayType=@PayType
		END

		IF @EditType=3
		BEGIN   
			  Delete From [QPPlatformManagerDB].[dbo].[EC_ShopCar] 
			  WHERE  GameID=@GameID and GoodID= @GoodID  and PayType=@PayType
		END
		    
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN;
		THROW
	END CATCH
END

