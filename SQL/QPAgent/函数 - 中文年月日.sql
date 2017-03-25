/*ת��������������*/
Use [QPPlatformManagerDB]
GO

IF EXISTS(SELECT * FROM dbo.SYSOBJECTS WHERE OBJECT_ID('f_GetAgentWaste')=id AND xtype='FN')
	DROP FUNCTION f_GetFormatDate_CN
GO
CREATE FUNCTION f_GetFormatDate_CN(
	@date VARCHAR(100)
)
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @outputdate VARCHAR(100)
	SET @outputdate= CONVERT(VARCHAR(10),YEAR(@date))+CONVERT(VARCHAR(10),MONTH(@date))+CONVERT(VARCHAR(10),DAY(@date))
	RETURN @outputdate
END

GO
