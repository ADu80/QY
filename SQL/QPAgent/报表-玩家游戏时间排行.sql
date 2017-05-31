USE [QPTreasureDB]
GO
--玩家盈利排行
IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('p_Report_TimeCount')=id AND xtype='P')
	DROP PROC p_Report_TimeCount
GO

CREATE PROC [dbo].[p_Report_TimeCount] 
	@KindID INT, 
	@pageIndex INT=1,
	@pageSize INT=20
AS
BEGIN
	DECLARE @SQL VARCHAR(MAX)=''
	DECLARE @Where VARCHAR(1000)=''
	DECLARE @tempTable VARCHAR(50)=''
	SET @tempTable = Replace('##'+CONVERT(VARCHAR(50), NEWID()),'-','')

	--条件 
	IF @KindID<>-1
	BEGIN 
			SET @Where=@Where+' AND KindID='+Convert(VARCHAR(30),@KindID)
	END 
	--玩家盈利
	SET @SQL=' select top 100  [UserID]  ,[GameID]   ,[Accounts]   ,[NickName]   ,[PlayTimeCount]
      ,[OnLineTimeCount] , ROW_NUMBER() OVER(order by PlayTimeCount desc) RowNo
	INTO '+@tempTable+' from [QPAccountsDB].[dbo].[AccountsInfo]   
	order by PlayTimeCount desc
	SELECT totalCount=Count(1) FROM '+ @tempTable + '
	SELECT * FROM ' + @tempTable + '
	WHERE RowNo BETWEEN '+CONVERT(VARCHAR(10),(@pageIndex-1)*@pageSize+1)+' AND '+CONVERT(VARCHAR(10),@pageIndex*@pageSize)+'
	ORDER BY RowNO 

	DROP TABLE '+@tempTable
   
	EXEC(@SQL)
END






GO


