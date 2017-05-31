USE [QPTreasureDB]

-------------------------获取订单---------------------------------------------------------------------
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('WEB_LIST_PayOrder')=id AND type='P')
	DROP PROC WEB_LIST_PayOrder
GO
create  PROC  [dbo].[WEB_LIST_PayOrder]
	@OrderID VARCHAR(64),
	@Accounts VARCHAR(31),
	@startDate VARCHAR(30),
	@endDate VARCHAR(30),
	@UserID INT,
	@GameID INT,
	@pageIndex INT=1,
	@pageSize INT=20
AS
BEGIN
	DECLARE @SQL VARCHAR(MAX)=''
	DECLARE @Where VARCHAR(1000)=''
	DECLARE @tempTable VARCHAR(50)=''
	SET @tempTable = Replace('##'+CONVERT(VARCHAR(50), NEWID()),'-','')
	
	SET @Where=@Where+'   AND (DATEDIFF(DAY,a.CreateTime,GETDATE()) <= 6 and a.PayState !=2) or a.PayState=2 ' 
	 
	IF @OrderID<>''
	    SET @Where=@Where+' AND a.OrderID  LIKE ''%'+@OrderID+'%''' 

    IF @GameID<>''
	    SET @Where=@Where+' AND b.GameID  ='+Convert(VARCHAR(30),@GameID)

    IF @UserID<>''
	    SET @Where=@Where+' AND a.UserID  ='+Convert(VARCHAR(30),@UserID)

    IF @Accounts<>''
	    SET @Where=@Where+' AND b.Accounts  LIKE ''%'+@Accounts+'%''' 

		


	IF @startDate<>''
		SET @Where=@Where+' AND a.CreateTime >= '''+@startDate+''''
	IF @endDate<>''
		SET @Where=@Where+' AND a.CreateTime < '''+@endDate+'  23:59:59'''

	
	SET @SQL='

	select  a.OrderID
      , case when LEN(a.ChannelOrderID)=0 then ''无'' else a.ChannelOrderID end ChannelOrderID 
      , a.UserID   ,   b.GameID  , case when  a.GoodsType =0 then ''钻石'' when  a.GoodsType =1 then ''房卡'' else ''无'' end   GoodsType  ,
	  case when  a.PayType =1 then ''苹果'' when  a.PayType =2 then ''微信'' when  a.PayType =3 then ''威富通'' when  a.PayType =4 then ''盾行天下'' when  a.PayType =5 then ''优卡''  when  a.PayType =6 then ''易码通''  end PayType   , a.[PayAmount]  , a.[BackCount], a.[BuyCount]
      ,  case when  a.PayState =0 then ''生成'' when  a.PayState =1 then ''充值中''  when  a.PayState =2 then ''充值成功''  when  a.PayState =3 then ''充值失败'' when  a.PayState =4 then ''订单过期'' end   PayState
	   , a.UpdateTime  , a.CreateTime  , case when LEN(a.ErrorCode)=0 then ''无'' else isnull(a.ErrorCode,''无'') end ErrorCode , 
	  case when LEN(b.Accounts)=0 then ''无'' else isnull(b.Accounts,''无'') end Accounts  ,
	  case when LEN( b.NickName)=0 then ''无'' else isnull( b.NickName,''无'') end  NickName  ,
	  case when BackType =1 then ''金币'' when BackType =2 then ''钻石'' when BackType =3 then ''房卡'' else ''无'' end BackType,
	  ROW_NUMBER() OVER(ORDER BY a.CreateTime DESC) RowNo
	  INTO '+@tempTable+'
	   from [QPTreasureDB].[dbo].[PayOrder] a 
     left join [QPAccountsDB].[dbo].[AccountsInfo] b
      on b.UserID =a.UserID 
	WHERE 1=1  '	+@Where + '
	SELECT totalCount=Count(1) FROM '+ @tempTable + '

	SELECT * FROM ' + @tempTable + '
	WHERE RowNo BETWEEN '+CONVERT(VARCHAR(10),(@pageIndex-1)*@pageSize+1)+' AND '+CONVERT(VARCHAR(10),@pageIndex*@pageSize)+'
	ORDER BY RowNO 

	DROP TABLE '+@tempTable

	--SELECT @SQL
	EXEC(@SQL)
END
go


------------------------------获取订单状态----------------------------------------------------------------
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('PayOrder_P_Get')=id AND type='P')
	DROP PROC PayOrder_P_Get
GO
create PROCEDURE   [dbo].[PayOrder_P_Get]
    @OrderID varchar(64),
	@myPayState int output,
	@myPayType int output,
	@myBuyCount bigint output,
	@myBackCount bigint output,
	@myUserID int output,
	@myPresent INT output,
	@myChannelOrderID varchar(64) output
AS
BEGIN 
	BEGIN TRAN
	BEGIN TRY 
	    IF NOT EXISTS(SELECT 1 FROM [QPTreasureDB].[dbo].[PayOrder] WHERE [OrderID]=@OrderID )
		BEGIN
		  set @myPayState =-1  
		END
		else
		BEGIN
		    declare @PayAmount  decimal(18,2)
		    SELECT  @myPayState =PayState ,@myPayType =GoodsType ,@myBuyCount =BuyCount, @myBackCount=BackCount, @myUserID= UserID, @PayAmount= PayAmount ,@myPresent=BackType, @myChannelOrderID= ChannelOrderID FROM   [QPTreasureDB].[dbo].[PayOrder] WHERE [OrderID]=@OrderID
			select   @myPayState
			--SELECT  @myPresent=Present   FROM QPPlatformDB.dbo.ShopProperty WHERE Status=1 AND GoodsType=(@myPayType+2) AND PayCost=@PayAmount
	   
		END 
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN;
		THROW
	END CATCH
END
go



------------------------------获取订单状态----------------------------------------------------------------
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('PayOrder_P_Get_Channel')=id AND type='P')
	DROP PROC PayOrder_P_Get_Channel
GO
create PROCEDURE   [dbo].[PayOrder_P_Get_Channel]
    @ChannelOrderID varchar(64),
	@myPayState int output,
	@myPayType int output,
	@myBuyCount bigint output,
	@myBackCount bigint output,
	@myUserID int output,
	@myPresent INT output,
	@myOrderID varchar(64) output
AS
BEGIN 
	BEGIN TRAN
	BEGIN TRY 
	    IF NOT EXISTS(SELECT 1 FROM [QPTreasureDB].[dbo].[PayOrder] WHERE ChannelOrderID=@ChannelOrderID )
		BEGIN
		  set @myPayState =-1  
		END
		else
		BEGIN
		    declare @PayAmount  decimal(18,2)
		    SELECT  @myPayState =PayState ,@myPayType =GoodsType ,@myBuyCount =BuyCount, @myBackCount=BackCount, @myUserID= UserID, @PayAmount= PayAmount ,@myPresent=BackType, @myOrderID=  OrderID FROM   [QPTreasureDB].[dbo].[PayOrder] WHERE ChannelOrderID=@ChannelOrderID
			select   @myPayState
			 
		END 
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN;
		THROW
	END CATCH
END
go



-----------------------------------订单状态改变-----------------------------------------------------------
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('PayOrder_P_Edit')=id AND type='P')
	DROP PROC PayOrder_P_Edit
GO
CREATE PROCEDURE   [dbo].[PayOrder_P_Edit]
    @OrderID varchar(64),
    @ErrorCode nvarchar(32), 
    @PayState  int 
AS
BEGIN
	BEGIN TRAN
	BEGIN TRY
	    DECLARE @GetPayState int
	    DECLARE @GetBuyCount bigint
		DECLARE @GetBackCount bigint
		DECLARE @myUserID int
		DECLARE @myGoodsType int 
		DECLARE @myPayAmount int 
		DECLARE @myIP NVARCHAR(50)
	    IF  EXISTS(SELECT 1 FROM [QPTreasureDB].[dbo].[PayOrder] WHERE [OrderID]=@OrderID )
		BEGIN
		    SELECT  @GetPayState=[PayState] ,@GetBuyCount =BuyCount,@GetBackCount= BackCount,  @myUserID=UserID , @myGoodsType = GoodsType, @myPayAmount= PayAmount ,@myIP=OperatingIP  FROM   [QPTreasureDB].[dbo].[PayOrder] WHERE [OrderID]=@OrderID
			 
			if(@GetPayState=1) 
				BEGIN
                UPDATE [dbo].[PayOrder]   SET  [PayState] = @PayState  ,[UpdateTime] =GETDATE()  ,[ErrorCode] = @ErrorCode WHERE [OrderID]=@OrderID 
				-- 记录日志
                INSERT [QPPlatformManagerDB].dbo.SystemSecurity
                ( OperatingTime ,  OperatingName ,    OperatingIP ,  OperatingAccounts,  Module  )
                VALUES  ( GETDATE() ,    '充值单号:'+@OrderID+',状态:'+ CASE  WHEN @PayState=2 THEN '充值成功' ELSE '充值失败' END ,    '0.0.0.0',    'admin',    '充值操作'    )
			
                if(@PayState=2)--支付成功
				BEGIN

				        DECLARE @myScore bigint
						DECLARE @myDiamond bigint 
						DECLARE @myCard int
						SELECT  @myScore=  [Score]    ,@myDiamond=  [Diamond], @myCard= RCard
						FROM [QPTreasureDB].[dbo].[GameScoreInfo] where UserID= @myUserID
						 
						DECLARE @AddSocre BIGINT=0
						DECLARE @AddDiamond BIGINT=0
						DECLARE @AddRCard BIGINT=0
						DECLARE @Score BIGINT=0
						DECLARE @Diamond BIGINT=0
						DECLARE @RCard BIGINT=0
						DECLARE @Present INT
						SELECT  @Present=Present, @Score=Score, @Diamond=Diamond, @RCard=RCard FROM QPPlatformDB.dbo.ShopProperty WHERE Status=1 AND GoodsType=(@myGoodsType+2) AND PayCost=@myPayAmount
						IF @Present = 1  --赠送金币
							BEGIN
								SET @AddSocre += @Score
							END 
						ELSE IF @Present = 2 --赠送钻石
							BEGIN
								SET @AddDiamond += @Diamond
							END
						ELSE IF @Present = 3 --赠送发卡
							BEGIN
								SET @AddRCard += @RCard
							END 

                        IF(@myGoodsType=0)
					    BEGIN
						set @AddDiamond+=@Diamond 
						-- 记录日志
						INSERT [QPPlatformManagerDB].dbo.SystemSecurity
						( OperatingTime ,  OperatingName ,    OperatingIP ,  OperatingAccounts,  Module  )
						VALUES  ( GETDATE() ,    '充号'+@OrderID+',UserID:'+CONVERT(varchar(40),@myUserID)+',钻石'+CONVERT(varchar(40),@Diamond),  isnull(@myIP,  '0.0.0.0'),    'admin',    '充值操作'    )
			
					    END

						IF(@myGoodsType=1)
					    BEGIN
						set @AddRCard+=@RCard
						-- 记录日志
						INSERT [QPPlatformManagerDB].dbo.SystemSecurity
						( OperatingTime ,  OperatingName ,    OperatingIP ,  OperatingAccounts,  Module  )
						VALUES  ( GETDATE() ,    '充号'+@OrderID+',UserID:'+CONVERT(varchar(40),@myUserID)+',房卡'+CONVERT(varchar(40),@RCard),   isnull(@myIP,  '0.0.0.0'),    'admin',    '充值操作'    )
					    END
						 
					 

						IF @AddDiamond<>0 OR @AddRCard<>0 OR @AddSocre<>0
						BEGIN
						--更新用户财富
						UPDATE [QPTreasureDB].[dbo].[GameScoreInfo]  SET Diamond+=@AddDiamond, RCard+=@AddRCard, Score+=@AddSocre WHERE UserID=@myUserID

						--记录财富变化
						insert into [QPRecordDB].[dbo].[RecordRichChange]([UserID]
						,[KindID]   ,[ServerID]   ,[BeforeScore]    ,[ChangeScore]    ,[AfterScore]   ,[BeforeDiamond]
						,[ChangeDiamond]  ,[AfterDiamond]    ,[BeforeRCard]   ,[ChangeRCard] ,[AfterRCard]
						,[Revenue]  ,[Reason]  ,[LastTime])  VALUES
						(@myUserID  ,0    ,0     ,@myScore     ,0   ,@myScore
						,@myDiamond  ,  @AddDiamond , @myDiamond+@AddDiamond ,@myCard  ,@AddRCard
						,@myCard +@AddRCard ,0   ,2   ,GETDATE())

						END
						 
						----在首冲奖励表中插入改记录
						 
						--DECLARE @firstScore BIGINT=0
						--DECLARE @firstDiamond BIGINT=0
						--DECLARE @firstRCard BIGINT=0

						--DECLARE @rewardId  INT=0
						--IF NOT EXISTS(SELECT 1 FROM QPTreasureDB.dbo.PayRewardOrder WHERE UserID=@myUserID)
						--BEGIN
						--SELECT @rewardId=Id , @firstScore = Score, @firstDiamond =Diamond , @firstRCard = RCard FROM QPTreasureDB.dbo.PayRewardRecordCfg WHERE Name='首冲奖励'
						--INSERT QPTreasureDB.dbo.PayRewardOrder(UserID,RewardId,RewardStatus,LastVisitView,TodayIsRedPointDisplay) VALUES(@myUserID,@rewardId,1,GETDATE(),1)
 
						-----------------记录数据 
						-----------------更新用户财富
						--UPDATE [QPTreasureDB].[dbo].[GameScoreInfo]  SET Diamond =@myDiamond+@AddDiamond+ @firstDiamond, RCard =@myCard +@AddRCard+ @firstRCard, Score =@myScore+@firstScore WHERE UserID=@myUserID
						 
						-----------------记录财富变化
						--insert into [QPRecordDB].[dbo].[RecordRichChange]([UserID]
						--,[KindID]   ,[ServerID]   ,[BeforeScore]    ,[ChangeScore]    ,[AfterScore]   ,[BeforeDiamond]
						--,[ChangeDiamond]  ,[AfterDiamond]    ,[BeforeRCard]   ,[ChangeRCard] ,[AfterRCard]
						--,[Revenue]  ,[Reason]  ,[LastTime])  VALUES
						--(@myUserID  ,0    ,0     ,@myScore     ,@firstScore  ,@myScore+@firstScore
						--,@myDiamond  ,  @firstDiamond , @myDiamond+@AddDiamond+ @firstDiamond ,@myCard  ,@firstRCard
						--,@myCard +@AddRCard + @firstRCard,0   ,2   ,DATEADD(SS,2,GETDATE()))
						-----------------记录数据
						

						--END
						----在首冲奖励表中插入改记录

				END
					   
            ENd
		END 
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN;
		THROW
	END CATCH
END
go


-----------------------------------新增订单-----------------------------------------------------------
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('PayOrder_P_Add')=id AND type='P')
	DROP PROC PayOrder_P_Add
GO
CREATE PROCEDURE   [dbo].[PayOrder_P_Add]
    @OrderID varchar(64),
    @ChannelOrderID varchar(64),
    @UserID  int,
    @GoodsType  int, 
    @PayType  int, 
    @PayAmount  decimal(18,2),
	@BuyCount bigint,
    @BackCount  bigint,
    @PayState  int,  
	@OperatingIP NVARCHAR(50),
	@getID INT output 
AS
BEGIN
	BEGIN TRAN
	BEGIN TRY
	    DECLARE @OrgNum int
	     IF NOT EXISTS(SELECT 1 FROM [QPTreasureDB].[dbo].[PayOrder] WHERE [OrderID]=@OrderID )
		 BEGIN

		 DECLARE @AddSocre BIGINT=0
	     DECLARE @AddDiamond BIGINT=0
	     DECLARE @AddRCard BIGINT=0
	     DECLARE @Score BIGINT=0
	     DECLARE @Diamond BIGINT=0
	     DECLARE @RCard BIGINT=0
	     DECLARE @Present INT
		 DECLARE @GetBack BIGINT=0 
	     SELECT  @Present=Present, @Score=Score, @Diamond=Diamond, @RCard=RCard FROM QPPlatformDB.dbo.ShopProperty WHERE Status=1 AND GoodsType=(@GoodsType+2) AND PayCost=@PayAmount
	     IF @Present = 1  --赠送金币
	     	BEGIN
	     		SET @AddSocre += @Score
				set @GetBack =@AddSocre
	     	END 
	     ELSE IF @Present = 2 --赠送钻石
	     	BEGIN
	     		SET @AddDiamond += @Diamond
				set @GetBack =@AddDiamond
	     	END
	     ELSE IF @Present = 3 --赠送发卡
	     	BEGIN
	     		SET @AddRCard += @RCard
				set @GetBack =@AddRCard
	     	END 
         
		 DECLARE @GetBuy BIGINT=0 
	     IF(@GoodsType=0)
	     BEGIN 
		 set @GetBuy= @Diamond
	     END

	     IF(@GoodsType=1)
	     BEGIN 
		 set @GetBuy=  @RCard
	     END 
		 

	     INSERT INTO [dbo].[PayOrder]
	     ([OrderID]   ,[ChannelOrderID]  ,[UserID]  ,[GoodsType]  ,[PayType]
	     ,[PayAmount]  ,[BuyCount],[BackCount]    ,[PayState]   ,[UpdateTime]   ,[CreateTime]  ,[ErrorCode], [BackType],[OperatingIP])
	     VALUES
	     (@OrderID,   @ChannelOrderID,     @UserID,     @GoodsType,    @PayType, 
	     @PayAmount,   @GetBuy, @GetBack,     @PayState,   GETDATE(),      GETDATE(),   '',@Present,@OperatingIP)
	     select @getID = @@IDENTITY
		 END
		 
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN;
		THROW
	END CATCH
END
go

--------------------新增字段
IF NOT EXISTS (    SELECT 1 FROM SYSOBJECTS T1    INNER JOIN SYSCOLUMNS T2 ON T1.ID=T2.ID    WHERE T1.NAME='PayOrder' AND T2.NAME='BuyCount' ) 
ALTER TABLE [QPTreasureDB].[dbo].[PayOrder] ADD BuyCount bigint null 
go
IF NOT EXISTS (    SELECT 1 FROM SYSOBJECTS T1    INNER JOIN SYSCOLUMNS T2 ON T1.ID=T2.ID    WHERE T1.NAME='PayOrder' AND T2.NAME='BackType' ) 
ALTER TABLE [QPTreasureDB].[dbo].[PayOrder] ADD BackType  int null 
go
IF NOT EXISTS (    SELECT 1 FROM SYSOBJECTS T1    INNER JOIN SYSCOLUMNS T2 ON T1.ID=T2.ID    WHERE T1.NAME='PayOrder' AND T2.NAME='OperatingIP' ) 
ALTER TABLE [QPTreasureDB].[dbo].[PayOrder] ADD OperatingIP  nvarchar(50) null 
go


use [QPPlatformManagerDB]
go
--------------------新增字段
IF NOT EXISTS (    SELECT 1 FROM SYSOBJECTS T1    INNER JOIN SYSCOLUMNS T2 ON T1.ID=T2.ID    WHERE T1.NAME='SystemSecurity' AND T2.NAME='Module' ) 
ALTER TABLE [QPPlatformManagerDB].[dbo].[SystemSecurity] ADD Module  Nvarchar(50) null 
go