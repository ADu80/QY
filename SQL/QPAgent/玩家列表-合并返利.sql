USE [QPPlatformManagerDB]
GO

/****** Object:  StoredProcedure [dbo].[p_Get_GamerListInfoNew]    Script Date: 2017/3/11 17:46:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('p_Get_GamerListInfoNew')=id AND xtype='P')
	DROP PROC p_Get_GamerListInfoNew
GO

CREATE PROC [dbo].[p_Get_GamerListInfoNew]
	@GameID INT,
	@Accounts VARCHAR(30),
	@Range INT,
	@startDate VARCHAR(30)='',
	@endDate VARCHAR(30)='',
	@userType VARCHAR(20),
	@byUserID INT,
	@pageIndex INT,
	@pageSize INT
AS
BEGIN
	DECLARE @SQL VARCHAR(MAX)=''
	DECLARE @Where VARCHAR(MAX)=''
	DECLARE @newStartDate VARCHAR(10)='1970-01-01'
	DECLARE @newEndDate VARCHAR(10)=CONVERT(varchar(10), GETDATE(), 120)
	DECLARE @AgentSpreaderSumColumn VARCHAR(100)=''
	DECLARE @tempTable VARCHAR(50)
	SET @tempTable = Replace('##'+CONVERT(VARCHAR(50), NEWID()),'-','')

	DECLARE @tempTable1 VARCHAR(50)
	SET @tempTable1 = Replace('#1'+CONVERT(VARCHAR(50), NEWID()),'-','')

	DECLARE @tempTable2 VARCHAR(50)
	SET @tempTable2 = Replace('#2'+CONVERT(VARCHAR(50), NEWID()),'-','')

	DECLARE @tempTable3 VARCHAR(50)
	SET @tempTable3 = Replace('#3'+CONVERT(VARCHAR(50), NEWID()),'-','')

	DECLARE @tempTable4 VARCHAR(50)
	SET @tempTable4 = Replace('#4'+CONVERT(VARCHAR(50), NEWID()),'-','')

	DECLARE @tempTable5 VARCHAR(50)
	SET @tempTable5 = Replace('#4'+CONVERT(VARCHAR(50), NEWID()),'-','')

	--条件
	DECLARE @AllSubAgentIds VARCHAR(300)			--全部子代理商UserID
	SET @AllSubAgentIds=QPPlatformManagerDB.dbo.f_GetChildAgentID(@byUserID)

	IF @userType='admin' --管理员
	BEGIN
		IF @Range = 0	--直接代理玩家
		BEGIN
			SET @Where=@Where+' AND a.IsAgent=1 AND IsNULL(a.AgentID,0)=0'
		END
	END
	ELSE --代理商
	BEGIN
		IF @Range = 0	--直接代理玩家
		BEGIN
			SET @Where = @Where + ' AND ((IsNull(a.IsAgent,0)<>1 AND a.AgentID='+CONVERT(VARCHAR(15),@byUserID)+') OR a.UserID='+CONVERT(VARCHAR(15),@byUserID)+')'
		END
		ELSE
		BEGIN
			SET @Where = @Where + ' AND (a.AgentID IN ('+CONVERT(VARCHAR(15),@byUserID)+','+@AllSubAgentIds+') OR a.UserID IN ('+CONVERT(VARCHAR(15),@byUserID)+','+@AllSubAgentIds+'))'			
		END
	END

	IF @GameID <> -1
		SET @Where = @Where + ' AND a.GameID LIKE ''%'+CONVERT(VARCHAR(15),@GameID)+'%'''
	IF @Accounts <> ''
		SET @Where = @Where + ' AND a.Accounts LIKE ''%'+@Accounts+'%'''
	IF @startDate <> ''	
	BEGIN
		SET @Where = @Where + ' AND a.RegisterDate>='''+@startDate+''''
		SET @newStartDate=@startDate
	END
	IF @endDate <> ''
	BEGIN
		SET @Where = @Where + ' AND a.RegisterDate<='''+@endDate+' 23:59:59'''
		SET @newEndDate=@endDate
	END 

	SET @SQL='
	 SELECT   a.AgentID,  a.UserID,a.GameID,a.Accounts,a.NickName,ax.InviteCode,IsNull(s.InsureScore,0)+IsNull(Score,0) AllScore,
	IsNull(s.Score,0) Score,IsNull(s.InsureScore,0) InsureScore,s.Diamond Diamond,	s.RCard,0 Experience,0 [Level],
	IsNull((SELECT Sum(ISNULL(ChangeScore,0)) FROM QPRecordDB.dbo.RecordRichChange WHERE Reason IN (0,1) AND UserID=a.UserID),0)  Waste,
	IsNull((SELECT SUM(ISNULL(po.PayAmount,0)) FROM QPTreasureDB.dbo.PayOrder po WHERE po.UserID=a.UserID),0) Recharge,
	(CASE WHEN EXISTS(SELECT 1 FROM QPTreasureDB.dbo.GameScoreLocker WHERE UserID=a.UserID) THEN ''在线'' ELSE ''离线'' END) LoginStatus,a.GameLogonTimes LoginTimes,
	CASE WHEN a.Nullity=0 THEN ''正常'' ELSE ''冻结'' END Nullity,IsNull(a1.Accounts,''admin'') AgentName,IsNull(sp.Accounts,''admin'') SpreaderAccounts,
	a.RegisterIP,a.RegisterDate SpreaderDate,a.LastLogonIP,a.LastLogonDate,ROW_NUMBER() OVER(ORDER BY a.UserID) RowNo
	INTO   '+ @tempTable + '     
	FROM QPAccountsDB.dbo.AccountsInfo a
	LEFT JOIN QPTreasureDB.dbo.GameScoreInfo s ON a.UserID=s.UserID
	LEFT JOIN QPAccountsDB.dbo.AccountsInfo a1 ON a.AgentID=a1.UserID
	LEFT JOIN QPAccountsDB.dbo.AccountsInfo sp ON a.SpreaderID=sp.UserID
	LEFT JOIN QPAccountsDB.dbo.AccountsInfoEx ax ON a.UserID=ax.UserID 
	
	WHERE  a.IsAndroid=0 AND 1=1 '+@Where+'
	ORDER BY UserID

	SELECT totalCount=Count(1) FROM  '+ @tempTable + '     
	SELECT * INTO   '+ @tempTable2 + '    FROM   '+ @tempTable + '    
	WHERE RowNo BETWEEN '+CONVERT(VARCHAR(10),(@pageIndex-1)*@pageSize)+' AND '+CONVERT(VARCHAR(10),@pageIndex*@pageSize)+'
	select   ainfo.*, (CASE WHEN   EXISTS(SELECT 1 FROM QPAccountsDB.dbo.AccountsInfo WHERE UserID=ainfo.UserID AND ISNULL(AgentID,0)=0) THEN (SELECT ASpreaderRate 
		FROM [dbo].[AgentSpreaderOptions] o
		INNER JOIN (
			SELECT RoleID,GradeID FROM dbo.Base_Roles rr
				INNER JOIN dbo.Base_AgentGrades gg ON rr.AgentLevel=0 AND rr.AgentLevel=gg.AgentLevel
		) g ON o.RoleID=g.RoleID AND o.GradeID=g.GradeID) ELSE (SELECT ASpreaderRate 
		FROM [dbo].[AgentSpreaderOptions] o
		INNER JOIN (
			SELECT RoleID,GradeID FROM dbo.Base_Users u WHERE u.AgentID=(SELECT AgentID FROM QPAccountsDB.dbo.AccountsInfo WHERE UserID=ainfo.UserID)
		) g ON o.RoleID=g.RoleID AND o.GradeID=g.GradeID) END) ARate,  (CASE WHEN   EXISTS(SELECT 1 FROM QPAccountsDB.dbo.AccountsInfo WHERE UserID=ainfo.UserID AND ISNULL(AgentID,0)=0) THEN (SELECT BSpreaderRate 
		FROM [dbo].[AgentSpreaderOptions] o
		INNER JOIN (
			SELECT RoleID,GradeID FROM dbo.Base_Roles rr
				INNER JOIN dbo.Base_AgentGrades gg ON rr.AgentLevel=0 AND rr.AgentLevel=gg.AgentLevel
		) g ON o.RoleID=g.RoleID AND o.GradeID=g.GradeID) ELSE (SELECT BSpreaderRate 
		FROM [dbo].[AgentSpreaderOptions] o
		INNER JOIN (
			SELECT RoleID,GradeID FROM dbo.Base_Users u WHERE u.AgentID=(SELECT AgentID FROM QPAccountsDB.dbo.AccountsInfo WHERE UserID=ainfo.UserID)
		) g ON o.RoleID=g.RoleID AND o.GradeID=g.GradeID) END) BRate, (CASE WHEN   EXISTS(SELECT 1 FROM QPAccountsDB.dbo.AccountsInfo WHERE UserID=ainfo.UserID AND ISNULL(AgentID,0)=0) THEN (SELECT CSpreaderRate 
		FROM [dbo].[AgentSpreaderOptions] o
		INNER JOIN (
			SELECT RoleID,GradeID FROM dbo.Base_Roles rr
				INNER JOIN dbo.Base_AgentGrades gg ON rr.AgentLevel=0 AND rr.AgentLevel=gg.AgentLevel
		) g ON o.RoleID=g.RoleID AND o.GradeID=g.GradeID) ELSE (SELECT CSpreaderRate 
		FROM [dbo].[AgentSpreaderOptions] o
		INNER JOIN (
			SELECT RoleID,GradeID FROM dbo.Base_Users u WHERE u.AgentID=(SELECT AgentID FROM QPAccountsDB.dbo.AccountsInfo WHERE UserID=ainfo.UserID)
		) g ON o.RoleID=g.RoleID AND o.GradeID=g.GradeID) END) CRate,IsNull(SUM(sk.ChangeScore),0)  GamerWaste INTO   '+ @tempTable3 + ' from   '+ @tempTable2 + '    ainfo  

	left join QPRecordDB.dbo.RecordRichChange sk  on  sk.UserID=ainfo.UserID AND sk.Reason IN (0,1) AND sk.LastTime>=CONVERT(VARCHAR(10),GETDATE(),120) AND sk.LastTime<CONVERT(VARCHAR(10),DATEADD(day,1,GETDATE()),120)
	
	
	
	group by ainfo.AgentID , ainfo.UserID, ainfo.GameID , ainfo.Accounts,ainfo.NickName,ainfo.InviteCode,ainfo.AllScore,
	ainfo.Score,ainfo.InsureScore,ainfo.Diamond,ainfo.RCard,ainfo.Experience,ainfo.[Level],
	ainfo.Waste, ainfo.Recharge, ainfo.LoginStatus,ainfo.LoginTimes,ainfo.Nullity,ainfo. AgentName,  
	ainfo.SpreaderAccounts, ainfo.RegisterIP,ainfo.SpreaderDate,ainfo.LastLogonIP,ainfo.LastLogonDate,ainfo.RowNo,
	sk.[ID]   ,sk.[UserID]    ,sk.[KindID]    ,sk.[ServerID]   ,sk.[BeforeScore]   ,sk.[ChangeScore]   ,sk.[AfterScore]
    ,sk.[BeforeDiamond]    ,sk.[ChangeDiamond]     ,sk.[AfterDiamond]   ,sk.[BeforeRCard]  ,sk.[ChangeRCard]
    ,sk.[AfterRCard]   ,sk.[Revenue]    ,sk.[Reason]  ,sk.[LastTime]

	select ainfo.AgentID , ainfo.UserID, ainfo.GameID , ainfo.Accounts,ainfo.NickName,ainfo.InviteCode,ainfo.AllScore,
	ainfo.Score,ainfo.InsureScore,ainfo.Diamond,ainfo.RCard,ainfo.Experience,ainfo.[Level],
	ainfo.Waste, ainfo.Recharge, ainfo.LoginStatus,ainfo.LoginTimes,ainfo.Nullity,ainfo. AgentName,  
	ainfo.SpreaderAccounts, ainfo.RegisterIP,ainfo.SpreaderDate,ainfo.LastLogonIP,ainfo.LastLogonDate,ainfo.RowNo,
	ainfo.ARate,ainfo.BRate,ainfo.CRate,IsNull(SUM(ainfo. GamerWaste),0) as GamerWasteSumToday INTO   '+ @tempTable4 + '
	from '+ @tempTable3 + ' ainfo
	group by ainfo.AgentID , ainfo.UserID, ainfo.GameID , ainfo.Accounts,ainfo.NickName,ainfo.InviteCode,ainfo.AllScore,
	ainfo.Score,ainfo.InsureScore,ainfo.Diamond,ainfo.RCard,ainfo.Experience,ainfo.[Level],
	ainfo.Waste, ainfo.Recharge, ainfo.LoginStatus,ainfo.LoginTimes,ainfo.Nullity,ainfo. AgentName,  
	ainfo.SpreaderAccounts, ainfo.RegisterIP,ainfo.SpreaderDate,ainfo.LastLogonIP,ainfo.LastLogonDate,ainfo.RowNo,
	ainfo.ARate,ainfo.BRate,ainfo.CRate  
	select   ainfo.* 
	,(SELECT  IsNull(SUM(s.ChangeScore),0)
FROM      QPAccountsDB.dbo.AccountsInfo AS a LEFT OUTER JOIN
                   QPRecordDB.dbo.RecordRichChange AS s ON CONVERT(VARCHAR(10), s.LastTime, 23) = CONVERT(VARCHAR(10), 
                   GETDATE(), 23) AND s.Reason IN (0, 1) AND s.UserID = a.UserID AND a.IsAndroid=0 AND a.UserID=ainfo.UserID  ) fanlishu0
	,
	( 
	select sum(d.dd)  from  (    SELECT  abs( IsNull(SUM(s.ChangeScore),0))  dd
      FROM QPAccountsDB.dbo.AccountsInfo a
	LEFT JOIN QPRecordDB.dbo.RecordRichChange s ON CONVERT(VARCHAR(10),s.LastTime,23)=CONVERT(VARCHAR(10), GETDATE(), 23) AND s.Reason IN (0,1) AND s.UserID=a.UserID
	WHERE a.IsAndroid=0   AND a.SpreaderID=ainfo.UserID
	 GROUP BY a.UserID ,   a.SpreaderID
	 )d)    fanlishu1 
	 
	,
	(select sum(d.dd)  from  (SELECT IsNull(SUM(s.ChangeScore),0) dd
	FROM QPAccountsDB.dbo.AccountsInfo a
	LEFT JOIN QPRecordDB.dbo.RecordRichChange s ON CONVERT(VARCHAR(10),s.LastTime,23)=CONVERT(VARCHAR(10), GETDATE(), 23) AND s.Reason IN (0,1) AND s.UserID=a.UserID
	WHERE a.IsAndroid=0 AND a.SpreaderID IN (
		SELECT UserID FROM QPAccountsDB.dbo.AccountsInfo a1 
		WHERE a1.SpreaderID=ainfo.UserID
	)
	GROUP BY a.UserID)d)  fanlishu2 
	 into '+ @tempTable5 + ' from '+ @tempTable4 + ' ainfo  
	group by ainfo.AgentID , ainfo.UserID, ainfo.GameID , ainfo.Accounts,ainfo.NickName,ainfo.InviteCode,ainfo.AllScore,
	ainfo.Score,ainfo.InsureScore,ainfo.Diamond,ainfo.RCard,ainfo.Experience,ainfo.[Level],
	ainfo.Waste, ainfo.Recharge, ainfo.LoginStatus,ainfo.LoginTimes,ainfo.Nullity,ainfo. AgentName,  
	ainfo.SpreaderAccounts, ainfo.RegisterIP,ainfo.SpreaderDate,ainfo.LastLogonIP,ainfo.LastLogonDate,ainfo.RowNo  
	,ainfo.ARate,ainfo.BRate,ainfo.CRate,ainfo.GamerWasteSumToday 
	 select ainfo.AgentID , ainfo.UserID, ainfo.GameID , ainfo.Accounts,ainfo.NickName,ainfo.InviteCode,ainfo.AllScore,
	ainfo.Score,ainfo.InsureScore,ainfo.Diamond,ainfo.RCard,ainfo.Experience,ainfo.[Level],
	ainfo.Waste, ainfo.Recharge, ainfo.LoginStatus,ainfo.LoginTimes,ainfo.Nullity,ainfo. AgentName,  
	ainfo.SpreaderAccounts, ainfo.RegisterIP,ainfo.SpreaderDate,ainfo.LastLogonIP,ainfo.LastLogonDate,ainfo.RowNo
	,ainfo.GamerWasteSumToday 
	  ,sum(ainfo.fanlishu0) as sumfanli0 
     ,sum(ainfo.fanlishu1) as sumfanli1
	 ,sum(ainfo.fanlishu2) as sumfanli2 
	 , ABS((ainfo.ARate*sum(isnull(ainfo.fanlishu0,0))/100)+ABS(ainfo.BRate*sum(isnull(ainfo.fanlishu1,0))/100)+ABS(ainfo.CRate*sum(isnull(ainfo.fanlishu2,0))/100))  as GamerSpreaderSumToday 
	from '+ @tempTable5 + ' ainfo
	 group by ainfo.AgentID , ainfo.UserID, ainfo.GameID , ainfo.Accounts,ainfo.NickName,ainfo.InviteCode,ainfo.AllScore,
	ainfo.Score,ainfo.InsureScore,ainfo.Diamond,ainfo.RCard,ainfo.Experience,ainfo.[Level],
	ainfo.Waste, ainfo.Recharge, ainfo.LoginStatus,ainfo.LoginTimes,ainfo.Nullity,ainfo. AgentName,  
	ainfo.SpreaderAccounts, ainfo.RegisterIP,ainfo.SpreaderDate,ainfo.LastLogonIP,ainfo.LastLogonDate,ainfo.RowNo  
	,ainfo.ARate,ainfo.BRate,ainfo.CRate
	,ainfo.GamerWasteSumToday
 
	 drop table  '+ @tempTable5 + ' 
	drop table  '+ @tempTable4 + ' 
	drop table  '+ @tempTable2 + '   
	DROP TABLE  '+ @tempTable + '   
	drop table  '+ @tempTable3 + ''

	EXEC(@SQL) 
END



GO


