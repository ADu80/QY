USE QPPlatformManagerDB
GO

IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('f_GetAgentSpreaderSumByDate')=id AND xtype='FN')
	DROP FUNCTION f_GetAgentSpreaderSumByDate
GO
IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('f_GetGamerSpreaderSumByDate')=id AND xtype='FN')
	DROP FUNCTION f_GetGamerSpreaderSumByDate
GO
CREATE FUNCTION f_GetGamerSpreaderSumByDate(
	@UserID INT,
	@startDate VARCHAR(30),
	@endDate VARCHAR(30)
)
RETURNS BIGINT
AS
BEGIN
	DECLARE @SQL VARCHAR(MAX)=''
	DECLARE @dateWhere VARCHAR(500)=''
	DECLARE	@A VARCHAR(10),@B VARCHAR(10),@C VARCHAR(10)
	DECLARE	@SumAll BIGINT

	IF EXISTS(SELECT 1 FROM QPAccountsDB.dbo.AccountsInfo WHERE UserID=@UserID AND ISNULL(AgentID,0)=0)
	BEGIN
		SELECT @A=ASpreaderRate,@B=BSpreaderRate,@C=CSpreaderRate
		FROM [dbo].[AgentSpreaderOptions] o
		INNER JOIN (
			SELECT RoleID,GradeID FROM dbo.Base_Roles rr
				INNER JOIN dbo.Base_AgentGrades gg ON rr.AgentLevel=0 AND rr.AgentLevel=gg.AgentLevel
		) g ON o.RoleID=g.RoleID AND o.GradeID=g.GradeID
	END
	ELSE
	BEGIN
		SELECT @A=ASpreaderRate,@B=BSpreaderRate,@C=CSpreaderRate
		FROM [dbo].[AgentSpreaderOptions] o
		INNER JOIN (
			SELECT RoleID,GradeID FROM dbo.Base_Users u WHERE u.AgentID=(SELECT AgentID FROM QPAccountsDB.dbo.AccountsInfo WHERE UserID=@UserID)
		) g ON o.RoleID=g.RoleID AND o.GradeID=g.GradeID
	END

	DECLARE @temptable TABLE (UserID INT,LastTime VARCHAR(10),SumA BIGINT,SumB BIGINT,SumC BIGINT)

	INSERT @temptable(UserID,LastTime,SumA,SumB,SumC)
	SELECT a.UserID,CONVERT(varchar(10), s.LastTime, 120) LastTime,IsNull(SUM(s.ChangeScore),0)*@A/100 ChangeScore,0,0 FROM QPAccountsDB.dbo.AccountsInfo a
	LEFT JOIN QPRecordDB.dbo.RecordRichChange s ON s.LastTime>=CONVERT(VARCHAR(10),@startDate,120) AND s.LastTime<CONVERT(VARCHAR(10),DATEADD(day,1,@endDate),120) AND s.Reason IN (0,1) AND s.UserID=a.UserID 
	WHERE a.IsAndroid=0 AND a.UserID=@UserID
	GROUP BY a.UserID,CONVERT(varchar(10), s.LastTime, 120)
	HAVING IsNull(SUM(ChangeScore),0)<=0

	INSERT @temptable(UserID,LastTime,SumA,SumB,SumC)
	SELECT a.UserID,CONVERT(varchar(10), s.LastTime, 120) LastTime,0,IsNull(SUM(s.ChangeScore),0)*@B/100 ChangeScore,0 FROM QPAccountsDB.dbo.AccountsInfo a
	LEFT JOIN QPRecordDB.dbo.RecordRichChange s ON s.LastTime>=CONVERT(VARCHAR(10),@startDate,120) AND s.LastTime<CONVERT(VARCHAR(10),DATEADD(day,1,@endDate),120) AND s.Reason IN (0,1) AND s.UserID=a.UserID
	WHERE a.IsAndroid=0 AND a.SpreaderID=@UserID
	GROUP BY a.UserID,CONVERT(varchar(10), s.LastTime, 120)
	HAVING IsNull(SUM(ChangeScore),0)<=0

	INSERT @temptable(UserID,LastTime,SumA,SumB,SumC)
	SELECT a.UserID,CONVERT(varchar(10), s.LastTime, 120) LastTime,0,0,IsNull(SUM(s.ChangeScore),0)*@C/100 ChangeScore FROM QPAccountsDB.dbo.AccountsInfo a
	LEFT JOIN QPRecordDB.dbo.RecordRichChange s ON  s.LastTime>=CONVERT(VARCHAR(10),@startDate,120) AND s.LastTime<CONVERT(VARCHAR(10),DATEADD(day,1,@endDate),120) AND s.Reason IN (0,1) AND s.UserID=a.UserID
	WHERE a.IsAndroid=0 AND a.SpreaderID IN (
		SELECT UserID FROM QPAccountsDB.dbo.AccountsInfo a1 
		WHERE a1.SpreaderID=@UserID
	)
	GROUP BY a.UserID,CONVERT(varchar(10), s.LastTime, 120)
	HAVING IsNull(SUM(ChangeScore),0)<=0
	
	SELECT @SumAll=IsNull(SUM(SumA),0)+IsNull(SUM(SumB),0)+IsNull(SUM(SumC),0) FROM @temptable

	RETURN @SumAll
END

GO


--IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('p_GetAgentSpreaderSumByDate')=id AND xtype='P')
--	DROP PROC p_GetAgentSpreaderSumByDate
--GO
IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('p_GetGamerSpreaderSumByDate')=id AND xtype='P')
	DROP PROC p_GetGamerSpreaderSumByDate
GO
CREATE PROC p_GetGamerSpreaderSumByDate
	@UserID INT,
	@startDate VARCHAR(30),
	@endDate VARCHAR(30)
AS
BEGIN
	DECLARE @SQL VARCHAR(MAX)=''
	DECLARE @dateWhere VARCHAR(500)=''
	DECLARE	@A VARCHAR(10),@B VARCHAR(10),@C VARCHAR(10)
	DECLARE	@SumAll BIGINT

	IF EXISTS(SELECT 1 FROM QPAccountsDB.dbo.AccountsInfo WHERE UserID=@UserID AND ISNULL(AgentID,0)=0)
	BEGIN
		SELECT @A=ASpreaderRate,@B=BSpreaderRate,@C=CSpreaderRate
		FROM [dbo].[AgentSpreaderOptions] o
		INNER JOIN (
			SELECT RoleID,GradeID FROM dbo.Base_Roles rr
				INNER JOIN dbo.Base_AgentGrades gg ON rr.AgentLevel=0 AND rr.AgentLevel=gg.AgentLevel
		) g ON o.RoleID=g.RoleID AND o.GradeID=g.GradeID
	END
	ELSE
	BEGIN
		SELECT @A=ASpreaderRate,@B=BSpreaderRate,@C=CSpreaderRate
		FROM [dbo].[AgentSpreaderOptions] o
		INNER JOIN (
			SELECT RoleID,GradeID FROM dbo.Base_Users u WHERE u.AgentID=(SELECT AgentID FROM QPAccountsDB.dbo.AccountsInfo WHERE UserID=@UserID)
		) g ON o.RoleID=g.RoleID AND o.GradeID=g.GradeID
	END

	SELECT a.UserID,a.Accounts,IsNull(SUM(s.ChangeScore),0) TodayWaste,-(CASE WHEN IsNull(SUM(s.ChangeScore),0)<0 THEN IsNull(SUM(s.ChangeScore),0) ELSE 0 END)*@A/100 TodayCommission FROM QPAccountsDB.dbo.AccountsInfo a
	LEFT JOIN QPRecordDB.dbo.RecordRichChange s ON s.LastTime>=CONVERT(VARCHAR(10),@startDate,120) AND s.LastTime<CONVERT(VARCHAR(10),DATEADD(day,1,@endDate),120) AND s.Reason IN (0,1) AND s.UserID=a.UserID
	WHERE a.IsAndroid=0 AND a.UserID=@UserID
	GROUP BY a.UserID,a.Accounts

	SELECT a.UserID,a.Accounts,IsNull(SUM(s.ChangeScore),0) TodayWaste,-(CASE WHEN IsNull(SUM(s.ChangeScore),0)<0 THEN IsNull(SUM(s.ChangeScore),0) ELSE 0 END)*@B/100 TodayCommission FROM QPAccountsDB.dbo.AccountsInfo a
	LEFT JOIN QPRecordDB.dbo.RecordRichChange s ON s.LastTime>=CONVERT(VARCHAR(10),@startDate,120) AND s.LastTime<CONVERT(VARCHAR(10),DATEADD(day,1,@endDate),120) AND s.Reason IN (0,1) AND s.UserID=a.UserID
	WHERE a.IsAndroid=0 AND a.SpreaderID=@UserID
	GROUP BY a.UserID,a.Accounts

	SELECT a.UserID,a.Accounts,IsNull(SUM(s.ChangeScore),0) TodayWaste,-(CASE WHEN IsNull(SUM(s.ChangeScore),0)<0 THEN IsNull(SUM(s.ChangeScore),0) ELSE 0 END)*@C/100 TodayCommission FROM QPAccountsDB.dbo.AccountsInfo a
	LEFT JOIN QPRecordDB.dbo.RecordRichChange s ON s.LastTime>=CONVERT(VARCHAR(10),@startDate,120) AND s.LastTime<CONVERT(VARCHAR(10),DATEADD(day,1,@endDate),120) AND s.Reason IN (0,1) AND s.UserID=a.UserID
	WHERE a.IsAndroid=0 AND a.SpreaderID IN (
		SELECT UserID FROM QPAccountsDB.dbo.AccountsInfo a1 
		WHERE a1.SpreaderID=@UserID
	)
	GROUP BY a.UserID,a.Accounts

END

GO


--分享返利 发送邮件
IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('p_AddSpreadSumEmail')=id AND xtype='P')
	DROP PROC p_AddSpreadSumEmail
GO
CREATE PROC p_AddSpreadSumEmail
	@Today VARCHAR(50)
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM [QPTreasureDB].[dbo].[UserSystemMail] WHERE Title='幸运玩家奖励' AND SpreadDate=@Today)
	BEGIN
		INSERT [QPTreasureDB].[dbo].[UserSystemMail](UserID, FromID, Title, Contents, AttachmentList, StateBit, CreateTime, UpdateTime,SpreadDate)
		SELECT a.UserID, 1, '幸运玩家奖励', '恭喜您成为本日的幸运玩家，以下是给予您的奖励，请再接再厉！', '1,'+CONVERT(VARCHAR(20),-dbo.f_GetGamerSpreaderSumByDate(a.UserID,@Today,@Today)), 2, GETDATE(), GETDATE(),@Today
		FROM QPAccountsDB.dbo.AccountsInfo a
		WHERE a.IsAndroid=0 AND dbo.f_GetGamerSpreaderSumByDate(a.UserID,@Today,@Today)<>0
	END
END

GO


--代理返利 发送邮件
IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('p_AddAgentReveneSumEmail')=id AND xtype='P')
	DROP PROC p_AddAgentReveneSumEmail
GO
CREATE PROC p_AddAgentReveneSumEmail
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

		BEGIN TRY
		--玩家游戏消耗
		SET @SQL='
		SELECT @WasteSum=IsNull(SUM(s.ChangeScore),0)
		FROM [QPRecordDB].[dbo].[RecordRichChange](NOLOCK) s
		INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.UserID IN ('+@ChildrenSpreader+') AND a.IsAndroid=0 AND s.UserID=a.UserID
		WHERE 1=1 AND s.Reason = 0
		AND CONVERT(VARCHAR(100),s.LastTime,23)='''+@Today+'''

		SELECT @SpreadSum=IsNull(SUM(CONVERT(BIGINT,SubString(AttachmentList,3,len(AttachmentList)-2))),0)
		FROM [QPTreasureDB].[dbo].[UserSystemMail] s
		WHERE s.SpreadDate='''+@Today+''' 
			AND s.Title=''幸运玩家奖励''
			AND s.UserID IN ('+@ChildrenSpreader+') 
'
		EXEC sp_executesql @SQL	, N'@WasteSum BIGINT OUT,@SpreadSum BIGINT OUT'	, @WasteSum OUT,@SpreadSum OUT

		END TRY
		BEGIN CATCH
			--PRINT @ChildrenSpreader
		END CATCH
		--PRINT @SQL

		INSERT [QPTreasureDB].[dbo].[UserSystemMail](UserID, FromID, Title, Contents, AttachmentList, StateBit, CreateTime, UpdateTime,SpreadDate)
		SELECT a.UserID, 1, '代理返利', '昨日返利', '1,'+CONVERT(VARCHAR(20),(ISNULL(@WasteSum,0)-IsNull(@SpreadSum,0))*@AgentRate/100), 2, GETDATE(), GETDATE(),@Today
		FROM QPAccountsDB.dbo.AccountsInfo a
		WHERE a.UserID=@UserID AND ISNULL(@WasteSum,0)-IsNull(@SpreadSum,0)<>0

		FETCH NEXT FROM agent_cur INTO @UserID
	END
	CLOSE agent_cur
	DEALLOCATE agent_cur
END

GO




