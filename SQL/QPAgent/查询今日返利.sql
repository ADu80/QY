USE [QPPlatformManagerDB]
GO
/****** Object:  StoredProcedure [dbo].[p_GetGamerSpreaderSumByDay]    Script Date: 2017/4/19 17:58:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[p_GetGamerSpreaderSumByDay]
	@UserID INT,
	@Day VARCHAR(10)
AS
BEGIN
	DECLARE @A VARCHAR(10),@B VARCHAR(10),@C VARCHAR(10),
			@SpreadSum BIGINT,@RealSpreadSum BIGINT,@RealSpreadSuma BIGINT,@RealSpreadSumb BIGINT

	SELECT @A=ARate,@B=BRate,@C=CRate FROM dbo.f_GetSpreaderRateByUserID(@UserID)

	declare @ytDay VARCHAR(10)
	set @ytDay= convert(VARCHAR(10),dateadd(DD,-1,@Day),23)

	SELECT a.Accounts,IsNull(SUM(s.ChangeScore),0) TodayWaste,ABS(IsNull(SUM(s.ChangeScore),0))*@A/100 TodayCommission 
	FROM QPAccountsDB.dbo.AccountsInfo a
	LEFT JOIN QPRecordDB.dbo.RecordRichChange s ON CONVERT(VARCHAR(10),s.LastTime,23)=@day AND s.Reason IN (0,1) AND s.UserID=a.UserID 
	WHERE a.IsAndroid=0 AND a.UserID=@UserID
	GROUP BY a.Accounts

	SELECT @RealSpreadSum =ABS(IsNull(SUM(s.ChangeScore),0))*@A/100   
	FROM QPAccountsDB.dbo.AccountsInfo a
	LEFT JOIN QPRecordDB.dbo.RecordRichChange s ON CONVERT(VARCHAR(10),s.LastTime,23)=@ytDay AND s.Reason IN (0,1) AND s.UserID=a.UserID 
	WHERE a.IsAndroid=0 AND a.UserID=@UserID
	GROUP BY a.Accounts


	SELECT a.Accounts,IsNull(SUM(s.ChangeScore),0) TodayWaste,ABS(IsNull(SUM(s.ChangeScore),0))*@B/100 TodayCommission 
	FROM QPAccountsDB.dbo.AccountsInfo a
	LEFT JOIN QPRecordDB.dbo.RecordRichChange s ON CONVERT(VARCHAR(10),s.LastTime,23)=@day AND s.Reason IN (0,1) AND s.UserID=a.UserID
	WHERE a.IsAndroid=0 AND a.SpreaderID=@UserID
	GROUP BY a.Accounts

	SELECT a.Accounts,IsNull(SUM(s.ChangeScore),0) TodayWaste,ABS(IsNull(SUM(s.ChangeScore),0))*@C/100 TodayCommission 
	FROM QPAccountsDB.dbo.AccountsInfo a
	LEFT JOIN QPRecordDB.dbo.RecordRichChange s ON CONVERT(VARCHAR(10),s.LastTime,23)=@day AND s.Reason IN (0,1) AND s.UserID=a.UserID
	WHERE a.IsAndroid=0 AND a.SpreaderID IN (
		SELECT UserID FROM QPAccountsDB.dbo.AccountsInfo a1 
		WHERE a1.SpreaderID=@UserID
	)
	GROUP BY a.Accounts
	
	SELECT @RealSpreadSuma =SUM([SpreadSum])  
    FROM [QPPlatformManagerDB].[dbo].[RecordSpreadSum] where Waste >0 and UserID=@UserID

    SELECT  @RealSpreadSumb =SUM([SpreadSum]) 
    FROM [QPPlatformManagerDB].[dbo].[RecordSpreadSum] where Waste <0 and UserID=@UserID
  
   
	SELECT ISNULL(@RealSpreadSum,0) AS RealSpreadSum

	SELECT ISNULL(@RealSpreadSuma,0) AS RealSpreadSuma

	SELECT ISNULL(@RealSpreadSumb,0) AS RealSpreadSumb

END

