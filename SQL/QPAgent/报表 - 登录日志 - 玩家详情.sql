USE QPTreasureDB
GO

-----------ͳ������ - ��ֵ��¼
IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('p_Report_GetLoginLog')=id AND xtype='P')
	DROP PROC p_Report_GetLoginLog
GO
CREATE PROC p_Report_GetLoginLog
	@startDate VARCHAR(30),
	@endDate VARCHAR(30),
	@byUserID INT,
	@userType VARCHAR(10),
	@pageIndex INT=1,
	@pageSize INT=20
AS
BEGIN
	DECLARE @SQL VARCHAR(MAX)
	DECLARE @Where VARCHAR(1000)
	DECLARE @tempTable VARCHAR(50)
	SET @tempTable = Replace('##'+CONVERT(VARCHAR(50), NEWID()),'-','')

	--����
	SET @Where=''
		--����

	SET @Where=@Where+' AND a.UserID='+CONVERT(VARCHAR(20),@byUserID)

	IF @startDate<>''
		SET @Where=@Where+' AND s.LoginTime >= '''+@startDate+''''
	IF @endDate<>''
		SET @Where=@Where+' AND s.LoginTime < '''+@endDate+' 23:59:59'''

	--�����Ϸ��¼
	SET @SQL='
	SELECT DISTINCT s.UserID,a.GameID,a.Accounts,s.LoginTime,s.LogoutTime,s.LoginIP,CASE s.LoginKind WHEN 1 THEN ''��ҳ'' WHEN 2 THEN ''�ֻ�'' WHEN 3 THEN ''PC'' ELSE ''Ĭ��'' END LoginType,''Ĭ��'' LoginWeb,s.DeviceName DevName,Row_Number() OVER(ORDER BY s.LoginTime DESC) RowNo
	INTO '+@tempTable+'
	FROM [QPAccountsDB].[dbo].[RecordUserLogin] s
	INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0 AND s.UserID=a.UserID
	WHERE 1=1
'
	SET @SQL=@SQL+@Where
	SET @SQL = @SQL + '
	SELECT totalCount=Count(1) FROM '+ @tempTable + '

	SELECT * FROM ' + @tempTable + '
	WHERE RowNo BETWEEN '+CONVERT(VARCHAR(10),(@pageIndex-1)*@pageSize+1)+' AND '+CONVERT(VARCHAR(10),@pageIndex*@pageSize)+'
	ORDER BY RowNo
	DROP TABLE '+@tempTable

	--SELECT @SQL
	EXEC(@SQL)
END

GO


