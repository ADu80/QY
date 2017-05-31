-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Use QPPlatformManagerDB
GO


IF EXISTS(SELECT 1 FROM dbo.SYSOBJECTS WHERE xtype='P' AND OBJECT_ID('EC_Get_Addr')=ID)
	DROP PROC EC_Get_Addr
GO
CREATE PROCEDURE  [dbo].[EC_Get_Addr]
    @AddrID int, --地址ID
	@GameID int --用户玩家Id
AS
BEGIN
	DECLARE @SQL VARCHAR(MAX)=''
    DECLARE @Where VARCHAR(1000)=''
	IF @GameID >0
	    SET @Where=@Where+' AND    a.GameID ='+Convert(VARCHAR(30),@GameID)

	IF @AddrID >0
	    SET @Where=@Where+' AND    a.ID   ='+Convert(VARCHAR(30),@AddrID)
		
	SET @SQL=' SELECT   a.[ID] as AddrID    ,a.[GameID]   ,a.ReceiverName,a.ReceiverMobile ,a.[Addr]    ,a.[CountryID]
      ,a.[ProviceID]   ,a.[CityID]    ,a.[DistrictID]
      ,a.[Street]   ,isnull(a.IsDefault,0) IsDefault,p.ProvinceName   ,c.CityName   ,d.DistrictsName 
  FROM [QPPlatformManagerDB].[dbo].[EC_OrderAddr] a 
  left join [QPPlatformManagerDB].[dbo].[Provinces] p on p.ID= a.ProviceID
  left join [QPPlatformManagerDB].[dbo].[Cities]  c on c.ID= a.CityID 
  left join [QPPlatformManagerDB].[dbo].[Districts] d on d.ID= a.DistrictID
  where 1 =1  '	+@Where + ' order by a.IsDefault DESC	' 

	EXEC(@SQL)
END
