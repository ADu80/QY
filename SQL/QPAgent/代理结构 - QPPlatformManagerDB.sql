Use QPPlatformManagerDB
GO


IF NOT EXISTS(SELECT 1 FROM dbo.SYSCOLUMNS WHERE OBJECT_ID('Base_Users')=id AND name ='canHasSubAgent')
	ALTER TABLE Base_Users
	ADD canHasSubAgent BIT
GO
IF NOT EXISTS(SELECT 1 FROM dbo.SYSCOLUMNS WHERE OBJECT_ID('Base_Users')=id AND name ='AgentLevelLimit')
	ALTER TABLE Base_Users
	ADD AgentLevelLimit INT
GO


------表名：角色表------
------修改内容：增加字段 操作人，创建时间和修改时间
IF NOT EXISTS(SELECT 1 FROM dbo.SYSCOLUMNS WHERE OBJECT_ID('Base_Roles')=id AND name ='AgentLevel')
	ALTER TABLE Base_Roles
	ADD AgentLevel INT
GO

IF NOT EXISTS(SELECT 1 FROM dbo.SYSCOLUMNS WHERE OBJECT_ID('Base_Roles')=id AND name = 'Operator')
	ALTER TABLE [dbo].[Base_Roles]
	ADD Operator VARCHAR(50)
GO

IF NOT EXISTS(SELECT 1 FROM dbo.SYSCOLUMNS WHERE OBJECT_ID('Base_Roles')=id AND name = 'Created')
	ALTER TABLE [dbo].[Base_Roles]
	ADD Created DATETIME
GO
IF NOT EXISTS(SELECT 1 FROM dbo.SYSCOLUMNS WHERE OBJECT_ID('Base_Roles')=id AND name = 'Modified')
	ALTER TABLE [dbo].[Base_Roles]
	ADD Modified DATETIME
GO


------表名：角色表------
------修改内容：增加字段 操作人，创建时间和修改时间
IF NOT EXISTS(SELECT 1 FROM dbo.SYSOBJECTS WHERE xtype='U' AND OBJECT_ID('SystemLog')=ID)
	CREATE TABLE SystemLog(
		ID BIGINT IDENTITY(1,1) PRIMARY KEY,
		LogContent VARCHAR(MAX),
		LogTime DATETIME,
		Operator INT,
		LoginIP VARCHAR(50),	
		Operation INT
	)

GO

IF NOT EXISTS(SELECT 1 FROM dbo.SYSCOLUMNS WHERE OBJECT_ID('SystemLog')=id AND name ='Module')
	ALTER TABLE SystemLog
	ADD Module VARCHAR(30)
GO



IF NOT EXISTS(SELECT 1 FROM dbo.SYSOBJECTS WHERE xtype='U' AND OBJECT_ID('SystemLogOperation')=ID)
--	DROP TABLE SystemLogOperation
--GO
CREATE TABLE SystemLogOperation(
	ID INT IDENTITY(1,1) PRIMARY KEY,
	Code VARCHAR(20),
	Operation VARCHAR(100)
)

GO

--管理员
IF EXISTS(SELECT 1 FROM dbo.SYSOBJECTS WHERE xtype='V' AND OBJECT_ID('vw_Base_Users')=ID)
	DROP VIEW vw_Base_Users
GO
CREATE VIEW [dbo].[vw_Base_Users]
AS
SELECT U.UserID, U.RoleID, R.RoleName,U.AgentID,U.VipID,Nullity
	, UserName, PreLogintime, PreLoginIP, LastLogintime, LastLoginIP
	, LoginTimes, IsBand, BandIP
FROM Base_Users U LEFT JOIN Base_Roles R ON U.RoleID = R.RoleID

GO


IF EXISTS(SELECT 1 FROM dbo.SYSOBJECTS WHERE xtype='V' AND OBJECT_ID('vw_SubAgentList')=ID)
	DROP VIEW vw_SubAgentList
GO
CREATE VIEW vw_SubAgentList
AS
SELECT u.UserID,u.UserName,u.RoleID,r.RoleName,u.GradeID,ag.GradeDes,u.Nullity,u.LastLogintime,u.LastLoginIP,a.AgentID,GameLogonTimes LoginTimes FROM dbo.Base_Users u
INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON u.AgentID=a.UserID
INNER JOIN dbo.Base_Roles r on u.RoleID=r.RoleID
LEFT JOIN [dbo].[Base_AgentGrades] ag ON u.GradeID=ag.GradeID
WHERE a.IsAgent=1

GO

IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('p_GetpSubAgentList')=id AND xtype='P')
	DROP PROC p_GetpSubAgentList
GO
CREATE PROC p_GetpSubAgentList
	@UserName VARCHAR(200)='',
	@AgentID INT=0,
	@Nullity INT=-1,
	@pageIndex INT,
	@pageSize INT
AS
DECLARE @SQL VARCHAR(MAX)=''
DECLARE @WHERE VARCHAR(MAX)=''
DECLARE @tempTable VARCHAR(50)
SET @tempTable = Replace('##'+CONVERT(VARCHAR(50), NEWID()),'-','')

IF(@UserName<>'')
BEGIN
	SET @Where+=' AND u.UserName LIKE ''%'+@UserName+'%'''
END
IF(@AgentID<>'')
BEGIN
	SET @Where+=' AND a.AgentID = '+CONVERT(VARCHAR(100),@AgentID)
END
IF(@Nullity<>-1)
BEGIN
	SET @Where+=' AND u.Nullity = '+CONVERT(VARCHAR(10),@Nullity)
END

SET @SQL='
SELECT u.UserID,u.UserName,u.RoleID,r.RoleName,u.GradeID,ag.GradeDes,u.Nullity,u.LastLogintime,u.LastLoginIP,a.AgentID,GameLogonTimes LoginTimes
,ROW_NUMBER() OVER(ORDER BY u.UserID) RowNo
INTO '+@tempTable+' FROM dbo.Base_Users u
INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON u.AgentID=a.UserID
INNER JOIN dbo.Base_Roles r on u.RoleID=r.RoleID
LEFT JOIN [dbo].[Base_AgentGrades] ag ON u.GradeID=ag.GradeID
WHERE a.IsAgent=1'+@Where+'

SELECT totalCount=COUNT(1) FROM '+@tempTable+'

SELECT * FROM ' + @tempTable + '
WHERE RowNo BETWEEN '+CONVERT(VARCHAR(10),(@pageIndex-1)*@pageSize+1)+' AND '+CONVERT(VARCHAR(10),@pageIndex*@pageSize)+'
ORDER BY RowNo

DROP TABLE ' + @tempTable

EXEC(@SQL)

GO


IF EXISTS(SELECT 1 FROM dbo.SYSOBJECTS WHERE xtype='V' AND OBJECT_ID('vw_Log')=ID)
	DROP VIEW vw_Log
GO
IF EXISTS(SELECT 1 FROM dbo.SYSOBJECTS WHERE xtype='V' AND OBJECT_ID('vw_SystemLog')=ID)
	DROP VIEW vw_SystemLog
GO
CREATE VIEW vw_SystemLog
AS
SELECT l.ID,o.Operation,l.LogContent,l.Operator OperatorID,u.UserName Operator,l.LogTime,l.LoginIP
FROM dbo.SystemLog l
INNER JOIN dbo.Base_Users u ON l.Operator=u.UserID
INNER JOIN dbo.SystemLogOperation o ON l.Operation=o.ID

GO


IF EXISTS(SELECT 1 FROM dbo.SYSOBJECTS WHERE xtype='V' AND OBJECT_ID('vw_Agents_Tree')=ID)
	DROP VIEW vw_Agents_Tree
GO
CREATE VIEW vw_Agents_Tree
AS


SELECT a.UserID ID,a.Accounts UserName,a.AgentID ParentID,a.IsAgent,u.UserID AdminID,u.RoleID,r.RoleName,ag.GradeDes,IsNull(r.AgentLevel,0) AgentLevel
,IsNull(u.canHasSubAgent,0) canHasSubAgent,IsNull(u.AgentLevelLimit,0) AgentLevelLimit,IsNull(a.AgentID,0) PAgentID
FROM QPAccountsDB.dbo.AccountsInfo a
INNER JOIN dbo.Base_Users u ON a.UserID=u.AgentID
LEFT JOIN dbo.Base_Roles r ON u.RoleID=r.RoleID
LEFT JOIN dbo.[Base_AgentGrades] ag ON u.GradeID=ag.GradeID
WHERE a.IsAgent=1


GO


IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('p_GetSystemLog')=id AND xtype='P')
	DROP PROC p_GetSystemLog
GO
CREATE PROC p_GetSystemLog
	@byUserID INT,
	@Accounts VARCHAR(100),
	@userType VARCHAR(10),
	@operationID INT ,
	@startDate VARCHAR(30)='',
	@endDate VARCHAR(30)='',
	@pageIndex INT,
	@pageSize INT
AS
BEGIN
	DECLARE @SQL VARCHAR(MAX)=''
	DECLARE @Where VARCHAR(1000)=''
	DECLARE @tempTable VARCHAR(50)
	DECLARE @tempAccount VARCHAR(50)
	SET @tempTable = Replace('##'+CONVERT(VARCHAR(50), NEWID()),'-','')
	SET @tempAccount = Replace('##'+CONVERT(VARCHAR(50), NEWID()),'-','')
		
	DECLARE @AllSubAgentIds VARCHAR(300)			--全部子代理商UserID
	--DECLARE @byUserID INT
	--SELECT @byUserID=AgentID FROM Base_Users WHERE UserID=@byAdminID
	SET @AllSubAgentIds=QPPlatformManagerDB.dbo.f_GetChildAgentID(@byUserID)

	IF @userType='agent' 
	BEGIN
		SET @Where=@Where+' AND (a.AgentID IN ('+CONVERT(VARCHAR(30),@byUserID)+','+@AllSubAgentIds+') OR a.UserID IN('+CONVERT(VARCHAR(30),@byUserID)+','+@AllSubAgentIds+'))'
	END

	IF @Accounts<>''
		SET @Where=@Where+' AND a.UserName LIKE ''%'+@Accounts+'%'''
	IF @startDate<>''
		SET @Where=@Where+' AND l.LogTime >= '''+@startDate+''''
	IF @endDate<>''
		SET @Where=@Where+' AND l.LogTime <= '''+@endDate+' 23:59:59'''
	IF @operationID<>-1
		SET @Where=@Where+' AND l.Operation = '+CONVERT(VARCHAR(10),@operationID)
	--查询操作日志
	SET @SQL='
	SELECT u.UserID AdminID,u.UserName,a.UserID,a.AgentID
	INTO '+@tempAccount+'
	FROM dbo.Base_Users u
	LEFT JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0 AND a.UserID=u.AgentID

	SELECT l.ID,o.Operation,l.LogContent,l.Operator OperatorID,a.UserName Operator,l.LogTime,l.LoginIP,l.Module,ROW_NUMBER() OVER(ORDER BY l.LogTime DESC) RowNo 
	INTO '+@tempTable+'
	FROM [dbo].SystemLog l
	INNER JOIN dbo.SystemLogOperation o ON l.Operation=o.ID	
	INNER JOIN '+@tempAccount+' a ON l.Operator=a.AdminID
	WHERE 1=1
'	+@Where+ '

	SELECT totalCount=Count(1) FROM '+ @tempTable + '

	SELECT * FROM ' + @tempTable + '
	WHERE RowNo BETWEEN '+CONVERT(VARCHAR(10),(@pageIndex-1)*@pageSize+1)+' AND '+CONVERT(VARCHAR(10),@pageIndex*@pageSize)+'
	ORDER BY RowNo

	DROP TABLE '+@tempAccount+'
	DROP TABLE '+@tempTable
	
	--SELECT @SQL
	EXEC(@SQL)
END

GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[f_splitStr]') AND xtype IN (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[f_splitStr]
GO
--方法1：循环截取法
CREATE FUNCTION [f_splitStr](
	@s		VARCHAR(8000),   --待分拆的字符串
	@split	VARCHAR(10)     --数据分隔符
)
RETURNS @re TABLE(col varchar(100))
AS
BEGIN
	DECLARE @splitlen INT
	SET @splitlen=LEN(@split+'a')-2
	WHILE CHARINDEX(@split,@s)>0
	BEGIN
		INSERT @re VALUES(LEFT(@s,CHARINDEX(@split,@s)-1))
		SET @s=STUFF(@s,1,CHARINDEX(@split,@s)+@splitlen,'')
	END
	INSERT @re VALUES(@s)
	RETURN
END

GO


IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('f_GetChildAgentID')=id AND xtype='FN')
	DROP FUNCTION f_GetChildAgentID
GO
CREATE FUNCTION f_GetChildAgentID(
	@UserID INT
)
RETURNS VARCHAR(MAX)
AS
BEGIN
DECLARE @UserIDs VARCHAR(MAX)
SET @UserIDs=''
;WITH c AS(
	SELECT a.UserID,a.Accounts,a.IsAgent,a.AgentID FROM [QPAccountsDB].dbo.AccountsInfo a
	WHERE IsAgent=1 AND UserID=@UserID
	UNION ALL 
	SELECT b.UserID,b.Accounts,b.IsAgent,b.AgentID FROM [QPAccountsDB].dbo.AccountsInfo b,c
	WHERE b.IsAgent=1 AND b.AgentID=c.UserID
)
SELECT @UserIDs=@UserIDs+Convert(Varchar(10),c.UserID)+',' FROM c WHERE c.UserID<>@UserID
IF(@UserIDs='')
BEGIN
	SET @UserIDs='-1'
END
ELSE
BEGIN
	SET @UserIDs=SUBSTRING(@UserIDs,1,len(@UserIDs)-1)
END
RETURN @UserIDs
END

GO

IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('f_GetChildAndSelfAgentID')=id AND xtype='FN')
	DROP FUNCTION f_GetChildAndSelfAgentID
GO
CREATE FUNCTION f_GetChildAndSelfAgentID(
	@UserID INT
)
RETURNS VARCHAR(MAX)
AS
BEGIN
DECLARE @UserIDs VARCHAR(MAX)
SET @UserIDs=''
;WITH c AS(
	SELECT a.UserID,a.Accounts,a.IsAgent,a.AgentID FROM [QPAccountsDB].dbo.AccountsInfo a
	WHERE IsAgent=1 AND UserID=@UserID
	UNION ALL 
	SELECT b.UserID,b.Accounts,b.IsAgent,b.AgentID FROM [QPAccountsDB].dbo.AccountsInfo b,c
	WHERE b.IsAgent=1 AND b.AgentID=c.UserID
)
SELECT @UserIDs=@UserIDs+Convert(Varchar(20),c.UserID)+',' FROM c WHERE c.UserID<>@UserID
IF(@UserIDs='')
BEGIN
	SET @UserIDs='-1'
END
ELSE
BEGIN
	SET @UserIDs=@UserIDs+Convert(VARCHAR(20),@UserID)
END
RETURN @UserIDs
END

GO


--IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('f_GetParentsAgentLevelCount')=id AND xtype='FN')
--	DROP FUNCTION f_GetParentsAgentLevelCount
--GO
--CREATE FUNCTION f_GetParentsAgentLevelCount(
--	@UserID INT
--)
--RETURNS INT
--AS
--BEGIN
--DECLARE @Count INT
--;WITH c AS(
--	SELECT a.UserID,a.Accounts,a.IsAgent,a.AgentID FROM [QPAccountsDB].dbo.AccountsInfo a
--	WHERE IsAgent=1 AND UserID=@UserID
--	UNION ALL 
--	SELECT b.UserID,b.Accounts,b.IsAgent,b.AgentID FROM [QPAccountsDB].dbo.AccountsInfo b,c
--	WHERE b.IsAgent=1 AND b.UserID=c.AgentID
--)
--SELECT @Count=COUNT(1) FROM c
----WHERE UserID<>@UserID
--RETURN @Count
--END

--GO


IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('f_GetAgentWaste')=id AND xtype='FN')
	DROP FUNCTION f_GetAgentWaste
GO
CREATE FUNCTION f_GetAgentWaste(@UserID INT)
RETURNS BIGINT
AS
BEGIN
	DECLARE @Waste BIGINT=0
	DECLARE @SQL NVARCHAR(MAX)
	DECLARE @AllSubAgentIds VARCHAR(300)			--全部子代理商UserID
	DECLARE @AgentIdsTb TABLE(ID INT)
	SET @AllSubAgentIds=QPPlatformManagerDB.dbo.f_GetChildAndSelfAgentID(@UserID)	
	INSERT @AgentIdsTb(ID) SELECT col FROM dbo.[f_splitStr](@AllSubAgentIds,',')
	SELECT @Waste=SUM(s.ChangeScore) FROM QPRecordDB.dbo.RecordRichChange s
		INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON s.UserID=a.UserID
		WHERE (a.AgentID IN (SELECT ID FROM @AgentIdsTb) OR a.UserID IN (SELECT ID FROM @AgentIdsTb)) and s.Reason IN (0,1)
	
	RETURN IsNull(@Waste,0)
END
GO

IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('f_GetAgentRecharge')=id AND xtype='FN')
	DROP FUNCTION f_GetAgentRecharge
GO
CREATE FUNCTION f_GetAgentRecharge(@UserID INT)
RETURNS BIGINT
AS
BEGIN
	DECLARE @Recharge BIGINT=0
	DECLARE @SQL NVARCHAR(MAX)
	DECLARE @AllSubAgentIds VARCHAR(300)			--全部子代理商UserID
	DECLARE @AgentIdsTb TABLE(ID INT)
	SET @AllSubAgentIds=QPPlatformManagerDB.dbo.f_GetChildAndSelfAgentID(@UserID)	
	INSERT @AgentIdsTb(ID) SELECT col FROM dbo.[f_splitStr](@AllSubAgentIds,',')
	SELECT @Recharge=SUM(PayAmount) FROM QPTreasureDB.dbo.PayOrder s
		INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON s.UserID=a.UserID
		WHERE (a.AgentID IN (SELECT ID FROM @AgentIdsTb) OR a.UserID IN (SELECT ID FROM @AgentIdsTb))	
	
	RETURN IsNull(@Recharge,0)
END
GO

IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('f_GetAgentOnLineCount')=id AND xtype='FN')
	DROP FUNCTION f_GetAgentOnLineCount
GO
CREATE FUNCTION f_GetAgentOnLineCount(@UserID INT)
RETURNS BIGINT
AS
BEGIN
	DECLARE @OnLineCount BIGINT=0
	DECLARE @SQL NVARCHAR(MAX)
	DECLARE @AllSubAgentIds VARCHAR(300)			--全部子代理商UserID
	DECLARE @AgentIdsTb TABLE(ID INT)
	SET @AllSubAgentIds=QPPlatformManagerDB.dbo.f_GetChildAndSelfAgentID(@UserID)	
	INSERT @AgentIdsTb(ID) SELECT col FROM dbo.[f_splitStr](@AllSubAgentIds,',')
	SELECT @OnLineCount=COUNT(1) FROM  QPTreasureDB.dbo.GameScoreLocker(NOLOCK) s
		INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON s.UserID=a.UserID
		WHERE (a.AgentID IN (SELECT ID FROM @AgentIdsTb) OR a.UserID IN (SELECT ID FROM @AgentIdsTb))	
RETURN IsNull(@OnLineCount,0)
END
GO


IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('f_GetAgentSubGamerCount')=id AND xtype='FN')
	DROP FUNCTION f_GetAgentSubGamerCount
GO
CREATE FUNCTION f_GetAgentSubGamerCount(@UserID INT)
RETURNS BIGINT
AS
BEGIN
	DECLARE @GamerCount BIGINT=0
	DECLARE @SQL NVARCHAR(MAX)
	DECLARE @AllSubAgentIds VARCHAR(300)			--全部子代理商UserID
	DECLARE @AgentIdsTb TABLE(ID INT)
	SET @AllSubAgentIds=QPPlatformManagerDB.dbo.f_GetChildAndSelfAgentID(@UserID)	
	INSERT @AgentIdsTb(ID) SELECT col FROM dbo.[f_splitStr](@AllSubAgentIds,',')
	SELECT @GamerCount=COUNT(UserID) FROM QPAccountsDB.dbo.AccountsInfo(NOLOCK) a
		WHERE (a.AgentID IN (SELECT ID FROM @AgentIdsTb) OR a.UserID IN (SELECT ID FROM @AgentIdsTb))	
	RETURN IsNull(@GamerCount,0)
END
GO

IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('f_GetAgentSubGamerScore')=id AND xtype='FN')
	DROP FUNCTION f_GetAgentSubGamerScore
GO
CREATE FUNCTION f_GetAgentSubGamerScore(@UserID INT)
RETURNS BIGINT
AS
BEGIN
	DECLARE @GamerScore BIGINT=0
	DECLARE @SQL NVARCHAR(MAX)
	DECLARE @AllSubAgentIds VARCHAR(300)			--全部子代理商UserID
	DECLARE @AgentIdsTb TABLE(ID INT)
	SET @AllSubAgentIds=QPPlatformManagerDB.dbo.f_GetChildAndSelfAgentID(@UserID)	
	INSERT @AgentIdsTb(ID) SELECT col FROM dbo.[f_splitStr](@AllSubAgentIds,',')
	SELECT @GamerScore=SUM(s.Score) FROM QPTreasureDB.dbo.GameScoreInfo(NOLOCK) s 
		INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON s.UserID=a.UserID  
		WHERE (a.AgentID IN (SELECT ID FROM @AgentIdsTb) OR a.UserID IN (SELECT ID FROM @AgentIdsTb))	
	RETURN IsNull(@GamerScore,0)
END
GO

IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('f_GetSubAgentCount')=id AND xtype='FN')
	DROP FUNCTION f_GetSubAgentCount
GO
CREATE FUNCTION f_GetSubAgentCount(@UserID INT)
RETURNS BIGINT
AS
BEGIN
	DECLARE @SubAgentCount BIGINT=0
	DECLARE @SQL NVARCHAR(MAX)
	DECLARE @AllSubAgentIds VARCHAR(300)			--全部子代理商UserID
	DECLARE @AgentIdsTb TABLE(ID INT)
	SET @AllSubAgentIds=QPPlatformManagerDB.dbo.f_GetChildAndSelfAgentID(@UserID)	
	INSERT @AgentIdsTb(ID) SELECT col FROM dbo.[f_splitStr](@AllSubAgentIds,',')
	SELECT @SubAgentCount=COUNT(1) FROM QPAccountsDB.dbo.AccountsInfo a
		WHERE a.UserID IN (SELECT ID FROM @AgentIdsTb)
	RETURN IsNull(@SubAgentCount,0)
END
GO



IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('p_Get_SubAgentListInfo')=id AND type='P')
	DROP PROC p_Get_SubAgentListInfo
GO
CREATE PROC p_Get_SubAgentListInfo
	@SpreaderID INT,
	@Accounts VARCHAR(30),
	@Range INT,
	@startDate VARCHAR(30),
	@endDate VARCHAR(30),
	@userType VARCHAR(10),
	@byUserID INT,
	@pageIndex INT,
	@pageSize INT
AS
BEGIN
	DECLARE @SQL VARCHAR(MAX)=''
	DECLARE @Where VARCHAR(MAX)=''
	DECLARE @tempTable VARCHAR(50)
	SET @tempTable = Replace('##'+CONVERT(VARCHAR(50), NEWID()),'-','')

	--条件
	DECLARE @AllSubAgentIds VARCHAR(300)			--全部子代理商UserID
	SET @AllSubAgentIds=QPPlatformManagerDB.dbo.f_GetChildAgentID(@byUserID)

	IF @userType='admin'
	BEGIN
		IF @Range = 0
		BEGIN
			SET @Where=@Where+' AND EXISTS(SELECT 1 FROM dbo.Base_Roles WHERE AgentLevel=1 AND RoleID=u.RoleID)'
		END
	END
	ELSE
	BEGIN
		IF @Range = 0
		BEGIN
			SET @Where = @Where + ' AND a.AgentID ='+CONVERT(VARCHAR(15),@byUserID)
		END
		ELSE
		BEGIN
			SET @Where = @Where + ' AND a.UserID IN ('+@AllSubAgentIds+')'
		END
	END
		
	IF @SpreaderID <> -1
		SET @Where = @Where + ' AND a.UserID IN (SELECT UserID FROM QPPlatformDB.dbo.InviteCode WHERE CodeID='+CONVERT(VARCHAR(15),@SpreaderID)+')'
	IF @Accounts <> ''
		SET @Where = @Where + ' AND a.Accounts LIKE ''%'+@Accounts+'%'''
	IF @startDate <> ''
		SET @Where = @Where + ' AND a.RegisterDate >='''+@startDate+''''
	IF @endDate <> ''
		SET @Where = @Where + ' AND a.RegisterDate <='''+@endDate+'  23:59:59'''

	SET @SQL='
	SELECT a.UserID,a.GameID,a.Accounts,a.NickName,
	dbo.f_GetAgentWaste(a.UserID) AllWaste,	dbo.f_GetAgentSubGamerCount(a.UserID) AllGamerCount,dbo.f_GetAgentSubGamerScore(a.UserID) AllGamerScore,
	dbo.f_GetAgentRecharge(a.UserID) Recharge,dbo.f_GetAgentOnLineCount(a.UserID) OnlineCount,
	dbo.f_GetSubAgentCount(a.UserID) SubAgentCount,a2.InviteCode,
	Percentage,u.Nullity [Status],a.RegisterDate SpreaderDate,a.AgentID HigherAgentID,IsNull(a1.Accounts,''admin'') HigherAgentName,ROW_NUMBER() OVER(ORDER BY a.UserID) RowNo
	INTO '+ @tempTable + ' 
	FROM QPAccountsDB.dbo.AccountsInfo a
	INNER JOIN [dbo].[Base_Users] u ON a.UserID=u.AgentID
	LEFT JOIN QPAccountsDB.dbo.AccountsInfo a1 ON a.AgentID=a1.UserID
	LEFT JOIN QPAccountsDB.dbo.AccountsInfoEx a2 ON a.UserID=a2.UserID
	WHERE a.IsAgent=1 '+@Where+'

	ORDER BY UserID ASC'

	SET @SQL = @SQL + '
	SELECT totalCount=Count(1) FROM '+ @tempTable + '

	SELECT * FROM ' + @tempTable + '
	WHERE RowNo BETWEEN '+CONVERT(VARCHAR(10),(@pageIndex-1)*@pageSize)+' AND '+CONVERT(VARCHAR(10),@pageIndex*@pageSize)+'
	DROP TABLE '+@tempTable

	EXEC(@SQL)
END

GO



IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('p_Get_GamerListInfo')=id AND xtype='P')
	DROP PROC p_Get_GamerListInfo
GO
CREATE PROC p_Get_GamerListInfo
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
	SELECT DISTINCT a.UserID,a.GameID,a.Accounts,a.NickName,ax.InviteCode,IsNull(s.InsureScore,0)+IsNull(Score,0) AllScore,
	IsNull(s.Score,0) Score,IsNull(s.InsureScore,0) InsureScore,s.Diamond Diamond,	s.RCard,0 Experience,0 [Level],
	IsNull((SELECT Sum(ISNULL(ChangeScore,0)) FROM QPRecordDB.dbo.RecordRichChange WHERE Reason IN (0,1) AND UserID=a.UserID),0)  Waste,
	IsNull((SELECT SUM(ISNULL(po.PayAmount,0)) FROM QPTreasureDB.dbo.PayOrder po WHERE po.UserID=a.UserID),0) Recharge,
	(CASE WHEN EXISTS(SELECT 1 FROM QPTreasureDB.dbo.GameScoreLocker WHERE UserID=a.UserID) THEN ''在线'' ELSE ''离线'' END) LoginStatus,a.GameLogonTimes LoginTimes,
	CASE WHEN a.Nullity=0 THEN ''正常'' ELSE ''冻结'' END Nullity,IsNull(a1.Accounts,''admin'') AgentName,IsNull(sp.Accounts,''admin'') SpreaderAccounts,
	a.RegisterIP,a.RegisterDate SpreaderDate,a.LastLogonIP,a.LastLogonDate,ROW_NUMBER() OVER(ORDER BY a.UserID) RowNo
	INTO '+ @tempTable + ' 
	FROM QPAccountsDB.dbo.AccountsInfo a
	LEFT JOIN QPTreasureDB.dbo.GameScoreInfo s ON a.UserID=s.UserID
	LEFT JOIN QPAccountsDB.dbo.AccountsInfo a1 ON a.AgentID=a1.UserID
	LEFT JOIN QPAccountsDB.dbo.AccountsInfo sp ON a.SpreaderID=sp.UserID
	LEFT JOIN QPAccountsDB.dbo.AccountsInfoEx ax ON a.UserID=ax.UserID 
	WHERE  a.IsAndroid=0 AND 1=1 '+@Where+'
	ORDER BY UserID

	SELECT totalCount=Count(1) FROM '+ @tempTable + '

	SELECT *,dbo.f_GetGamerWasteByDate(UserID,GETDATE(),GETDATE()) GamerWasteSumToday,dbo.f_GetGamerSpreaderSumByDay(UserID,CONVERT(VARCHAR(100),GETDATE(),23)) GamerSpreaderSumToday FROM ' + @tempTable + '
	WHERE RowNo BETWEEN '+CONVERT(VARCHAR(10),(@pageIndex-1)*@pageSize)+' AND '+CONVERT(VARCHAR(10),@pageIndex*@pageSize)+'
	DROP TABLE '+@tempTable

	EXEC(@SQL)
END

GO


IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('p_GetAgentsTree')=id AND xtype='P')
	DROP PROC p_GetAgentsTree
GO
CREATE PROC p_GetAgentsTree
	@UserID INT,
	@IsAgent BIT
AS
IF @IsAgent=1
BEGIN
	DECLARE @UserIds VARCHAR(100)
	SET @UserIds=[QPPlatformManagerDB].[dbo].[f_GetChildAgentID](@UserID)
	DECLARE @SQL NVARCHAR(MAX)
	SET @SQL=N'SELECT * FROM [QPPlatformManagerDB].[dbo].[vw_Agents_Tree] WHERE ID IN ('+CONVERT(VARCHAR(10),@UserID)+','+@UserIds+')'
	EXEC(@SQL)
END
ELSE
BEGIN
	SELECT * FROM dbo.vw_Agents_Tree
END

GO




IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('p_UpdateAdminPassword')=id AND xtype='P')
	DROP PROC p_UpdateAdminPassword
GO
CREATE PROC [dbo].[p_UpdateAdminPassword]
	@UserID INT,
	@oldPwd VARCHAR(50),
	@newPwd VARCHAR(50)
AS
BEGIN
	SELECT 1 FROM dbo.Base_Users WHERE UserID=@UserID AND [Password]=@oldPwd
	IF NOT EXISTS(SELECT 1 FROM dbo.Base_Users WHERE UserID=@UserID AND [Password]=@oldPwd)
	BEGIN
		RETURN -1 --原密码输入错误
	END
	BEGIN TRAN
	BEGIN TRY
		UPDATE u
		SET u.[Password]=@newPwd
		FROM dbo.Base_Users u
		WHERE u.UserID=@UserID

		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		THROW
	END CATCH
END

GO


--重置密码：
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('p_ReSetAgentPassword')=id AND type='P')
	DROP PROC p_ReSetAgentPassword
GO
CREATE PROC p_ReSetAgentPassword
	@UserID INT,
	@defaulPwd VARCHAR(50)
AS
BEGIN
	UPDATE u
	SET u.[Password]=@defaulPwd
	FROM dbo.Base_Users u
	WHERE u.UserID=@UserID
END

GO


IF NOT EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('Base_AgentGrades')=id AND xtype='U')	
--	DROP TABLE Base_AgentGrades
--GO
	CREATE TABLE Base_AgentGrades
	(
		GradeID INT IDENTITY(1,1) PRIMARY KEY,
		GradeDes VARCHAR(20),
		AgentLevel INT,
		Created DATETIME,
		Modified DATETIME
	)
GO

IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('Base_AgentRoleGrades')=id AND xtype='U')
	DROP TABLE Base_AgentRoleGrades
GO

IF NOT EXISTS(SELECT 1 FROM dbo.SYSCOLUMNS WHERE OBJECT_ID('Base_Users')=id AND name ='GradeID')
	ALTER TABLE Base_Users
	ADD GradeID INT
GO



IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('p_UpdateSpreaderID')=id AND type='P')
	DROP PROC p_UpdateSpreaderID
GO
CREATE PROC p_UpdateSpreaderID
	@UserID INT,
	@OldCode VARCHAR(20),
	@newCode VARCHAR(20)
AS
BEGIN
	BEGIN TRAN
	BEGIN TRY
		IF NOT EXISTS(SELECT 1 FROM [QPPlatformDB].[dbo].[InviteCode] WHERE CodeID=@newCode)
		BEGIN
			INSERT [QPPlatformDB].[dbo].[InviteCode](CodeID,IsLiang,IsUse,LastTime)
			VALUES(@newCode,0,0,GETDATE())
			--RETURN -1 --邀请码不存在！
		END
		IF NOT EXISTS(SELECT 1 FROM [QPPlatformDB].[dbo].[InviteCode] WHERE CodeID=@newCode AND IsLiang=1)
		BEGIN
			ROLLBACK TRAN;
			RETURN -2 --邀请码已被占有！
		END
		IF EXISTS(SELECT 1 FROM [QPAccountsDB].[dbo].[AccountsInfoEx] WHERE [InviteCode]=@newCode AND UserID<>@UserID)
		BEGIN
			ROLLBACK TRAN;
			RETURN -2 --邀请码已被占有！
		END

		UPDATE [QPPlatformDB].[dbo].[InviteCode]
		SET IsUse=0
		WHERE CodeID=@OldCode

		UPDATE [QPPlatformDB].[dbo].[InviteCode]
		SET IsUse=1
		WHERE CodeID=@newCode

		IF EXISTS(SELECT 1 FROM [QPAccountsDB].[dbo].[AccountsInfoEx] WHERE UserID=@UserID)
		BEGIN
			UPDATE ax
			SET ax.InviteCode=@newCode
			FROM [QPAccountsDB].[dbo].[AccountsInfoEx] ax
			WHERE UserID=@UserID
		END
		ELSE 
		BEGIN
			INSERT [QPAccountsDB].[dbo].[AccountsInfoEx](UserID,InviteCode,LastTime)
			VALUES(@UserID,@newCode,getdate())
		END

		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN;
		THROW
	END CATCH
END

GO


IF NOT EXISTS(SELECT 1 FROM dbo.SYSOBJECTS WHERE xtype='U' AND OBJECT_ID('[AgentSpreaderOptions]')=ID)
--	DROP TABLE AgentSpreaderOptions
--GO
CREATE TABLE [dbo].[AgentSpreaderOptions](
		[RoleID] [int] NOT NULL,
		[GradeID] [int] NOT NULL,
		[TotalSpreaderRate] [int] NULL,
		[ASpreaderRate] [int] NULL,
		[BSpreaderRate] [int] NULL,
		[CSpreaderRate] [int] NULL,
	 CONSTRAINT [PK_AgentSpreaderOptions] PRIMARY KEY CLUSTERED 
	(
		[RoleID],[GradeID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

GO


--保存分享设置
IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('p_AddSpreaderOptions')=id AND xtype='P')
	DROP PROC p_AddSpreaderOptions
GO
CREATE PROC p_AddSpreaderOptions
	@RoleID INT,
	@GradeID INT,
	@totalSpreaderRate INT,
	@ASpreaderRate INT,
	@BSpreaderRate INT,
	@CSpreaderRate INT
AS
BEGIN
	BEGIN TRAN
	BEGIN TRY
		IF @RoleID=-1
		BEGIN
			IF @GradeID=-1
			BEGIN
				TRUNCATE TABLE dbo.[AgentSpreaderOptions]
				INSERT dbo.[AgentSpreaderOptions]([RoleID],[GradeID],[TotalSpreaderRate],[ASpreaderRate],[BSpreaderRate],[CSpreaderRate])
				SELECT DISTINCT RoleID,GradeID,@totalSpreaderRate,@ASpreaderRate,@BSpreaderRate,@CSpreaderRate 
				FROM Base_Roles r
				INNER JOIN Base_AgentGrades ag ON r.AgentLevel IS NOT NULL AND r.AgentLevel=ag.AgentLevel
				WHERE RoleID NOT IN (SELECT [RoleID] FROM [AgentSpreaderOptions])
			END
			ELSE
			BEGIN
				UPDATE dbo.[AgentSpreaderOptions]
				SET [TotalSpreaderRate]=@totalSpreaderRate,[ASpreaderRate]=@ASpreaderRate,[BSpreaderRate]=@BSpreaderRate,[CSpreaderRate]=@CSpreaderRate
				WHERE  [GradeID]=@GradeID
				
				INSERT [AgentSpreaderOptions]([RoleID],[GradeID],[TotalSpreaderRate],[ASpreaderRate],[BSpreaderRate],[CSpreaderRate])
				SELECT RoleID,@GradeID,@totalSpreaderRate,@ASpreaderRate,@BSpreaderRate,@CSpreaderRate
				FROM Base_Roles r
				INNER JOIN Base_AgentGrades ag ON r.AgentLevel IS NOT NULL AND r.AgentLevel=ag.AgentLevel
				WHERE r.AgentLevel IS NOT NULL AND GradeID=@GradeID AND NOT EXISTS(SELECT 1 FROM dbo.[AgentSpreaderOptions] WHERE RoleID=r.RoleID AND GradeID=ag.GradeID)
			END
		END
		ELSE
		BEGIN
			IF @GradeID=-1
			BEGIN
				UPDATE dbo.[AgentSpreaderOptions]
				SET [TotalSpreaderRate]=@totalSpreaderRate,[ASpreaderRate]=@ASpreaderRate,[BSpreaderRate]=@BSpreaderRate,[CSpreaderRate]=@CSpreaderRate
				WHERE [RoleID]=@RoleID

				INSERT [AgentSpreaderOptions]([RoleID],[GradeID],[TotalSpreaderRate],[ASpreaderRate],[BSpreaderRate],[CSpreaderRate])
				SELECT @RoleID,ag.GradeID,@totalSpreaderRate,@ASpreaderRate,@BSpreaderRate,@CSpreaderRate
				FROM Base_Roles r
				INNER JOIN Base_AgentGrades ag ON r.AgentLevel IS NOT NULL AND r.AgentLevel=ag.AgentLevel
				WHERE [RoleID]=@RoleID AND NOT EXISTS(SELECT 1 FROM dbo.[AgentSpreaderOptions] WHERE RoleID=r.RoleID AND GradeID=ag.GradeID)
			END
			ELSE 
			BEGIN
				UPDATE dbo.[AgentSpreaderOptions]
				SET [TotalSpreaderRate]=@totalSpreaderRate,[ASpreaderRate]=@ASpreaderRate,[BSpreaderRate]=@BSpreaderRate,[CSpreaderRate]=@CSpreaderRate
				WHERE [RoleID]=@RoleID AND [GradeID]=@GradeID

				INSERT [AgentSpreaderOptions]([RoleID],[GradeID],[TotalSpreaderRate],[ASpreaderRate],[BSpreaderRate],[CSpreaderRate])
				SELECT @RoleID,@GradeID,@totalSpreaderRate,@ASpreaderRate,@BSpreaderRate,@CSpreaderRate
				FROM Base_Roles r
				INNER JOIN Base_AgentGrades ag ON r.AgentLevel IS NOT NULL AND r.AgentLevel=ag.AgentLevel
				WHERE [RoleID]=@RoleID AND [GradeID]=@GradeID AND NOT EXISTS(SELECT 1 FROM dbo.[AgentSpreaderOptions] WHERE RoleID=r.RoleID AND GradeID=ag.GradeID)
			END
		END
		COMMIT TRAN;
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN;
		THROW;
	END CATCH
END

GO


IF NOT EXISTS(SELECT * FROM sys.table_types WHERE name = 'AgentSpreaderOptionsTable' AND is_user_defined = 1)  
BEGIN  
CREATE TYPE AgentSpreaderOptionsTable AS TABLE  
(  
  RoleID INT NOT NULL,
  GradeID INT NOT NULL,  
  Rate SMALLINT NULL,
  ARate SMALLINT NULL,
  BRate SMALLINT NULL,
  CRate SMALLINT NULL
)  
END 

GO

IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('p_Update_AgentSpreaderOptions')=id AND type='P')
	DROP PROC p_Update_AgentSpreaderOptions
GO
CREATE PROC p_Update_AgentSpreaderOptions
	@ASOtable AgentSpreaderOptionsTable READONLY
AS
BEGIN
	UPDATE a
	SET a.TotalSpreaderRate=t.Rate,a.ASpreaderRate=t.ARate,a.BSpreaderRate=t.BRate,a.CSpreaderRate=t.CRate
	FROM AgentSpreaderOptions a
	LEFT JOIN @ASOtable t ON a.RoleID=t.RoleID AND a.GradeID=t.GradeID

	INSERT AgentSpreaderOptions(RoleID,GradeID,TotalSpreaderRate,ASpreaderRate,BSpreaderRate,CSpreaderRate)
	SELECT RoleID,GradeID,Rate,ARate,BRate,CRate FROM @ASOtable t
		WHERE NOT EXISTS(SELECT 1 FROM dbo.AgentSpreaderOptions WHERE RoleID=t.RoleID AND GradeID=t.GradeID)
END

GO



IF NOT EXISTS(SELECT * FROM sys.table_types WHERE name = 'AgentRevenesSetTable' AND is_user_defined = 1)  
BEGIN  
CREATE TYPE AgentRevenesSetTable AS TABLE  
(  
  UserID INT NOT NULL,
  Percentage SmallINT
)  
END 

GO

IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('p_Update_AgentRevenesSet')=id AND type='P')
	DROP PROC p_Update_AgentRevenesSet
GO
CREATE PROC p_Update_AgentRevenesSet
	@table AgentRevenesSetTable READONLY
AS
BEGIN
	UPDATE u
	SET u.Percentage=t.Percentage
	FROM dbo.Base_Users u
	LEFT JOIN @table t ON u.AgentID=t.UserID
END

GO


IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('f_GetParentsSpreaderUserID')=id AND type='FN')
	DROP FUNCTION f_GetParentsSpreaderUserID
GO
CREATE FUNCTION f_GetParentsSpreaderUserID(
	@UserID INT
)
RETURNS VARCHAR(MAX)
AS
BEGIN
DECLARE @str VARCHAR(MAX)=''

;WITH c AS(
	SELECT a.UserID,a.GameID,a.Accounts,a.NickName,a.SpreaderID FROM [QPAccountsDB].dbo.AccountsInfo a
	LEFT JOIN [QPAccountsDB].dbo.AccountsInfo a1 ON a.SpreaderID=a1.UserID
	WHERE a.UserID=@UserID
	UNION ALL 
	SELECT b.UserID,b.GameID,b.Accounts,b.NickName,b.SpreaderID FROM [QPAccountsDB].dbo.AccountsInfo b
	INNER JOIN c ON b.UserID=c.SpreaderID
)
--SELECT @str=@str+Convert(Varchar(10),c.GameID)+'('+c.NickName+')'+' > ' FROM c 
--SELECT @str=@str+'['+Convert(Varchar(10),c.GameID)+']'+c.Accounts+' > ' FROM c 
SELECT @str=@str+Convert(Varchar(10),c.GameID)+' > ' FROM c 
ORDER BY UserID
IF(@str<>'')
BEGIN
	SET @str=SUBSTRING(@str,1,len(@str)-1)
END

RETURN @str
END

GO



IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('f_GetParentsSpreaderUserID2')=id AND type='FN')
	DROP FUNCTION f_GetParentsSpreaderUserID2
GO
CREATE FUNCTION f_GetParentsSpreaderUserID2(
	@UserID INT
)
RETURNS VARCHAR(MAX)
AS
BEGIN
DECLARE @str VARCHAR(MAX)=''

;WITH c AS(
	SELECT a.UserID,a.GameID,a.Accounts,a.NickName,a.SpreaderID FROM [QPAccountsDB].dbo.AccountsInfo a
	LEFT JOIN [QPAccountsDB].dbo.AccountsInfo a1 ON a.SpreaderID=a1.UserID
	WHERE a.UserID=@UserID
	UNION ALL 
	SELECT b.UserID,b.GameID,b.Accounts,b.NickName,b.SpreaderID FROM [QPAccountsDB].dbo.AccountsInfo b
	INNER JOIN c ON b.UserID=c.SpreaderID
)
SELECT @str=@str+Convert(Varchar(10),c.GameID)+'('+IsNull(c.NickName,'')+')'+' > ' FROM c 
ORDER BY UserID
IF(@str<>'')
BEGIN
	SET @str=SUBSTRING(@str,1,len(@str)-1)
END

RETURN @str
END

GO


IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('f_GetChildrenSpreaderUserID')=id AND type='FN')
	DROP FUNCTION f_GetChildrenSpreaderUserID
GO
CREATE FUNCTION f_GetChildrenSpreaderUserID(
	@UserID INT
)
RETURNS VARCHAR(MAX)
AS
BEGIN
DECLARE @str VARCHAR(MAX)=''

;WITH c AS(
	SELECT a.UserID,a.Accounts,a.SpreaderID FROM [QPAccountsDB].dbo.AccountsInfo a
	LEFT JOIN [QPAccountsDB].dbo.AccountsInfo a1 ON a.SpreaderID=a1.UserID
	WHERE a.UserID=@UserID
	UNION ALL 
	SELECT b.UserID,b.Accounts,b.SpreaderID FROM [QPAccountsDB].dbo.AccountsInfo b
	INNER JOIN c ON b.SpreaderID=c.UserID
)
--SELECT * FROM c 
SELECT @str=@str+Convert(Varchar(10),c.UserID)+',' FROM c
ORDER BY c.UserID
IF(@str<>'')
BEGIN
	SET @str=SUBSTRING(@str,1,len(@str)-1)
END
ELSE
BEGIN
	Return '-1'
END

RETURN @str
END

GO


IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('p_GetChildrenSpreader')=id AND type='P')
	DROP PROC p_GetChildrenSpreader
GO
CREATE PROC p_GetChildrenSpreader
	@UserID INT,
	@pageIndex INT,
	@pageSize INT,
	@startDate VARCHAR(30),
	@endDate VARCHAR(30)
AS
BEGIN

	DECLARE @SQL VARCHAR(MAX)=''
	DECLARE @Where VARCHAR(1000)=''
	DECLARE @tempTable VARCHAR(50)=''
	SET @tempTable = Replace('##'+CONVERT(VARCHAR(50), NEWID()),'-','')

	IF @startDate <> ''
		SET @Where = @Where + ' AND c.RegisterDate >='''+@startDate+''''
	IF @endDate <> ''
		SET @Where = @Where + ' AND c.RegisterDate <= '''+@endDate+' 23:59:59'''

	SET @SQL='
	;WITH c AS(
		SELECT a.UserID,a.GameID,a.Accounts,a.NickName,a.SpreaderID SpreaderID2,a.AgentID AgentID2
			,dbo.f_GetParentsSpreaderUserID(a.UserID) Relation,dbo.f_GetParentsSpreaderUserID2(a.UserID) Relation2,a.RegisterDate 
		FROM [QPAccountsDB].dbo.AccountsInfo a
		WHERE a.UserID='+CONVERT(VARCHAR(30),@UserID)+'
		UNION ALL 
		SELECT b.UserID,b.GameID,b.Accounts,b.NickName,b.SpreaderID SpreaderID2,b.AgentID AgentID2
			,dbo.f_GetParentsSpreaderUserID(b.UserID) Relation,dbo.f_GetParentsSpreaderUserID2(b.UserID) Relation2,b.RegisterDate 
		FROM [QPAccountsDB].dbo.AccountsInfo b
		INNER JOIN c ON b.SpreaderID=c.UserID
	)	
	SELECT c.*,IsNull(a1.Accounts,''admin'') SpreaderName,IsNull(a1.NickName,''运营'') SpreaderNick,IsNull(a2.Accounts,''admin'') AgentName
		,a1.GameID SpreaderID,a2.GameID AgentID,Row_Number() OVER(Order BY c.UserID DESC ) RowNo 
		INTO '+@tempTable+' FROM c
	LEFT JOIN [QPAccountsDB].dbo.AccountsInfo a1 ON c.SpreaderID2=a1.UserID
	LEFT JOIN [QPAccountsDB].dbo.AccountsInfo a2 ON c.AgentID2=a2.UserID

	WHERE c.UserID<>'+CONVERT(VARCHAR(30),@UserID)+'    '+@Where+'

	SELECT totalCount=Count(1) FROM '+@tempTable+'

	SELECT * FROM '+@tempTable+'
	WHERE RowNo BETWEEN '+CONVERT(VARCHAR(10),(@pageIndex-1)*@pageSize+1)+' AND '+CONVERT(VARCHAR(10),@pageIndex*@pageSize)+'

'
	EXEC(@SQL)
END

GO


IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('p_ModifyBaseUser_ByID')=id AND type='P')
	DROP PROC p_ModifyBaseUser_ByID
GO
CREATE PROC p_ModifyBaseUser_ByID
	@UserID INT,
	@UserName VARCHAR(50),
	@Nullity SMALLINT,
	@canHasSubAgent BIT,
	@RoleID INT,
	@GradeID INT,
	@AgentLevelLimit INT,
	@Percentage SmallINT
AS
BEGIN
	UPDATE u
	SET u.Nullity=@Nullity,u.canHasSubAgent=@canHasSubAgent,u.AgentLevelLimit=@AgentLevelLimit,u.Percentage=@Percentage,u.RoleID=@RoleID,u.GradeID=@GradeID
	FROM Base_Users u
	WHERE u.UserID=@UserID 
	DECLARE @OrgUserName VARCHAR(50)
	select @OrgUserName=Username FROM Base_Users WHERE  UserID=@UserID 
	UPDATE QPAccountsDB.[dbo].[AccountsInfo]   SET  [NickName] =@UserName  WHERE Accounts=@OrgUserName
END

GO


--DROP TABLE SensitiveWordSet
IF NOT EXISTS(SELECT 1 FROM dbo.SYSOBJECTS WHERE xtype='U' AND OBJECT_ID('SensitiveWordSet')=ID)
	CREATE TABLE SensitiveWordSet(
		ID INT IDENTITY(1,1) PRIMARY KEY,
		SensitiveWord VARCHAR(MAX),
		LastTime DATETIME
	)

GO


IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('p_GetSensitiveWordSet')=id AND type='P')
	DROP PROC p_GetSensitiveWordSet
GO
CREATE PROC p_GetSensitiveWordSet
	@keyword VARCHAR(100),
	@pageIndex INT,
	@pageSize INT
AS
BEGIN
	DECLARE @SQL VARCHAR(MAX)=''
	DECLARE @Where VARCHAR(MAX)=''
	DECLARE @tempTable VARCHAR(50)=''
	IF @keyword<>''
		SET @Where=' AND SensitiveWord LIKE ''%'+@keyword+'%'''
	SET @tempTable = Replace('##'+CONVERT(VARCHAR(50), NEWID()),'-','')
	SET @SQL='
	SELECT *,ROW_NUMBER() OVER(ORDER BY LastTime DESC) AS RowNo INTO '+@tempTable+' FROM SensitiveWordSet
	WHERE 1=1 
	'+@Where+'

	SELECT totalCount=Count(1) FROM '+@tempTable+'

	SELECT * FROM '+@tempTable+' 	WHERE RowNo BETWEEN '+CONVERT(VARCHAR(10),(@pageIndex-1)*@pageSize+1)+' AND '+CONVERT(VARCHAR(10),@pageIndex*@pageSize)

	EXEC(@SQL)
END

GO

