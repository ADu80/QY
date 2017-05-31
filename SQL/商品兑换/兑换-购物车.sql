-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[EC_P_OnOrder_Array]
    @OrderNo nvarchar(200),--������  
    @GameID int, --�û����Id
    @AddrID int,--�ջ���ַID 
	@CarArray nvarchar(1000),
    @totalPrice decimal(10, 2) output  --����������ܽ�� ,
AS
BEGIN
	BEGIN TRAN
	BEGIN TRY
	     --��¼������Ϣ�ı���
       DECLARE @error int
	   DECLARE @totalPriStr nvarchar(200)
	   DECLARE @orderid int
	   DECLARE @myScore bigint
	   DECLARE @myDiamond bigint
	   DECLARE @myUserID int
	   DECLARE @myCard int
	   set @error=0

	   select @myUserID=UserID FROM  [QPAccountsDB].[dbo].[AccountsInfo]
	    where GameID=@GameID 

	    SELECT  @myScore=  [Score]    ,@myDiamond=  [Diamond], @myCard= RCard
 	    FROM [QPTreasureDB].[dbo].[GameScoreInfo] where UserID= @myUserID
		 
	   DECLARE @totalPriStr1 bigint
       DECLARE @totalPriStr2 bigint
       DECLARE @totalPriStr3 bigint
       set @totalPriStr1=0
       set @totalPriStr2=0
       set @totalPriStr3=0 

	   select sum(a.Num* (case when a.PayType='1' then  b.ScorePrice  when a.PayType='2' then  b.DiamondPrice  when a.PayType='3' then  b.PointPrice end)) totalPay,a.PayType
	   into dtable#sfslfjslwoodfosfoso from  [QPPlatformManagerDB].[dbo].[EC_ShopCar] a left join 
	   [QPPlatformManagerDB].[dbo].[EC_Goods] b on  a.GoodID = b.ID
       where a.GameID=@GameID and CHARINDEX(','+CAST( a.ID as varchar)+',',','+@CarArray+',')>0
	   group by a.PayType   

	   select @totalPriStr1=  d.totalPay   from dtable#sfslfjslwoodfosfoso d where d.PayType=1 
	    
	   select  @totalPriStr2= d.totalPay from dtable#sfslfjslwoodfosfoso d where d.PayType=2
	   
	   select  @totalPriStr3= d.totalPay from dtable#sfslfjslwoodfosfoso d where d.PayType=3
	    
		 
	   drop table dtable#sfslfjslwoodfosfoso
	   --select @totalPriStr1,@totalPriStr2,@totalPriStr3

	    if(@totalPriStr1 =0 and @totalPriStr2=0 and @totalPriStr3=0)
		begin
		-- ���ﳵΪ��
		   ROLLBACK TRAN;
		   return -3
		end

	   if(@myScore< @totalPriStr1)
	   BEGIN
	      -- '��Ҳ���'
		   ROLLBACK TRAN;
		   return -1
	   END

	    if(@myDiamond< @totalPriStr2)
	   BEGIN
	     -- '��ʯ����'
	       ROLLBACK TRAN;
		   return -2
	   END

	   


         --�����ܼ۸�
       select @totalPrice=sum(a.Num* (case when a.PayType='1' then  b.ScorePrice  when a.PayType='2' then  b.DiamondPrice  when a.PayType='3' then  b.PointPrice end)) 
	   from  [QPPlatformManagerDB].[dbo].[EC_ShopCar] a left join 
	   [QPPlatformManagerDB].[dbo].[EC_Goods] b on  a.GoodID = b.ID
       where a.GameID=@GameID   and CHARINDEX(','+CAST( a.ID as varchar)+',',','+@CarArray+',')>0

       --��������
       insert into [QPPlatformManagerDB].[dbo].[EC_Order](OrderNo,GameID,Amount,OrderDate,AddrID,[Status],ExpressNo,Created,Modified)
       values(@OrderNo,@GameID,@totalPrice,getdate(),@AddrID,1,'',getdate(),getdate())
       set @error=@error+@@error
	   select @orderid = @@IDENTITY

	   --������ϸ��
       insert into [QPPlatformManagerDB].[dbo].[EC_OrderDetail](OrderID,[GoodID],[Num],[Price],[CostPrice],[PayType])
	   select @orderid,a.[GoodID],a.[Num],(case when a.PayType='1' then  b.ScorePrice  when a.PayType='2' then  b.DiamondPrice  when a.PayType='3' then  b.PointPrice end),0,a.PayType
       from [QPPlatformManagerDB].[dbo].[EC_ShopCar]  a inner join 
	   [QPPlatformManagerDB].[dbo].[EC_Goods]  b on a.GoodID = b.ID where a.GameID=@GameID  and CHARINDEX(','+CAST( a.ID as varchar)+',',','+@CarArray+',')>0
       set @error=@error+@@error
	    
	   --ɾ�����ﳵѡ��
	   delete from [QPPlatformManagerDB].[dbo].[EC_ShopCar] where GameID=@GameID  and  CHARINDEX(','+CAST(  ID as varchar)+',',','+@CarArray+',')>0
	   set @error=@error+@@error

	   --�����û���� ��ʯ ��
	    update [QPTreasureDB].[dbo].[GameScoreInfo] 
		set [Score]=[Score]-@totalPriStr1, [Diamond]=[Diamond]-@totalPriStr2
		where UserID= @myUserID
		set @error=@error+@@error

		--��¼�Ƹ��仯
		insert into [QPRecordDB].[dbo].[RecordRichChange]([UserID]
           ,[KindID]   ,[ServerID]   ,[BeforeScore]    ,[ChangeScore]    ,[AfterScore]   ,[BeforeDiamond]
           ,[ChangeDiamond]  ,[AfterDiamond]    ,[BeforeRCard]   ,[ChangeRCard] ,[AfterRCard]
           ,[Revenue]  ,[Reason]  ,[LastTime])  VALUES
           (@myUserID  ,0    ,0     ,@myScore     ,-@totalPriStr1   ,@myScore-@totalPriStr1
           ,@myDiamond  ,-@totalPriStr2   ,@myDiamond-@totalPriStr2   ,@myCard  ,0
           ,@myCard  ,0   ,2   ,GETDATE())
       set @error=@error+@@error


	   --�������
	   if(@error>0)
	   BEGIN
            ROLLBACK TRAN;
	   END


		COMMIT TRAN
	END TRY 
	BEGIN CATCH
		ROLLBACK TRAN;
		THROW
	END CATCH
END
