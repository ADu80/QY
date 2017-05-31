-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Use QPPlatformManagerDB
GO

IF EXISTS(SELECT 1 FROM dbo.SYSOBJECTS WHERE xtype='P' AND OBJECT_ID('EC_P_OrderAddr')=ID)
	DROP PROC EC_P_OrderAddr
GO
CREATE PROCEDURE   [dbo].[EC_P_OrderAddr]
    @ID INT  ,
	@GameID INT,
	@CountryID INT,
	@ProviceID INT,
	@CityID INT,
	@DistrictID INT,
	@ReceiverName varchar(30),
	@ReceiverMobile varchar(30),
	@Addr varchar(200),
	@Street  varchar(200),
	@IsDefault char(1),
	@getID INT output 
AS
BEGIN
	BEGIN TRAN
	BEGIN TRY
	    DECLARE @OrgNum int
	    IF @ID=0
		BEGIN
		INSERT INTO [QPPlatformManagerDB].[dbo].[EC_OrderAddr]
           ([GameID]  ,ReceiverName,ReceiverMobile ,[Addr]     ,[CountryID]      ,[ProviceID]     ,[CityID]  ,[DistrictID]   ,[Street],IsDefault)VALUES
           (@GameID ,@ReceiverName  ,@ReceiverMobile,@Addr   ,@CountryID  ,@ProviceID   ,@CityID   ,@DistrictID  ,@Street,@IsDefault)
        select @getID = @@IDENTITY
		END 
		Else 
		BEGIN
		 
	    UPDATE [dbo].[EC_OrderAddr]   SET  IsDefault ='0' WHERE GameID=@GameID  

        UPDATE [dbo].[EC_OrderAddr]   SET [GameID] = @GameID   ,[Addr] = @Addr  ,ReceiverName=@ReceiverName,ReceiverMobile=@ReceiverMobile  ,[CountryID] = @CountryID   ,[ProviceID] = @ProviceID
        ,[CityID] = @CityID   ,[DistrictID] = @DistrictID   ,[Street] =@Street ,IsDefault =@IsDefault WHERE ID=@ID   
		select @getID = @ID	 
	    END 
		    
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN;
		THROW
	END CATCH
END

