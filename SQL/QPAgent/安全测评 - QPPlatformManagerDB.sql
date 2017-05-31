USE QPPlatformManagerDB
GO


IF NOT EXISTS(SELECT 1 FROM dbo.SYSOBJECTS WHERE id=OBJECT_ID('UserLockInfo'))
CREATE TABLE UserLockInfo(
	UserID INT NOT NULL,
	LoginTime DATETIME,
	ErrorLogins INT,
	IsLock BIT DEFAULT(0)
)

GO



IF  EXISTS(SELECT 1 FROM dbo.SYSOBJECTS WHERE id=OBJECT_ID('P_Reset_Login_UserLock') AND xtype='P')
	DROP PROC P_Reset_Login_UserLock
GO

CREATE PROC P_Reset_Login_UserLock
	@strUserName VARCHAR(50)
AS
BEGIN	
	DECLARE @UserID INT
	SELECT @UserID=UserID FROM Base_Users WHERE UserName=@strUserName

	UPDATE u SET u.LoginTime=GETDATE(),u.ErrorLogins=0,u.IsLock=0
		FROM UserLockInfo u
		WHERE u.UserID=@UserID
END

GO

IF  EXISTS(SELECT 1 FROM dbo.SYSOBJECTS WHERE id=OBJECT_ID('P_Login_UserLock') AND xtype='P')
	DROP PROC P_Login_UserLock
GO

CREATE PROC P_Login_UserLock
	@strUserName VARCHAR(50)
AS
BEGIN
	DECLARE @UserID INT
	SELECT @UserID=UserID FROM Base_Users WHERE UserName=@strUserName

	IF NOT EXISTS(SELECT 1 FROM UserLockInfo WHERE UserID=@UserID)
	BEGIN
		INSERT UserLockInfo(UserID,LoginTime,ErrorLogins,IsLock)
		VALUES (@UserID,GETDATE(),1,0)
	END
	ELSE
	BEGIN
		DECLARE @MAX_LOGINS INT=5,
				@MAX_LONG INT=15,
				@ErrorLogins INT=0

		SELECT @ErrorLogins=IsNull(u.ErrorLogins,0) FROM UserLockInfo u WHERE u.UserID=@UserID
		SET @ErrorLogins=@ErrorLogins+1
		IF @ErrorLogins = @MAX_LOGINS
		BEGIN
			UPDATE u SET u.LoginTime=GETDATE(),u.ErrorLogins=@ErrorLogins,u.IsLock=1
			FROM UserLockInfo u
			WHERE u.UserID=@UserID
		END
		ELSE IF @ErrorLogins > @MAX_LOGINS
		BEGIN
			DECLARE @LoginTime DATETIME
			SELECT @LoginTime=IsNull(u.LoginTime,0) FROM UserLockInfo u WHERE u.UserID=@UserID
			IF DATEDIFF(mi,@LoginTime,GETDATE()) > @MAX_LONG
			BEGIN
				UPDATE u SET u.LoginTime=GETDATE(),u.ErrorLogins=1,u.IsLock=0
				FROM UserLockInfo u
				WHERE u.UserID=@UserID				
			END
		END
		ELSE BEGIN
			UPDATE u SET u.LoginTime=GETDATE(),u.ErrorLogins=@ErrorLogins
			FROM UserLockInfo u
			WHERE u.UserID=@UserID
		END
	END

END

GO

