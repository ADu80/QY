USE QPPlatformManagerDB
GO


--IF EXISTS(SELECT 1 FROM dbo.SYSOBJECTS WHERE xtype='U' AND OBJECT_ID('RecordSpreadSum')=ID)
--BEGIN
--	DROP TABLE RecordSpreadSumDetail
--	DROP TABLE RecordSpreadSum
--END
--GO
IF NOT EXISTS(SELECT 1 FROM dbo.SYSOBJECTS WHERE xtype='U' AND OBJECT_ID('RecordSpreadSum')=ID)
CREATE TABLE RecordSpreadSum(
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[Waste] [bigint] NULL,
	[SpreadSum] [bigint] NULL,
	[SpreadDate] [varchar](10) NOT NULL,
	[LastTime] [datetime] NULL,
	[EmailID] BIGINT,
 CONSTRAINT [PK_RecordSpreadSum_id_time] PRIMARY KEY CLUSTERED 
(
	[ID]
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


--DROP TABLE RecordSpreadSumDetail
IF NOT EXISTS(SELECT 1 FROM dbo.SYSOBJECTS WHERE xtype='U' AND OBJECT_ID('RecordSpreadSumDetail')=ID)
CREATE TABLE RecordSpreadSumDetail
(
	ID BIGINT IDENTITY(1,1),
	RecordSpreadSumID BIGINT,
	UserID INT,
	ABC VARCHAR(2),
	Waste BIGINT DEFAULT(0),
	SpreadSum BIGINT DEFAULT(0),
)

GO

IF NOT EXISTS(SELECT 1 FROM dbo.SYSOBJECTS WHERE xtype='F' AND OBJECT_ID('FK_RecordSpreadSumDetail_id')=ID)
	ALTER TABLE RecordSpreadSumDetail
	ADD CONSTRAINT FK_RecordSpreadSumDetail_id FOREIGN KEY(RecordSpreadSumID) REFERENCES RecordSpreadSum(ID)

GO


IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('f_GetSpreaderRateByUserID')=id AND xtype='TF')
	DROP FUNCTION f_GetSpreaderRateByUserID
GO
CREATE FUNCTION f_GetSpreaderRateByUserID(
	@UserID INT
)
RETURNS @table TABLE(ARate INT,BRate INT,CRate INT)
AS
BEGIN
	IF EXISTS(SELECT 1 FROM QPAccountsDB.dbo.AccountsInfo WHERE UserID=@UserID AND ISNULL(AgentID,0)=0)
	BEGIN
		INSERT @table(ARate,BRate,CRate)
		SELECT ASpreaderRate,BSpreaderRate,CSpreaderRate
		FROM [dbo].[AgentSpreaderOptions] o
		INNER JOIN (
			SELECT RoleID,GradeID FROM dbo.Base_Roles rr
				INNER JOIN dbo.Base_AgentGrades gg ON rr.AgentLevel=0 AND rr.AgentLevel=gg.AgentLevel
		) g ON o.RoleID=g.RoleID AND o.GradeID=g.GradeID
	END
	ELSE
	BEGIN
		INSERT @table(ARate,BRate,CRate)
		SELECT ASpreaderRate,BSpreaderRate,CSpreaderRate
		FROM [dbo].[AgentSpreaderOptions] o
		INNER JOIN (
			SELECT RoleID,GradeID FROM dbo.Base_Users u WHERE u.AgentID=(SELECT AgentID FROM QPAccountsDB.dbo.AccountsInfo WHERE UserID=@UserID)
		) g ON o.RoleID=g.RoleID AND o.GradeID=g.GradeID
	END
	RETURN
END

GO


IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('f_GetGamerWasteByDate')=id AND xtype='FN')
	DROP FUNCTION f_GetGamerWasteByDate
GO
CREATE FUNCTION f_GetGamerWasteByDate(
	@UserID INT,
	@startDate VARCHAR(50),
	@endDate VARCHAR(50)
)
RETURNS BIGINT
AS
BEGIN
	DECLARE @Waste BIGINT
	SELECT @Waste=SUM(s.ChangeScore) FROM QPRecordDB.dbo.RecordRichChange s
		WHERE s.UserID=@UserID AND s.Reason IN (0,1) AND s.LastTime>=CONVERT(VARCHAR(10),@startDate,120) AND s.LastTime<CONVERT(VARCHAR(10),DATEADD(day,1,@endDate),120)
	RETURN IsNull(@Waste,0)
END
GO


IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('f_GetGamerSpreaderSumByDay')=id AND xtype='FN')
	DROP FUNCTION f_GetGamerSpreaderSumByDay
GO
CREATE FUNCTION f_GetGamerSpreaderSumByDay(
	@UserID INT,
	@day VARCHAR(10)
)
RETURNS BIGINT
AS
BEGIN
	DECLARE @A VARCHAR(10),@B VARCHAR(10),@C VARCHAR(10),
			@SpreadSum BIGINT

	SELECT @A=ARate,@B=BRate,@C=CRate FROM dbo.f_GetSpreaderRateByUserID(@UserID)

	DECLARE @temptable TABLE (UserID INT,Waste BIGINT,ABC VARCHAR(2),SpreadSum BIGINT)

	INSERT @temptable(UserID,ABC,Waste,SpreadSum)
	SELECT a.UserID,'A',IsNull(SUM(s.ChangeScore),0),ABS(IsNull(SUM(s.ChangeScore),0))*@A/100 ChangeScore 
	FROM QPAccountsDB.dbo.AccountsInfo a
	LEFT JOIN QPRecordDB.dbo.RecordRichChange s ON CONVERT(VARCHAR(10),s.LastTime,23)=@day AND s.Reason IN (0,1) AND s.UserID=a.UserID 
	WHERE a.IsAndroid=0 AND a.UserID=@UserID
	GROUP BY a.UserID

	INSERT @temptable(UserID,ABC,Waste,SpreadSum)
	SELECT a.UserID,'B',IsNull(SUM(s.ChangeScore),0),ABS(IsNull(SUM(s.ChangeScore),0))*@B/100 ChangeScore 
	FROM QPAccountsDB.dbo.AccountsInfo a
	LEFT JOIN QPRecordDB.dbo.RecordRichChange s ON CONVERT(VARCHAR(10),s.LastTime,23)=@day AND s.Reason IN (0,1) AND s.UserID=a.UserID
	WHERE a.IsAndroid=0 AND a.SpreaderID=@UserID
	GROUP BY a.UserID

	INSERT @temptable(UserID,ABC,Waste,SpreadSum)
	SELECT a.UserID,'C',IsNull(SUM(s.ChangeScore),0),ABS(IsNull(SUM(s.ChangeScore),0))*@C/100 ChangeScore 
	FROM QPAccountsDB.dbo.AccountsInfo a
	LEFT JOIN QPRecordDB.dbo.RecordRichChange s ON CONVERT(VARCHAR(10),s.LastTime,23)=@day AND s.Reason IN (0,1) AND s.UserID=a.UserID
	WHERE a.IsAndroid=0 AND a.SpreaderID IN (
		SELECT UserID FROM QPAccountsDB.dbo.AccountsInfo a1 
		WHERE a1.SpreaderID=@UserID
	)
	GROUP BY a.UserID

	SELECT @SpreadSum=IsNull(SUM(SpreadSum),0) FROM @temptable

	RETURN @SpreadSum
END

GO


IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('p_GetGamerSpreaderSumByDay')=id AND xtype='P')
	DROP PROC p_GetGamerSpreaderSumByDay
GO
CREATE PROC [dbo].[p_GetGamerSpreaderSumByDay]
	@UserID INT,
	@Day VARCHAR(10)
AS
BEGIN
	DECLARE @A VARCHAR(10),@B VARCHAR(10),@C VARCHAR(10),
			@SpreadSum BIGINT,@RealSpreadSum BIGINT,@RealSpreadSuma BIGINT,@RealSpreadSumb BIGINT

	SELECT @A=ARate,@B=BRate,@C=CRate FROM dbo.f_GetSpreaderRateByUserID(@UserID)

	declare @ytDay VARCHAR(10)
	set @ytDay= convert(VARCHAR(10),dateadd(DD,-1,@Day),23)

	SELECT a.Accounts,IsNull(SUM(s.ChangeScore),0) TodayWaste,ABS(IsNull(SUM(s.ChangeScore),0))*@A/100 TodayCommission 
	FROM QPAccountsDB.dbo.AccountsInfo a
	LEFT JOIN QPRecordDB.dbo.RecordRichChange s ON CONVERT(VARCHAR(10),s.LastTime,23)=@day AND s.Reason IN (0,1) AND s.UserID=a.UserID 
	WHERE a.IsAndroid=0 AND a.UserID=@UserID
	GROUP BY a.Accounts

	SELECT @RealSpreadSum =ABS(IsNull(SUM(s.ChangeScore),0))*@A/100   
	FROM QPAccountsDB.dbo.AccountsInfo a
	LEFT JOIN QPRecordDB.dbo.RecordRichChange s ON CONVERT(VARCHAR(10),s.LastTime,23)=@ytDay AND s.Reason IN (0,1) AND s.UserID=a.UserID 
	WHERE a.IsAndroid=0 AND a.UserID=@UserID
	GROUP BY a.Accounts


	SELECT a.Accounts,IsNull(SUM(s.ChangeScore),0) TodayWaste,ABS(IsNull(SUM(s.ChangeScore),0))*@B/100 TodayCommission 
	FROM QPAccountsDB.dbo.AccountsInfo a
	LEFT JOIN QPRecordDB.dbo.RecordRichChange s ON CONVERT(VARCHAR(10),s.LastTime,23)=@day AND s.Reason IN (0,1) AND s.UserID=a.UserID
	WHERE a.IsAndroid=0 AND a.SpreaderID=@UserID
	GROUP BY a.Accounts

	SELECT a.Accounts,IsNull(SUM(s.ChangeScore),0) TodayWaste,ABS(IsNull(SUM(s.ChangeScore),0))*@C/100 TodayCommission 
	FROM QPAccountsDB.dbo.AccountsInfo a
	LEFT JOIN QPRecordDB.dbo.RecordRichChange s ON CONVERT(VARCHAR(10),s.LastTime,23)=@day AND s.Reason IN (0,1) AND s.UserID=a.UserID
	WHERE a.IsAndroid=0 AND a.SpreaderID IN (
		SELECT UserID FROM QPAccountsDB.dbo.AccountsInfo a1 
		WHERE a1.SpreaderID=@UserID
	)
	GROUP BY a.Accounts
	
	SELECT @RealSpreadSuma =SUM([SpreadSum])  
    FROM [QPPlatformManagerDB].[dbo].[RecordSpreadSum] where Waste >0 and UserID=@UserID

    SELECT  @RealSpreadSumb =SUM([SpreadSum]) 
    FROM [QPPlatformManagerDB].[dbo].[RecordSpreadSum] where Waste <0 and UserID=@UserID
  
   
	SELECT ISNULL(@RealSpreadSum,0) AS RealSpreadSum

	SELECT ISNULL(@RealSpreadSuma,0) AS RealSpreadSuma

	SELECT ISNULL(@RealSpreadSumb,0) AS RealSpreadSumb

END 
GO


--����ÿ�շ�����¼�������ʼ� - byID
IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('p_Record_GamerSpreaderSumToday_ById')=id AND xtype='P')
	DROP PROC p_Record_GamerSpreaderSumToday_ById
GO
CREATE PROC [dbo].[p_Record_GamerSpreaderSumToday_ById]
	@UserID INT,
	@ToDay VARCHAR(10)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @A VARCHAR(10),@B VARCHAR(10),@C VARCHAR(10)
	SELECT @A=ARate,@B=BRate,@C=CRate FROM dbo.f_GetSpreaderRateByUserID(@UserID)
	 
	DECLARE @temptable TABLE (UserID INT,LastTime VARCHAR(10),Waste BIGINT,ABC VARCHAR(2),SpreadSum BIGINT)

	--�������ķ��� A
	INSERT @temptable(UserID,LastTime,ABC,Waste,SpreadSum)
	SELECT a.UserID,CONVERT(varchar(10), s.LastTime, 120) LastTime,'A',IsNull(SUM(s.ChangeScore),0),ABS(IsNull(SUM(s.ChangeScore),0))*@A/100 ChangeScore 
	FROM QPAccountsDB.dbo.AccountsInfo a
	LEFT JOIN QPRecordDB.dbo.RecordRichChange s ON CONVERT(VARCHAR(10),s.LastTime,23)=@Today AND s.Reason IN (0,1) AND s.UserID=a.UserID 
	WHERE a.IsAndroid=0 AND a.UserID=@UserID
	GROUP BY a.UserID,CONVERT(varchar(10), s.LastTime, 120)

	--A��չB���ķ���
	INSERT @temptable(UserID,LastTime,ABC,Waste,SpreadSum)
	SELECT a.UserID,CONVERT(varchar(10), s.LastTime, 120) LastTime,'B',IsNull(SUM(s.ChangeScore),0),ABS(IsNull(SUM(s.ChangeScore),0))*@B/100 ChangeScore 
	FROM QPAccountsDB.dbo.AccountsInfo a
	LEFT JOIN QPRecordDB.dbo.RecordRichChange s ON CONVERT(VARCHAR(10),s.LastTime,23)=@Today AND s.Reason IN (0,1) AND s.UserID=a.UserID
	WHERE a.IsAndroid=0 AND a.SpreaderID=@UserID
	GROUP BY a.UserID,CONVERT(varchar(10), s.LastTime, 120)

	--B��չC���ķ���
	INSERT @temptable(UserID,LastTime,ABC,Waste,SpreadSum)
	SELECT a.UserID,CONVERT(varchar(10), s.LastTime, 120) LastTime,'C',IsNull(SUM(s.ChangeScore),0),ABS(IsNull(SUM(s.ChangeScore),0))*@C/100 ChangeScore 
	FROM QPAccountsDB.dbo.AccountsInfo a
	LEFT JOIN QPRecordDB.dbo.RecordRichChange s ON CONVERT(VARCHAR(10),s.LastTime,23)=@Today AND s.Reason IN (0,1) AND s.UserID=a.UserID
	WHERE a.IsAndroid=0 AND a.SpreaderID IN (
		SELECT UserID FROM QPAccountsDB.dbo.AccountsInfo a1 
		WHERE a1.SpreaderID=@UserID
	)
	GROUP BY a.UserID,CONVERT(varchar(10), s.LastTime, 120)
	
	DECLARE @TodayWaste BIGINT,					--��������
			@SpreadSum BIGINT,					--���췵��
			@LastSpreadDate VARCHAR(10),		-- ��һ�ν�������
			@LastSpreadSum BIGINT				-- ��һ�ν������ڵ���ǰ��������֮��ķ��������������գ�

    SELECT @LastSpreadDate= IsNULL(MAX(SpreadDate),'1970-01-01') from  QPPlatformManagerDB.[dbo].[RecordUserSpreadTime] where UserID=@UserID  
    SELECT @LastSpreadSum=IsNULL(SUM(SpreadSum),0) FROM [QPPlatformManagerDB].[dbo].[RecordSpreadSum]
    WHERE SpreadDate>@LastSpreadDate AND UserID=@UserID AND ISNULL(EmailID,0) =0
	 
	SELECT @TodayWaste=IsNull(SUM(Waste),0)	FROM @temptable WHERE UserID=@UserID
	SELECT @SpreadSum=IsNull(SUM(SpreadSum),0) FROM @temptable
	
	BEGIN TRAN
	BEGIN TRY
		DECLARE @RecordSpreadSumID BIGINT
		DECLARE @EmailID BIGINT

		SELECT 1 FROM dbo.RecordSpreadSum WHERE UserID=@UserID AND SpreadDate=@Today
		IF NOT EXISTS(SELECT 1 FROM dbo.RecordSpreadSum WHERE UserID=@UserID AND SpreadDate=@Today)
		BEGIN
			INSERT dbo.RecordSpreadSum(UserID,Waste,SpreadSum,SpreadDate,LastTime)
			VALUES(@UserID,@TodayWaste,@SpreadSum,@Today,GETDATE())
			SET @RecordSpreadSumID=@@IDENTITY

			INSERT dbo.RecordSpreadSumDetail(RecordSpreadSumID,UserID,ABC,Waste,SpreadSum)
			SELECT @RecordSpreadSumID,UserID,ABC,Waste,SpreadSum FROM @temptable
			select @TodayWaste as  TodayWaste 
		 
			IF (@TodayWaste)<0 AND ABS(@TodayWaste)>@LastSpreadSum
			BEGIN
			  

				INSERT [QPTreasureDB].[dbo].[UserSystemMail](UserID, FromID, Title, Contents, AttachmentList, StateBit, CreateTime, UpdateTime,SpreadDate)
				VALUES(@UserID, 1, '������ҽ���', '��ϲ����Ϊ���յ�������ң������Ǹ������Ľ��������ٽ�������', '1,'+CONVERT(VARCHAR(20),@LastSpreadSum+@SpreadSum), 2, GETDATE(), GETDATE(),@Today)
				SET @EmailID=@@IDENTITY
 
				UPDATE RecordSpreadSum
				SET EmailID=@EmailID
				WHERE SpreadDate>@LastSpreadDate AND UserID=@UserID AND ISNULL(EmailID,0) =0

				--��¼���EMAIL
                INSERT INTO QPPlatformManagerDB.[dbo].[RecordUserSpreadTime]([UserID],[Waste],[SpreadSum],[Score],[EmailID],[EmailTime],[SpreadDate])VALUES
               (@UserID,@TodayWaste,@LastSpreadSum,@LastSpreadSum+@SpreadSum, @EmailID,GETDATE(),CONVERT(VARCHAR(10),@Today))



				--log
				DECLARE @Account NVARCHAR(100)
                SELECT @Account=  Accounts  FROM QPAccountsDB.dbo.AccountsInfo where UserID=@UserID
                INSERT INTO [dbo].[SystemSecurity]([OperatingTime] ,[OperatingName],[OperatingIP],[OperatingAccounts],[Module])
                VALUES(GETDATE(),'������ҽ��� [�û���:'+isnull(@Account,'��')+'(�û�ID:'+convert(varchar(20),@UserID)+'), �ʼ�ID:'+convert(varchar(20),@EmailID)+',�������:'+CONVERT(VARCHAR(20),isnull(@LastSpreadSum+@SpreadSum,0))+']','0.0.0.0','admin','�ʼ�����')
			

			END
		END
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
	END CATCH	

	SET NOCOUNT OFF
END

GO



--����ÿ�շ�����¼
IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('p_AddSpreadSumEmail')=id AND xtype='P')
	DROP PROC p_AddSpreadSumEmail
GO
CREATE PROC p_AddSpreadSumEmail
	@Today VARCHAR(10)
AS
BEGIN
	DECLARE @UserID INT
	DECLARE gamer_cur CURSOR FOR
	SELECT UserID FROM QPAccountsDB.dbo.AccountsInfo WHERE IsAndroid=0	
	OPEN gamer_cur
	FETCH NEXT FROM gamer_cur INTO @UserID
	WHILE @@FETCH_STATUS=0
	BEGIN 
		EXEC p_Record_GamerSpreaderSumToday_ById @UserID,@Today 
		FETCH NEXT FROM gamer_cur INTO @UserID
	END
	CLOSE gamer_cur
	DEALLOCATE gamer_cur
END

GO



--������ �����ʼ�
IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('p_AddAgentReveneSumEmail')=id AND xtype='P')
	DROP PROC p_AddAgentReveneSumEmail
GO
CREATE PROC [dbo].[p_AddAgentReveneSumEmail]
	@Today VARCHAR(50)
AS
BEGIN
	DECLARE @SQL NVARCHAR(MAX)='',
	@WasteSum BIGINT,
	@SpreadSum BIGINT,
	@UserID INT,
	@AgentRate INT,
	@ChildrenSpreader VARCHAR(MAX)
	
	DECLARE agent_cur Cursor FOR
	SELECT UserID FROM QPAccountsDB.dbo.AccountsInfo WHERE IsAgent=1
	 
	OPEN agent_cur
	FETCH NEXT FROM agent_cur INTO @UserID
	WHILE @@FETCH_STATUS=0
	BEGIN 
		SELECT @ChildrenSpreader=dbo.f_GetChildrenSpreaderUserID(@UserID)
		SELECT @AgentRate=IsNull(Percentage,0) FROM dbo.Base_Users WHERE AgentID=@UserID 
		DECLARE @LastSpreadDate VARCHAR(10)
	 
		SELECT @LastSpreadDate= IsNULL(MAX(SpreadDate),'1970-01-01') from  QPPlatformManagerDB.[dbo].[RecordAgentSpreadTime] where UserID=@UserID  
        
		BEGIN TRAN
		BEGIN TRY

		    SELECT @WasteSum=IsNULL(SUM(Waste),0) FROM [QPPlatformManagerDB].[dbo].[RecordSpreadSum]
            WHERE SpreadDate>@LastSpreadDate  AND SpreadDate <= CONVERT(VARCHAR(10),@Today)  AND   CHARINDEX(','+CAST( UserID as varchar)+',',','+@ChildrenSpreader+',')>0   
			 
		     
		    SELECT @SpreadSum=IsNULL(SUM(SpreadSum),0) FROM [QPPlatformManagerDB].[dbo].[RecordSpreadSum]
            WHERE SpreadDate>@LastSpreadDate AND SpreadDate <= CONVERT(VARCHAR(10),@Today)  AND  CHARINDEX(','+CAST( UserID as varchar)+',',','+@ChildrenSpreader+',')>0   
			
			 
			--PRINT @SQL
			IF @WasteSum<0 AND ABS(@WasteSum)>@SpreadSum
			BEGIN
			 
				 DECLARE @EmailID BIGINT
				INSERT [QPTreasureDB].[dbo].[UserSystemMail](UserID, FromID, Title, Contents, AttachmentList, StateBit, CreateTime, UpdateTime,SpreadDate)
				SELECT a.UserID, 1, '������', '���շ���', '1,'+CONVERT(VARCHAR(20),(ABS(@WasteSum)-@SpreadSum)*@AgentRate/100), 2, GETDATE(), GETDATE(),@Today
				FROM QPAccountsDB.dbo.AccountsInfo a
				WHERE a.UserID=@UserID AND ISNULL(@WasteSum,0)-IsNull(@SpreadSum,0)<>0
				SET @EmailID=@@IDENTITY

			   --��¼���EMAIL
                INSERT INTO QPPlatformManagerDB.[dbo].[RecordAgentSpreadTime]([UserID],[Waste],[SpreadSum],[Score],[EmailID],[EmailTime],[SpreadDate])VALUES
               (@UserID,@WasteSum,@SpreadSum,(ABS(@WasteSum)-@SpreadSum)*@AgentRate/100, @EmailID,GETDATE(),CONVERT(VARCHAR(10),@Today))

				---	log
				DECLARE @Account NVARCHAR(100)
                SELECT @Account=  Accounts  FROM QPAccountsDB.dbo.AccountsInfo where UserID=@UserID
                INSERT INTO [dbo].[SystemSecurity]([OperatingTime] ,[OperatingName],[OperatingIP],[OperatingAccounts],[Module])
                VALUES(GETDATE(),'������ �û���:'+isnull(@Account,'��')+',EMAILID:'+convert(varchar(20),@EmailID)+',���:'+CONVERT(VARCHAR(20),(ABS(@WasteSum)-@SpreadSum)*@AgentRate/100)+'','0.0.0.0','admin','�ʼ�����')
	
			END
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
			PRINT 'ChildrenSpreader: '+@ChildrenSpreader+' | '+ERROR_MESSAGE()
		END CATCH
		 
		FETCH NEXT FROM agent_cur INTO @UserID
	END
	CLOSE agent_cur
	DEALLOCATE agent_cur
END

GO



IF NOT EXISTS(SELECT 1 FROM dbo.SYSOBJECTS WHERE id=OBJECT_ID('RecordAgentSpreadTime'))
CREATE TABLE [dbo].[RecordAgentSpreadTime](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[Waste] [bigint] NULL,
	[SpreadSum] [bigint] NULL,
	[Score] [bigint] NULL,
	[EmailID] [bigint] NULL,
	[EmailTime] [datetime] NULL,
	[SpreadDate] [varchar](10) NOT NULL
)

GO

IF NOT EXISTS(SELECT 1 FROM dbo.SYSOBJECTS WHERE id=OBJECT_ID('RecordUserSpreadTime'))
CREATE TABLE [dbo].[RecordUserSpreadTime](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[Waste] [bigint] NULL,
	[SpreadSum] [bigint] NULL,
	[Score] [bigint] NULL,
	[EmailID] [bigint] NULL,
	[EmailTime] [datetime] NULL,
	[SpreadDate] [varchar](10) NOT NULL
)

GO