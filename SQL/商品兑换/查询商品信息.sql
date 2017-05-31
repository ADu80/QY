-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Use QPPlatformManagerDB
GO


IF EXISTS(SELECT 1 FROM dbo.SYSOBJECTS WHERE xtype='P' AND OBJECT_ID('EC_Get_Goods_ByID')=ID)
	DROP PROC EC_Get_Goods_ByID
GO
CREATE PROCEDURE  [dbo].[EC_Get_Goods_ByID]
	@GoodID INT
AS
BEGIN
	SELECT [ID],[GoodNo],[GoodName],[CategoryID],[PointPrice],[ScorePrice],[DiamondPrice],[PayType],[IntroImg],[OnShelfDate],[OffShelfDate],[ShelfStatus],[Created],[Modified] 
	FROM EC_Goods WHERE ID=@GoodID
END


GO


IF EXISTS(SELECT 1 FROM dbo.SYSOBJECTS WHERE xtype='P' AND OBJECT_ID('EC_Get_Goods')=ID)
	DROP PROC EC_Get_Goods
GO
CREATE PROCEDURE  [dbo].[EC_Get_Goods]
	@CategoryID INT,
	@GoodName VARCHAR(50),  
	@pageIndex INT=1,
	@pageSize INT=20
AS
BEGIN
	DECLARE @SQL VARCHAR(MAX)=''
	DECLARE @Where VARCHAR(1000)=''
	DECLARE @tempTable VARCHAR(50)=''
	DECLARE @tempTable2 VARCHAR(50)=''
	SET @tempTable = Replace('##'+CONVERT(VARCHAR(50), NEWID()),'-','')
	SET @tempTable2 = Replace('##'+CONVERT(VARCHAR(50), NEWID()),'-','')

	 
	IF @GoodName<>''
	    SET @Where=@Where+' AND a.GoodName  LIKE ''%'+@GoodName+'%''' 

    IF @CategoryID<>''
	    SET @Where=@Where+' AND a.CategoryID  ='+Convert(VARCHAR(30),@CategoryID)

      
	
	SET @SQL=' 
      select a.[ID]  ,a.[GoodNo]
      ,a.[GoodName]   ,a.[CategoryID]     ,a.[PointPrice]  ,a.[ScorePrice]   ,a.[DiamondPrice],
	   a.PayType ,
	   case when a.PayType=''1'' then a.[ScorePrice]  when  a.PayType=''2'' then a.DiamondPrice when  a.PayType=''3'' then a.[PointPrice] end PayPrice
       ,a.[IntroImg]   ,a.[OffShelfDate]  ,a.[ShelfStatus]  ,a.[Created]   ,a.[Modified]
	  ,c.Category  ,ROW_NUMBER() OVER(ORDER BY a.ID DESC) RowNo  
      INTO '+@tempTable+'
      FROM [QPPlatformManagerDB].[dbo].[EC_Goods] a
      left join [QPPlatformManagerDB].[dbo].[EC_GoodsCategory] c on c.ID = a.CategoryID
      where a.ShelfStatus =1  '	+@Where + '
      
      SELECT * INTO '+@tempTable2+' FROM ' + @tempTable + '
      WHERE RowNo BETWEEN '+CONVERT(VARCHAR(10),(@pageIndex-1)*@pageSize+1)+' AND '+CONVERT(VARCHAR(10),@pageIndex*@pageSize)+'
      ORDER BY RowNO 

      SELECT totalCount=Count(1) FROM '+ @tempTable + '
	  SELECT * FROM ' + @tempTable2 + '
	  SELECT * FROM EC_GoodsImages WHERE GoodID IN (SELECT ID FROM ' + @tempTable2 + ')

      DROP TABLE '+@tempTable

	--SELECT @SQL
	EXEC(@SQL)
END

GO