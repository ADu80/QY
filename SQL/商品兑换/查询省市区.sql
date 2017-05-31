Use QPPlatformManagerDB
GO

IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('p_GetCityArea')=id AND type='P')
	DROP PROC p_GetCityArea
GO
CREATE PROC p_GetCityArea	
AS
BEGIN	
	SELECT * FROM [dbo].[Countrys]
	SELECT * FROM [dbo].[Provinces]
	SELECT * FROM [dbo].[Cities] --WHERE CityID>130000
END

GO

IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('p_GetDistrictArea')=id AND type='P')
	DROP PROC p_GetDistrictArea
GO
CREATE PROC p_GetDistrictArea
	@CityID VARCHAR(20)
AS
BEGIN
	IF @CityID IS NULL
		SELECT * FROM [dbo].[Districts] 	
	ELSE
		SELECT * FROM [dbo].[Districts] WHERE CityID=@CityID
END

GO
