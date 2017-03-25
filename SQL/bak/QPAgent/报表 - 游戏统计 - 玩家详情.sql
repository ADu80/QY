USE [QPTreasureDB]
GO

----------------------------------------------------------------------
-----------Stored Procedure
-----------ͳ������ - �������
IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('p_Report_GetAllSum_Gamer')=id AND xtype='P')
	DROP PROC p_Report_GetAllSum_Gamer
GO
CREATE PROC p_Report_GetAllSum_Gamer
	@startDate VARCHAR(30),
	@endDate VARCHAR(30),
	@byUserID INT,
	@userType VARCHAR(10),
	@pageIndex INT=1,
	@pageSize INT=20
AS

BEGIN
	-- ��������
	SET NOCOUNT ON;	

	DECLARE @SQL VARCHAR(MAX)
	DECLARE @Where VARCHAR(1000)
	DECLARE @tempTable VARCHAR(50)
	SET @tempTable = Replace('##'+CONVERT(VARCHAR(50), NEWID()),'-','')

	--����
	SET @Where=''

	SET @Where=@Where+' AND s.UserID='+CONVERT(VARCHAR(20),@byUserID)

	IF @startDate<>''
		SET @Where=@Where+' AND s.LastTime >= '''+@startDate+''''
	IF @endDate<>''
		SET @Where=@Where+' AND s.LastTime < '''+@endDate+''''
		
	--�����Ϸ��¼
	SET @SQL='
	SELECT ''��ͨ��Ϸ����'' GroupName, IsNull(SUM(s.ChangeScore),0) GoldWaste
	INTO '+@tempTable+'
	FROM [QPRecordDB].[dbo].[RecordRichChange](NOLOCK) s
	INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0 AND s.UserID=a.UserID
	WHERE 1=1 AND s.Reason IN (0,1)
	'+	@Where+ '
	SELECT totalCount=Count(1) FROM '+ @tempTable + '

	SELECT * FROM ' + @tempTable + '
	DROP TABLE '+@tempTable

	EXEC(@SQL)

END

GO
