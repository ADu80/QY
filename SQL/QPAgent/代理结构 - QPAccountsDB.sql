/********************���ݿ�QPAccountsDB*******************/
USE QPAccountsDB
GO

----------------------------------------------------------------------
--�����ֶ�
IF NOT EXISTS(SELECT 1 FROM dbo.SYSCOLUMNS WHERE OBJECT_ID('AccountsInfo')=id AND name = 'SpreaderURL')
	ALTER TABLE AccountsInfo
	ADD SpreaderURL VARCHAR(200)

GO

IF NOT EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('AccountsInfoEx')=id AND xtype='U')
	CREATE TABLE [dbo].[AccountsInfoEx](
		[UserID] [int] NOT NULL,
		[InviteCode] [nvarchar](10) NOT NULL,
		[LastTime] [datetime] NOT NULL CONSTRAINT [DF_AccountsInfoEx_LastTime]  DEFAULT (getdate()),
	 CONSTRAINT [PK_AccountsInfoEx_UserID] PRIMARY KEY CLUSTERED 
	(
		[UserID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

GO

IF NOT EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('RecordUserLogin')=id AND xtype='U')
	CREATE TABLE [dbo].[RecordUserLogin](
		[ID] [bigint] IDENTITY(1,1) NOT NULL,
		[UserID] [int] NULL,
		[SocketID] [int] NULL,
		[LoginKind] [int] NULL CONSTRAINT [DF_RecordUserLogin_LoginType]  DEFAULT ((0)),
		[DeviceName] [nvarchar](20) NULL,
		[LoginIp] [nvarchar](20) NULL,
		[LoginTime] [datetime] NULL,
		[LogoutTime] [datetime] NULL,
	 CONSTRAINT [PK_RecordUserLogin] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

GO


----�����ֶ�
--IF NOT EXISTS(SELECT 1 FROM dbo.SYSCOLUMNS WHERE OBJECT_ID('AccountsInfo')=id AND name = 'SpreaderURL')
--	ALTER TABLE AccountsInfo
--	ADD SpreaderURL VARCHAR(200)

--GO


----------------------------------------------------------------------
------- �������
IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('NET_PM_AddAccount')=id AND xtype='P')
	DROP PROC [NET_PM_AddAccount]
GO
CREATE PROC [NET_PM_AddAccount]
(
	@strAccounts		NVARCHAR(31),			--�û��ʺ�
	@strNickName		NVARCHAR(31)=N'',		--�û��ǳ�
	@strLogonPass		NCHAR(32),				--��¼����
	@strInsurePass		NCHAR(32),				--��ȫ����
	@dwFaceID			SMALLINT ,				--ͷ��
	@strUnderWrite		NVARCHAR(18)=N'',		--����ǩ��
	@strPassPortID		NVARCHAR(18)=N'',		--���֤��
	@strCompellation	NVARCHAR(16)=N'',		--��ʵ����	
	
	@dwExperience		INT	= 0,				--������ֵ
	@dwPresent			INT	= 0,				--������ֵ
	@dwLoveLiness		INT	= 0,				--����ֵ��	
	@dwUserRight		INT	= 0,				--�û�Ȩ��
	@dwMasterRight		INT	= 0,				--����Ȩ��
	@dwServiceRight		INT	= 0,				--����Ȩ��
	@dwMasterOrder		TINYINT	= 0,			--����ȼ�
	
	@dwMemberOrder		TINYINT	= 0,			--��Ա�ȼ�
	@dtMemberOverDate	DATETIME='1980-01-01',	--��������
	@dtMemberSwitchDate DATETIME='1980-01-01',	--�л�ʱ��
	@dwGender			TINYINT = 1,			--�û��Ա�
	@dwNullity			TINYINT = 0,			--��ֹ����
	@dwStunDown			TINYINT = 0,			--�رձ�־
	@dwMoorMachine		TINYINT = 0,			--�̶�����	
	@strRegisterIP		NVARCHAR(15),			--ע���ַ
	@strRegisterMachine NVARCHAR(32)=N'',		--ע�����        
	@IsAndroid			TINYINT,
	@SpreaderID			INT=0,
	@AgentID			INT=0,
	                
	@strQQ				NVARCHAR(16)=N'',		--QQ ����
	@strEMail			NVARCHAR(32)=N'',		--�����ʼ�
	@strSeatPhone		NVARCHAR(32)=N'',		--�̶��绰
	@strMobilePhone		NVARCHAR(16)=N'',		--�ֻ�����
	@strDwellingPlace	NVARCHAR(128)=N'',		--��ϸסַ
	@strPostalCode		NVARCHAR(8)=N'',		--��������               
	@strUserNote		NVARCHAR(256)=N''		--�û���ע	
)
			
--WITH ENCRYPTION AS
AS
BEGIN
	-- ��������
	SET NOCOUNT ON

	DECLARE @dwUserID			INT,			-- �û���ʶ
			@GameID				INT,			-- ��ϷID
			@dtCurrentDate		DATETIME,
			@dwDefSpreaderScale DECIMAL(18,2)	--Ĭ�ϵĳ�ˮ����ֵ0.10
	SET @dwDefSpreaderScale = 0.10
	SET @dtCurrentDate =  GETDATE()

	-- ִ���߼�
	BEGIN TRY
		--��֤
		IF @strAccounts IS NULL OR @strAccounts = ''
			RETURN -2;	--��������
		IF @strNickName IS NULL OR @strNickName = ''
			SET @strNickName = @strAccounts
		IF EXISTS (SELECT * FROM AccountsInfo WHERE Accounts=@strAccounts OR RegAccounts=@strAccounts)
			RETURN -3;	--	�ʺ��Ѵ���
		IF EXISTS (SELECT * FROM AccountsInfo WHERE NickName=@strNickName)
			RETURN -4;	--	�ǳ��Ѵ���
		-- Ч���ʺ�
		IF EXISTS (SELECT [String] FROM ConfineContent(NOLOCK) WHERE (EnjoinOverDate IS NULL  OR EnjoinOverDate>=GETDATE()) AND CHARINDEX(String,@strAccounts)>0)
		BEGIN		
			RETURN -5;	-- ����������ʺ������������ַ���
		END
		
		-- ע�����ͽ��	
		DECLARE @GrantScoreCount AS INT
		DECLARE @DateID INT
		SET @DateID=CAST(CAST(GETDATE() AS FLOAT) AS INT)
		SELECT @GrantScoreCount=StatusValue FROM SystemStatusInfo(NOLOCK) WHERE StatusName=N'GrantScoreCount'
	
		IF @GrantScoreCount IS NULL OR @GrantScoreCount = '' OR @GrantScoreCount <= 0
			SET @GrantScoreCount = 0;
	
		IF @strNickName IS NULL OR 	@strNickName = ''
			SET @strNickName = @strAccounts
		IF @strInsurePass IS NULL OR @strInsurePass = ''
			SET @strInsurePass = @strLogonPass
		BEGIN TRAN
		--�û���Ϣ
		INSERT AccountsInfo
				( Accounts,NickName,RegAccounts,UnderWrite,PassPortID,
				  Compellation ,LogonPass ,InsurePass ,FaceID,Experience ,
				  Present,LoveLiness,UserRight ,MasterRight ,ServiceRight ,
				  MasterOrder ,MemberOrder ,MemberOverDate ,MemberSwitchDate ,Gender ,
				  Nullity ,StunDown ,MoorMachine ,LastLogonIP,RegisterIP ,
				  RegisterDate ,RegisterMobile ,RegisterMachine ,IsAndroid,SpreaderID,AgentID
				)
		VALUES  (				  			  
				  @strAccounts , -- Accounts - nvarchar(31)
				  @strNickName , -- NickName - nvarchar(31)
				  @strAccounts , -- RegAccounts - nvarchar(31)	
				  @strUnderWrite,			  
				  @strPassPortID , -- PassPortID - nvarchar(18)
				  
				  @strCompellation , -- Compellation - nvarchar(16)
				  @strLogonPass , -- LogonPass - nchar(32)
				  @strInsurePass , -- InsurePass - nchar(32)
				  @dwFaceID,
				  @dwExperience , -- Experience - int
				  
				  @dwPresent,							
				  @dwLoveLiness,
				  @dwUserRight , -- UserRight - int
				  @dwMasterRight , -- MasterRight - int
				  @dwServiceRight , -- ServiceRight - int
				  
				  @dwMasterOrder , -- MasterOrder - tinyint
				  @dwMemberOrder , -- MemberOrder - tinyint
				  @dtMemberOverDate , -- MemberOverDate - datetime
				  @dtMemberSwitchDate , -- MemberSwitchDate - datetime
				  @dwGender , -- Gender - tinyint
				  
				  @dwNullity, -- Nullity - tinyint
				  @dwStunDown , -- StunDown - tinyint
				  @dwMoorMachine , -- MoorMachine - tinyint	  
				  @strRegisterIP,      
				  @strRegisterIP , -- RegisterIP - nvarchar(15)
				  
				  @dtCurrentDate , -- RegisterDate - datetime
				  @strMobilePhone , -- RegisterMobile - nvarchar(11)
				  @strRegisterMachine , -- RegisterMachine - nvarchar(32)
				  @IsAndroid , -- IsAndroid - tinyint		
				  @SpreaderID,
				  @AgentID
				)
				
				--�û���ʶ
		        SET @dwUserID  = @@IDENTITY

				DECLARE @szInviteCode NVARCHAR(10)
				SELECT TOP 1 @szInviteCode=CodeID FROM QPPlatformDB.dbo.InviteCode WHERE IsUse=0 and isLiang<>1--ORDER BY NEWID()
				IF @szInviteCode IS NOT NULL
				BEGIN
					--INSERT dbo.AccountsInfoEx(UserID, InviteCode) VALUES(@dwUserID, @szInviteCode)
					INSERT dbo.AccountsInfoEx(UserID, InviteCode) VALUES(@dwUserID, @szInviteCode)
					UPDATE [QPPlatformDB].[dbo].[InviteCode] SET IsUse=1 WHERE CodeID=@szInviteCode
				END  
				ELSE
				BEGIN
					INSERT DebugTable(v1,v2,v3,v4,v5,v6,v7) VALUES('ע��',@strAccounts,@strNickName,@AgentID,'����������',@AgentID,0) 
				END 
		       
				--�û���ϸ��Ϣ
				INSERT IndividualDatum
						( UserID ,Compellation ,QQ ,EMail ,SeatPhone ,
						  MobilePhone ,DwellingPlace ,PostalCode ,CollectDate ,UserNote
						)
				VALUES  ( @dwUserID , -- UserID - int
						  @strCompellation , -- Compellation - nvarchar(16)
						  @strQQ , -- QQ - nvarchar(16)
						  @strEMail , -- EMail - nvarchar(32)
						  @strSeatPhone , -- SeatPhone - nvarchar(32)
						  @strMobilePhone , -- MobilePhone - nvarchar(16)
						  @strDwellingPlace , -- DwellingPlace - nvarchar(128)
						  @strPostalCode , -- PostalCode - nvarchar(8)
						  @dtCurrentDate , -- CollectDate - datetime
						  @strUserNote  -- UserNote - nvarchar(256)
						)
				-- �û��Ƹ���Ϣ
				INSERT QPTreasureDB.dbo.GameScoreInfo
				        ( UserID ,	
				          Score,
				          Revenue,
				          InsureScore,		          
				          UserRight ,
				          MasterRight ,
				          MasterOrder ,
				          LastLogonMachine,				         
				          LastLogonIP ,				         
				          RegisterIP ,
				          RegisterDate,
				          RegisterMachine
				           
				        )
				VALUES  ( @dwUserID , -- UserID - int
				          @GrantScoreCount , -- Score - bigint
				          0 , -- Revenue - bigint
				          0 , -- InsureScore - bigint				        
				          @dwUserRight , -- UserRight - int
				          @dwMasterRight , -- MasterRight - int
				          @dwMasterOrder , -- MasterOrder - tinyint	
				          '',			          
				          @strRegisterIP , -- LastLogonIP - nvarchar(15)
				          @strRegisterIP , -- RegisterIP - nvarchar(15)
				          @dtCurrentDate,  -- RegisterDate - datetime
				          ''				          				         
				        )    
			
			-- ��¼��־			
			UPDATE SystemStreamInfo SET WebRegisterSuccess=WebRegisterSuccess+1 WHERE DateID=@DateID
			IF @@ROWCOUNT=0 INSERT SystemStreamInfo (DateID, WebRegisterSuccess) VALUES (@DateID, 1)
			
			IF @GrantScoreCount > 0
			BEGIN 
				-- �������ͽ�Ҽ�¼
				UPDATE SystemGrantCount SET GrantScore=GrantScore+@GrantScoreCount, GrantCount=GrantCount+1 WHERE DateID=@DateID AND RegisterIP=@strRegisterIP

				-- �����¼
				IF @@ROWCOUNT=0		
					INSERT SystemGrantCount (DateID, RegisterIP, RegisterMachine, GrantScore, GrantCount) VALUES (@DateID, @strRegisterIP, '', @GrantScoreCount, 1)		
			END 
			
			-- ������ϷID
			SELECT @GameID=GameID FROM GameIdentifier(NOLOCK) WHERE UserID=@dwUserID
			IF @GameID IS NULL 
			BEGIN
				COMMIT TRAN			
				RETURN 1;--�û���ӳɹ�����δ�ɹ���ȡ��Ϸ ID ���룬ϵͳ�Ժ󽫸������䣡				
			END
			ELSE UPDATE AccountsInfo SET GameID=@GameID WHERE UserID=@dwUserID  
			     
			COMMIT TRAN			
			RETURN 0;--�ɹ�
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRAN
		END;
		THROW;
	END CATCH
END

GO


----------------------------------------------------------------------
--��������
IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('NET_PM_AddSilver')=id AND xtype='P')
	DROP PROC NET_PM_AddSilver
GO
CREATE PROC [dbo].[NET_PM_AddSilver]
(
	@AgentID			INT = 0,		        --�����ʶ
	@strAccounts		NVARCHAR(31),			--�û��ʺ�
	@strNickName		NVARCHAR(31)=N'',		--�û��ǳ�
	@strLogonPass		NCHAR(32),				--��¼����
	@strInsurePass		NCHAR(32),				--��ȫ����
	@dwFaceID			SMALLINT ,				--ͷ��
	@strUnderWrite		NVARCHAR(18)=N'',	--����ǩ��
	@strPassPortID		NVARCHAR(18)=N'',		--���֤��
	@strCompellation	NVARCHAR(16)=N'',		--��ʵ����	
	
	@dwExperience		INT	= 0,				--������ֵ
	@dwPresent			INT	= 0,				--������ֵ
	@dwLoveLiness		INT	= 0,				--����ֵ��	
	@dwUserRight		INT	= 0,				--�û�Ȩ��
	@dwMasterRight		INT	= 0,				--����Ȩ��
	@dwServiceRight		INT	= 0,				--����Ȩ��
	@dwMasterOrder		TINYINT	= 0,			--����ȼ�
	
	@dwMemberOrder		TINYINT	= 0,			--��Ա�ȼ�
	@dtMemberOverDate	DATETIME='1980-01-01',	--��������
	@dtMemberSwitchDate DATETIME='1980-01-01',	--�л�ʱ��
	@dwGender			TINYINT = 1,			--�û��Ա�
	@dwNullity			TINYINT = 0,			--��ֹ����
	@dwStunDown			TINYINT = 0,			--�رձ�־
	@dwMoorMachine		TINYINT = 0,			--�̶�����	
	@strRegisterIP		NVARCHAR(15),			--ע���ַ
	@strRegisterMachine NVARCHAR(32)=N'',		--ע�����        
	@IsAndroid			TINYINT,
	                
	@strQQ				NVARCHAR(16)=N'',		--QQ ����
	@strEMail			NVARCHAR(32)=N'',		--�����ʼ�
	@strSeatPhone		NVARCHAR(32)=N'',		--�̶��绰
	@strMobilePhone		NVARCHAR(16)=N'',		--�ֻ�����
	@strDwellingPlace	NVARCHAR(128)=N'',		--��ϸסַ
	@strPostalCode		NVARCHAR(8)=N'',		--��������               
	@strUserNote		NVARCHAR(256)=N'',		--�û���ע
	
	--�����룺
	@SpreaderID			INT,
	@IvitCode			INT,
	@Created			DATETIME,
	@Creator			VARCHAR(50),
	@Modified			DATETIME,
	@Modifior			VARCHAR(50),

	@canHasSubAgent		BIT,
	@AgentLevelLimit	INT,
	@RoleID				INT,
	@GradeID			INT,
	@Percentage			INT
)
			
--WITH ENCRYPTION AS
AS
BEGIN
	-- ��������
	SET NOCOUNT ON

	DECLARE @dwUserID			INT,			-- �û���ʶ
			@GameID				INT,			-- ��ϷID
			@dtCurrentDate		DATETIME,
			@dwDefSpreaderScale DECIMAL(18,2)	--Ĭ�ϵĳ�ˮ����ֵ0.10
	SET @dwDefSpreaderScale = 0.10
	SET @dtCurrentDate =  GETDATE()

	-- ִ���߼�
	BEGIN TRY
		--��֤
		IF @strAccounts IS NULL OR @strAccounts = ''
			RETURN -2;	--��������
		IF @strNickName IS NULL OR @strNickName = ''
			SET @strNickName = @strAccounts
		IF EXISTS (SELECT * FROM AccountsInfo WHERE Accounts=@strAccounts OR RegAccounts=@strAccounts)
			RETURN -3;	--	�ʺ��Ѵ���
		IF EXISTS (SELECT * FROM AccountsInfo WHERE NickName=@strNickName)
			RETURN -4;	--	�ǳ��Ѵ���
		-- Ч���ʺ�
		IF EXISTS (SELECT [String] FROM ConfineContent(NOLOCK) WHERE (EnjoinOverDate IS NULL  OR EnjoinOverDate>=GETDATE()) AND CHARINDEX(String,@strAccounts)>0)
		BEGIN		
			RETURN -5;	-- ����������ʺ������������ַ���
		END
		
		-- ע�����ͽ��	
		DECLARE @GrantScoreCount AS INT
		DECLARE @DateID INT
		SET @DateID=CAST(CAST(GETDATE() AS FLOAT) AS INT)
		SELECT @GrantScoreCount=StatusValue FROM SystemStatusInfo(NOLOCK) WHERE StatusName=N'GrantScoreCount'
	
		IF @GrantScoreCount IS NULL OR @GrantScoreCount = '' OR @GrantScoreCount <= 0
			SET @GrantScoreCount = 0;
	
		IF @strNickName IS NULL OR 	@strNickName = ''
			SET @strNickName = @strAccounts
		IF @strInsurePass IS NULL OR @strInsurePass = ''
			SET @strInsurePass = @strLogonPass
		BEGIN TRAN
		--�����ʺ�Ŀ¼
		DECLARE @AgentPath VARCHAR(MAX)
		SELECT @AgentPath=AgentPath FROM AccountsInfo WHERE UserID=@AgentID
		IF @AgentPath='' OR @AgentPath IS NULL
		BEGIN
			SET @AgentPath=@AgentID
		END
		--�û���Ϣ
		INSERT AccountsInfo
				(IsAgent,AgentID,AgentPath,Accounts,NickName,RegAccounts,UnderWrite,PassPortID,
				  Compellation ,LogonPass ,InsurePass ,FaceID,Experience ,
				  Present,LoveLiness,UserRight ,MasterRight ,ServiceRight ,
				  MasterOrder ,MemberOrder ,MemberOverDate ,MemberSwitchDate ,Gender ,
				  Nullity ,StunDown ,MoorMachine ,LastLogonIP,RegisterIP ,
				  RegisterDate ,RegisterMobile ,RegisterMachine ,IsAndroid,SpreaderID
				)
		VALUES  (
				  1,	
				  @AgentID,		--AgentID - int			
				  @AgentPath,    --AgentPath - VARCHAR(MAX)					  
				  @strAccounts , -- Accounts - nvarchar(31)
				  @strNickName , -- NickName - nvarchar(31)
				  @strAccounts , -- RegAccounts - nvarchar(31)	
				  @strUnderWrite,			  
				  @strPassPortID , -- PassPortID - nvarchar(18)
				  
				  @strCompellation , -- Compellation - nvarchar(16)
				  @strLogonPass , -- LogonPass - nchar(32)
				  @strInsurePass , -- InsurePass - nchar(32)
				  @dwFaceID,
				  @dwExperience , -- Experience - int
				  
				  @dwPresent,							
				  @dwLoveLiness,
				  @dwUserRight , -- UserRight - int
				  @dwMasterRight , -- MasterRight - int
				  @dwServiceRight , -- ServiceRight - int
				  
				  @dwMasterOrder , -- MasterOrder - tinyint
				  @dwMemberOrder , -- MemberOrder - tinyint
				  @dtMemberOverDate , -- MemberOverDate - datetime
				  @dtMemberSwitchDate , -- MemberSwitchDate - datetime
				  @dwGender , -- Gender - tinyint
				  
				  @dwNullity, -- Nullity - tinyint
				  @dwStunDown , -- StunDown - tinyint
				  @dwMoorMachine , -- MoorMachine - tinyint	  
				  @strRegisterIP,      
				  @strRegisterIP , -- RegisterIP - nvarchar(15)
				  
				  @dtCurrentDate , -- RegisterDate - datetime
				  @strMobilePhone , -- RegisterMobile - nvarchar(11)
				  @strRegisterMachine , -- RegisterMachine - nvarchar(32)
				  @IsAndroid ,  -- IsAndroid - tinyint
				  @SpreaderID
				)
				--�û���ʶ
				SET @dwUserID  = @@IDENTITY
				IF @AgentID=0
				BEGIN
					--SELECT @AgentRoleID=RoleID  FROM QPPlatformManagerDB.dbo.Base_Roles where AgentLevel=1
					UPDATE AccountsInfo SET AgentPath=convert(varchar,@dwUserID) WHERE USERID = @dwUserID
				END
				ELSE
				BEGIN
					--DECLARE @level INT
					--SELECT @level=r.AgentLevel FROM QPPlatformManagerDB.dbo.Base_Users u 
					--INNER JOIN QPPlatformManagerDB.dbo.Base_Roles r ON u.RoleID=r.RoleID
					--WHERE u.AgentID=@AgentID
					--SET @level=@level+1
					--SELECT @AgentRoleID=RoleID  FROM QPPlatformManagerDB.dbo.Base_Roles WHERE AgentLevel=@level
					UPDATE AccountsInfo SET AgentPath=@AgentPath+','+convert(varchar,@dwUserID) WHERE USERID= @dwUserID
				END				
			   --���������¼�ʺ�
				IF @AgentLevelLimit=0
				BEGIN
					INSERT QPPlatformManagerDB.dbo.Base_Users(Username,[Password],RoleID,AgentID,canHasSubAgent,Percentage)
					VALUES(@strAccounts,@strLogonPass,@RoleID,@dwUserID,@canHasSubAgent,@Percentage)
				END
				ELSE
				BEGIN
					INSERT QPPlatformManagerDB.dbo.Base_Users(Username,[Password],RoleID,AgentID,canHasSubAgent,AgentLevelLimit,Percentage)
					VALUES(@strAccounts,@strLogonPass,@RoleID,@dwUserID,@canHasSubAgent,@AgentLevelLimit,@Percentage)
				END
				--����ȼ�
				UPDATE u
				SET u.GradeID=@GradeID
				FROM QPPlatformManagerDB.dbo.Base_Users u
				WHERE u.AgentID=@dwUserID

				--������
				DECLARE @szInviteCode NVARCHAR(10)
				SELECT TOP 1 @szInviteCode=CodeID FROM QPPlatformDB.dbo.InviteCode WHERE IsUse=0 and isLiang<>1--ORDER BY NEWID()
				IF @szInviteCode IS NOT NULL
				BEGIN
					INSERT dbo.AccountsInfoEx(UserID, InviteCode) VALUES(@dwUserID, @szInviteCode)
					UPDATE [QPPlatformDB].[dbo].[InviteCode] SET IsUse=1 WHERE CodeID=@szInviteCode
				END  
				ELSE
				BEGIN
					INSERT DebugTable(v1,v2,v3,v4,v5,v6,v7) VALUES('ע��',@strAccounts,@strNickName,@AgentID,'����������',@AgentID,0) 
				END 


				--�û���ϸ��Ϣ
				INSERT IndividualDatum
						( UserID ,Compellation ,QQ ,EMail ,SeatPhone ,
						  MobilePhone ,DwellingPlace ,PostalCode ,CollectDate ,UserNote
						)
				VALUES  ( @dwUserID , -- UserID - int
						  @strCompellation , -- Compellation - nvarchar(16)
						  @strQQ , -- QQ - nvarchar(16)
						  @strEMail , -- EMail - nvarchar(32)
						  @strSeatPhone , -- SeatPhone - nvarchar(32)
						  @strMobilePhone , -- MobilePhone - nvarchar(16)
						  @strDwellingPlace , -- DwellingPlace - nvarchar(128)
						  @strPostalCode , -- PostalCode - nvarchar(8)
						  @dtCurrentDate , -- CollectDate - datetime
						  @strUserNote  -- UserNote - nvarchar(256)
						)
				-- �û��Ƹ���Ϣ
				INSERT QPTreasureDB.dbo.GameScoreInfo
				        ( UserID ,	
				          Score,
				          Revenue,
				          InsureScore,		          
				          UserRight ,
				          MasterRight ,
				          MasterOrder ,
				          LastLogonMachine,				         
				          LastLogonIP ,				         
				          RegisterIP ,
				          RegisterDate,
				          RegisterMachine
				           
				        )
				VALUES  ( @dwUserID , -- UserID - int
				          @GrantScoreCount , -- Score - bigint
				          0 , -- Revenue - bigint
				          0 , -- InsureScore - bigint				        
				          @dwUserRight , -- UserRight - int
				          @dwMasterRight , -- MasterRight - int
				          @dwMasterOrder , -- MasterOrder - tinyint	
				          '',			          
				          @strRegisterIP , -- LastLogonIP - nvarchar(15)
				          @strRegisterIP , -- RegisterIP - nvarchar(15)
				          @dtCurrentDate,  -- RegisterDate - datetime
				          ''				          				         
				        )    
			
			-- ��¼��־			
			UPDATE SystemStreamInfo SET WebRegisterSuccess=WebRegisterSuccess+1 WHERE DateID=@DateID
			IF @@ROWCOUNT=0 INSERT SystemStreamInfo (DateID, WebRegisterSuccess) VALUES (@DateID, 1)
			
			IF @GrantScoreCount > 0
			BEGIN 
				-- �������ͽ�Ҽ�¼
				UPDATE SystemGrantCount SET GrantScore=GrantScore+@GrantScoreCount, GrantCount=GrantCount+1 WHERE DateID=@DateID AND RegisterIP=@strRegisterIP

				-- �����¼
				IF @@ROWCOUNT=0		
					INSERT SystemGrantCount (DateID, RegisterIP, RegisterMachine, GrantScore, GrantCount) VALUES (@DateID, @strRegisterIP, '', @GrantScoreCount, 1)		
			END 
			
			-- ������ϷID
			SELECT @GameID=GameID FROM GameIdentifier(NOLOCK) WHERE UserID=@dwUserID
			IF @GameID IS NULL 
			BEGIN
				COMMIT TRAN			
				RETURN 1;--�û���ӳɹ�����δ�ɹ���ȡ��Ϸ ID ���룬ϵͳ�Ժ󽫸������䣡				
			END
			ELSE UPDATE AccountsInfo SET GameID=@GameID WHERE UserID=@dwUserID  
			     
			COMMIT TRAN			
			RETURN 0;--�ɹ�
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRAN
		END;
		THROW;
	END CATCH
END

GO


----------------------------------------------------------------------
--��ͨ���ת����Ϊ�������
IF  EXISTS(SELECT 1 FROM dbo.SysObjects WHERE object_id('US_AccountsToallAgent_Agent')=id AND [type]='P')
	DROP PROC US_AccountsToallAgent_Agent
GO

CREATE PROC US_AccountsToallAgent_Agent
	@UserID INT,
	@nRoleID INT,
	@nGradeID INT
AS
BEGIN
	IF EXISTS(SELECT UserID FROM AccountsInfo WHERE UserID=@UserID AND AgentID IS NULL AND AgentPath IS NULL AND IsAgent IS NULL)
	BEGIN
		DECLARE @RoleID INT
		DECLARE @Username VARCHAR(30)
		DECLARE @Password VARCHAR(32)
		UPDATE AccountsInfo SET AgentID=0,AgentPath=CONVERT(VARCHAR,@UserID),IsAgent=1 WHERE UserID = @UserID AND AgentID IS NULL AND AgentPath IS NULL AND IsAgent IS NULL
		SELECT @Username=Accounts,@Password=LogonPass FROM AccountsInfo whEre UserID = @UserID
		SELECT @RoleID=RoleID FROM QPPlatformManagerDB.dbo.Base_Roles WHERE AgentLevel=1
		INSERT QPPlatformManagerDB.dbo.Base_Users(Username,[Password],RoleID,AgentID) VALUES(@Username,@Password,@RoleID,@UserID)
	END

	UPDATE QPPlatformManagerDB.dbo.Base_Users
	SET RoleID=@nRoleID,GradeID=@nGradeID
	WHERE UserID=@UserID

END

GO


