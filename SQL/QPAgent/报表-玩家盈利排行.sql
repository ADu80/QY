USE [QPTreasureDB]
GO
--玩家盈利排行
IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('p_Report_GetProfit')=id AND xtype='P')
	DROP PROC p_Report_GetProfit
GO

CREATE PROC [dbo].[p_Report_GetProfit] 
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
	SET @SQL=' select top 100 d.*, a.GameID ,a.Accounts , a.NickName, ROW_NUMBER() OVER(ORDER BY d.profit DESC) RowNo
	INTO '+@tempTable+' from (select UserID ,sum(ChangeScore) as Profit
	FROM [QPRecordDB].[dbo].[RecordRichChange]  
	WHERE 1=1  and Reason IN (0,1) '	+@Where + ' 
	group by UserID   )d  
	left join [QPAccountsDB].[dbo].[AccountsInfo] a on a.UserID = d.UserID
	order by d.profit desc
	SELECT totalCount=Count(1) FROM '+ @tempTable + '
	SELECT * FROM ' + @tempTable + '
	WHERE RowNo BETWEEN '+CONVERT(VARCHAR(10),(@pageIndex-1)*@pageSize+1)+' AND '+CONVERT(VARCHAR(10),@pageIndex*@pageSize)+'
	ORDER BY RowNO 

	DROP TABLE '+@tempTable
   
	EXEC(@SQL)
END






GO


