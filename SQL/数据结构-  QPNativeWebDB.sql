use QPNativeWebDB
GO


IF NOT EXISTS(SELECT 1 FROM dbo.SYSCOLUMNS WHERE OBJECT_ID('GameFeedbackInfo')=id AND name = 'QQ')
	ALTER TABLE GameFeedbackInfo
	ADD QQ VARCHAR(15)
	
IF NOT EXISTS(SELECT 1 FROM dbo.SYSCOLUMNS WHERE OBJECT_ID('GameFeedbackInfo')=id AND name = 'ftype')
	ALTER TABLE GameFeedbackInfo
	ADD ftype VARCHAR(15)

GO
	
IF NOT EXISTS(SELECT 1 FROM dbo.SYSCOLUMNS WHERE OBJECT_ID('GameIssueInfo')=id AND name = 'QQ')
	ALTER TABLE GameIssueInfo
	ADD QQ VARCHAR(15)

GO


----------------------------------------------------------------------------------------------------
--drop procedure [dbo].[NET_PW_InsertGameFeedback]
-- ���ⷴ��
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE id=OBJECT_ID('NET_PW_InsertGameFeedback') AND xtype='P')
	DROP PROC NET_PW_InsertGameFeedback
GO
Create PROCEDURE NET_PW_InsertGameFeedback
	@strAccounts		NVARCHAR(31),			-- �û��ʺ�

	@strTitle			NVARCHAR(512),			-- ��������
	@strContent			NVARCHAR(50),			-- ��������
	@strEMail			NVARCHAR(50),	-- ��ϵ��ʽ
	@strphone			NVARCHAR(50),
	@strQQ				NVARCHAR(15),
	@strClientIP		NVARCHAR(15),			-- ������ַ
	@strErrorDescribe	NVARCHAR(127) OUTPUT,	--�����Ϣ	
	@ftype				INT
  AS

-- ��������
SET NOCOUNT ON

-- ������Ϣ
DECLARE @UserID INT
DECLARE @Nullity BIT
DECLARE @StunDown BIT

-- ִ���߼�
BEGIN
	IF @strAccounts<>''
	BEGIN
		-- ��ѯ�û�
		SELECT @UserID=UserID,@Nullity=Nullity, @StunDown=StunDown
		--FROM QPAccountsDBLink.QPAccountsDB.dbo.AccountsInfo WHERE Accounts=@strAccounts
		FROM QPAccountsDB.dbo.AccountsInfo WHERE Accounts=@strAccounts

		-- �û�����
		IF @UserID IS NULL
		BEGIN
			SET @strErrorDescribe=N'�����ʺŲ����ڣ����֤���ٴ����룡'
			RETURN 1
		END	

		-- �ʺŽ�ֹ
		IF @Nullity<>0
		BEGIN
			SET @strErrorDescribe=N'�����ʺ���ʱ���ڶ���״̬������ϵ�ͻ����������˽���ϸ�����'
			RETURN 2
		END	

		-- �ʺŹر�
		IF @StunDown<>0
		BEGIN
			SET @strErrorDescribe=N'�����ʺ�ʹ���˰�ȫ�رչ��ܣ��������¿�ͨ����ܼ���ʹ�ã�'
			RETURN 3
		END	
	END	

	-- ��������
	INSERT INTO GameFeedbackInfo(FeedbackTitle,FeedbackContent,Accounts,EMail,ClientIP,Phone,QQ,Nullity,ftype)
	VALUES(@strTitle,@strContent,@strAccounts,@strEMail,@strClientIP,@strphone,@strQQ,1,@ftype)

	SET @strErrorDescribe=N'���ⷴ�������ɹ���'
END
RETURN 0

GO


----------------------------------------------------------------------------------------------------
--drop procedure [dbo].[NET_PW_InsertGameFeedback]
-- ���ⷴ��
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE id=OBJECT_ID('NET_PW_InsertGameIssueInfo') AND xtype='P')
	DROP PROC NET_PW_InsertGameIssueInfo
GO
Create PROCEDURE NET_PW_InsertGameIssueInfo
	@strAccounts VARCHAR(50),
	@strQQ VARCHAR(50),
	@issueTitle VARCHAR(50),
	@issueContent VARCHAR(MAX),
	@nullity BIT,
	@collectDate DATETIME,
	@modifyDate DATETIME,
	@strErrorDescribe	NVARCHAR(127) OUTPUT	--�����Ϣ	
AS

-- ��������
SET NOCOUNT ON

-- ������Ϣ
DECLARE @UserID INT
DECLARE @StunDown BIT

-- ִ���߼�
BEGIN
	IF @strAccounts<>''
	BEGIN
		-- ��ѯ�û�
		SELECT @UserID=UserID,@Nullity=Nullity, @StunDown=StunDown
		FROM QPAccountsDB.dbo.AccountsInfo WHERE Accounts=@strAccounts

		-- �û�����
		IF @UserID IS NULL
		BEGIN
			SET @strErrorDescribe=N'�����ʺŲ����ڣ����֤���ٴ����룡'
			RETURN 1
		END	

		-- �ʺŽ�ֹ
		IF @Nullity<>0
		BEGIN
			SET @strErrorDescribe=N'�����ʺ���ʱ���ڶ���״̬������ϵ�ͻ����������˽���ϸ�����'
			RETURN 2
		END	

		-- �ʺŹر�
		IF @StunDown<>0
		BEGIN
			SET @strErrorDescribe=N'�����ʺ�ʹ���˰�ȫ�رչ��ܣ��������¿�ͨ����ܼ���ʹ�ã�'
			RETURN 3
		END	
	END	

	-- ��������
	INSERT  GameIssueInfo([IssueTitle],[IssueContent],[Nullity],[CollectDate],[ModifyDate],QQ)
	VALUES(@issueTitle,@issueContent,@nullity,@collectDate,@modifyDate,@strQQ)

	SET @strErrorDescribe=N'���ⷴ�������ɹ���'
END
RETURN 0

GO

