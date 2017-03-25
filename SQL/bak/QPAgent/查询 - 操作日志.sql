USE QPPlatformManagerDB
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
		SET @Where=@Where+' AND l.LogTime <= '''+@endDate+''''
	IF @operationID<>-1
		SET @Where=@Where+' AND l.Operation = '+CONVERT(VARCHAR(10),@operationID)
	--查询操作日志
	SET @SQL='
	SELECT u.UserID AdminID,u.UserName,a.UserID,a.AgentID
	INTO '+@tempAccount+'
	FROM dbo.Base_Users u
	LEFT JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0 AND a.UserID=u.AgentID

	SELECT l.ID,o.Operation,l.LogContent,l.Operator OperatorID,a.UserName Operator,l.LogTime,l.LoginIP,ROW_NUMBER() OVER(ORDER BY l.LogTime DESC) RowNo 
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




