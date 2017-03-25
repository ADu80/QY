/********************���ݿ�[QPTreasureDB]*******************/
USE [QPTreasureDB]
GO

--
IF NOT EXISTS(SELECT 1 FROM dbo.SYSCOLUMNS WHERE OBJECT_ID('GameScoreInfo')=id AND name ='RCard')
	ALTER TABLE GameScoreInfo
	ADD RCard BIGINT

GO

--
IF NOT EXISTS(SELECT 1 FROM dbo.SYSCOLUMNS WHERE OBJECT_ID('GameScoreInfo')=id AND name ='Diamond')
	ALTER TABLE GameScoreInfo
	ADD Diamond BIGINT

GO

----------------------------------------------------------------------
-----------Stored Procedure
-----------ͳ������ - ����
IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('NET_PM_StatInfo_Agent')=id AND xtype='P')
	DROP PROC NET_PM_StatInfo_Agent
GO
CREATE PROC NET_PM_StatInfo_Agent
	@UserID INT
AS

BEGIN
	-- ��������
	SET NOCOUNT ON;	

	--�û�ͳ��
	DECLARE @OnLineCount BIGINT					--��������
	DECLARE @Recharge BIGINT					--��ֵ���
	DECLARE @DirectGamerWaste BIGINT			--ֱ����ҽ������
	DECLARE @DirectGamerScore BIGINT			--ֱ����ҽ�ҿ��
	DECLARE @DirectGamerCount BIGINT			--ֱ���������
	DECLARE @DirectAgentCount BIGINT			--ֱ�Ӵ�������
	DECLARE @AllGamerWaste BIGINT				--ȫ����ҽ������
	DECLARE @AllGamerScore BIGINT				--ȫ����ҽ�ҿ��
	DECLARE @AllGamerCount BIGINT				--ȫ���������
	DECLARE @AllAgentCount BIGINT				--ȫ����������
	DECLARE @SpreadSum BIGINT

	--����
	DECLARE @SQL NVARCHAR(MAX)
	DECLARE @AllSubAgentIds VARCHAR(300)			--ȫ���Ӵ�����UserID
	SET @AllSubAgentIds=QPPlatformManagerDB.dbo.f_GetChildAgentID(@UserID)	

	--��������
	SET @SQL=N'SELECT @OnLineCount=COUNT(1) FROM  QPTreasureDB.dbo.GameScoreLocker(NOLOCK) s
				INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0 
					AND (a.AgentID IN ('+CONVERT(VARCHAR(30),@UserID)+','+@AllSubAgentIds+') OR a.UserID IN('+CONVERT(VARCHAR(30),@UserID)+','+@AllSubAgentIds+'))
					AND s.UserID=a.UserID'
	EXEC sp_executesql @SQL	, N'@OnLineCount BIGINT OUT'	, @OnLineCount OUT
	
	--��ֵ���
	SELECT @Recharge=SUM(PayAmount) FROM QPTreasureDB.dbo.PayOrder
		WHERE UserID=@UserID

	--**�������**--
	SELECT @DirectGamerCount=COUNT(UserID) FROM QPAccountsDB.dbo.AccountsInfo(NOLOCK) WHERE (AgentID=@UserID) OR (UserID=@UserID)
	SET @SQL=N'SELECT @AllGamerCount=COUNT(UserID) FROM QPAccountsDB.dbo.AccountsInfo(NOLOCK)  a
				WHERE a.IsAndroid=0 AND (a.AgentID IN ('+CONVERT(VARCHAR(30),@UserID)+','+@AllSubAgentIds+') OR a.UserID IN('+CONVERT(VARCHAR(30),@UserID)+','+@AllSubAgentIds+'))'
	EXEC sp_executesql @SQL	, N'@AllGamerCount BIGINT OUT'	, @AllGamerCount OUT
	SELECT @DirectAgentCount=COUNT(UserID) FROM QPAccountsDB.dbo.AccountsInfo(NOLOCK) WHERE IsAgent=1 AND AgentID=@UserID	
	SET @SQL=N'SELECT @AllAgentCount=COUNT(UserID) FROM QPAccountsDB.dbo.AccountsInfo(NOLOCK) a WHERE a.IsAndroid=0 AND a.IsAgent=1 AND (a.UserID IN('+@AllSubAgentIds+'))'
	EXEC sp_executesql @SQL	, N'@AllAgentCount BIGINT OUT'	, @AllAgentCount OUT

	--**��ҿ��**--
	SELECT  @DirectGamerScore=SUM(IsNull(Score,0)) FROM dbo.GameScoreInfo(NOLOCK) s 
		INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.UserID=s.UserID 
		WHERE (a.AgentID=@UserID) OR (a.UserID=@UserID)
	SET @SQL=N'SELECT @AllGamerScore=SUM(s.Score) FROM dbo.GameScoreInfo(NOLOCK) s 
				INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0  
					AND (a.AgentID IN ('+CONVERT(VARCHAR(30),@UserID)+','+@AllSubAgentIds+') OR a.UserID IN('+CONVERT(VARCHAR(30),@UserID)+','+@AllSubAgentIds+'))
					AND s.UserID=a.UserID'
	EXEC sp_executesql @SQL	, N'@AllGamerScore BIGINT OUT'	, @AllGamerScore OUT	

	--**������**--
	SELECT @DirectGamerWaste=SUM(s.ChangeScore) FROM QPRecordDB.dbo.RecordRichChange(NOLOCK) s
		INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.UserID=s.UserID
		WHERE (a.AgentID=@UserID OR a.UserID=@UserID) AND s.Reason IN (0,1)
	SET @SQL=N'SELECT @AllGamerWaste=SUM(s.ChangeScore) FROM QPRecordDB.dbo.RecordRichChange(NOLOCK) s 
				INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0  
					AND (a.AgentID IN ('+CONVERT(VARCHAR(30),@UserID)+','+@AllSubAgentIds+') OR a.UserID IN('+CONVERT(VARCHAR(30),@UserID)+','+@AllSubAgentIds+'))
					AND a.UserID=s.UserID
				WHERE s.Reason IN (0,1)'
	EXEC sp_executesql @SQL	, N'@AllGamerWaste BIGINT OUT'	, @AllGamerWaste OUT

	--�ܷ���
	SELECT @SpreadSum=IsNull(SUM(CONVERT(BIGINT,SubString(AttachmentList,3,len(AttachmentList)-2))),0)
		FROM [QPTreasureDB].[dbo].[UserSystemMail] s
		WHERE Title='������'

	--����
	SELECT  a.UserID,a.GameID,a.Accounts,a.NickName,
			IsNull(@OnLineCount,0) AS OnLineCount,						--��������
			IsNull(@Recharge,0) AS Recharge,												--��ֵ���
			ISNULL(@DirectGamerWaste,0) AS DirectGamerWaste,			--ֱ����ҽ������
			ISNULL(@DirectGamerScore,0) AS DirectGamerScore,			--ֱ����ҽ�ҿ��
			ISNULL(@DirectGamerCount,0) AS DirectGamerCount,			--ֱ���������
			ISNULL(@DirectAgentCount,0) AS DirectAgentCount,			--ֱ�Ӵ�������
			ISNULL(@AllGamerWaste,0) AS AllGamerWaste,					--ȫ����ҽ������
			ISNULL(@AllGamerScore,0) AS AllGamerScore,					--ȫ����ҽ�ҿ��
			ISNULL(@AllGamerCount,0) AS AllGamerCount,					--ȫ���������
			ISNULL(@AllAgentCount,0) AS AllAgentCount,					--ȫ����������
			u.Nullity AgentStatus,CASE WHEN IsNull(u.canHasSubAgent,0)=0 THEN '��' ELSE '��' END canHasSubAgent,u.AgentLevelLimit,u.Percentage ProfitRate,aa.[InviteCode] SpreaderID,a.RegisterDate SpreaderDate,a.SpreaderURL
	FROM QPAccountsDB.dbo.AccountsInfo a 
	INNER JOIN [QPPlatformManagerDB].dbo.Base_Users u ON a.UserID=u.AgentID
	LEFT JOIN QPAccountsDB.[dbo].[AccountsInfoEx] aa ON a.UserID=aa.UserID
	WHERE a.UserID=@UserID

END

GO




----------------------------------------------------------------------
-----------Stored Procedure
-----------ͳ������ - �ܴ�
IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('NET_PM_StatInfo_Admin')=id AND xtype='P')
	DROP PROC NET_PM_StatInfo_Admin
GO
CREATE PROC NET_PM_StatInfo_Admin
AS
BEGIN
	-- ��������
	SET NOCOUNT ON;	
	--�û�ͳ��
	DECLARE @OnLineCount BIGINT					--����������ȫ����
	DECLARE @AgentOnLineCount BIGINT			--��������������
	DECLARE @PlatformOnLineCount BIGINT			--����������ƽ̨��
	DECLARE @AllCount BIGINT					--���������ȫ����
	DECLARE @AgentCount BIGINT					--�������������
	DECLARE @TopAgentCount BIGINT				--����������ܴ���
	DECLARE @SubAgentCount BIGINT				--����������ִ���
	DECLARE @PlatformCount BIGINT				--���������ƽ̨��
	DECLARE @Recharge BIGINT=0					--��ֵ��ȫ����
	DECLARE @AgentRecharge BIGINT=0				--��ֵ������
	DECLARE @PlatformRecharge BIGINT=0			--��ֵ������ƽ̨��
	DECLARE @Score BIGINT						--���������ȫ����
	DECLARE @AgentScore BIGINT					--�������������
	DECLARE @PlatformScore BIGINT				--���������ƽ̨��
	DECLARE @Waste BIGINT						--�������
	DECLARE @AgentWaste BIGINT					--�������������
	DECLARE @PlatformWaste BIGINT				--���������ƽ̨��
	DECLARE @SpreadSum BIGINT

	DECLARE @SQL NVARCHAR(MAX)=''

	--��������
	SELECT @OnLineCount=COUNT(1) FROM  QPTreasureDB.dbo.GameScoreLocker(NOLOCK) s
		WHERE EXISTS(SELECT 1 FROM  QPAccountsDB.dbo.AccountsInfo WHERE IsAndroid=0 AND UserID=s.UserID)
	SELECT @AgentOnLineCount=COUNT(1) FROM  QPTreasureDB.dbo.GameScoreLocker(NOLOCK) s 
		INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0 AND a.AgentID IS NOT NULL AND a.AgentID<>0 AND s.UserID=a.UserID
	SELECT @PlatformOnLineCount=COUNT(1) FROM  QPTreasureDB.dbo.GameScoreLocker(NOLOCK) s 
		INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0 AND IsNULL(a.AgentID,0)=0 AND s.UserID=a.UserID

	--�������
	SELECT  @AllCount=COUNT(UserID) FROM QPAccountsDB.dbo.AccountsInfo(NOLOCK) a 
		WHERE a.IsAndroid=0
	SELECT  @AgentCount=COUNT(UserID) FROM QPAccountsDB.dbo.AccountsInfo(NOLOCK) a 
		WHERE a.IsAndroid=0 AND (a.AgentID IS NOT NULL AND a.AgentID<>0)
	SELECT  @PlatformCount=COUNT(UserID) FROM QPAccountsDB.dbo.AccountsInfo(NOLOCK) a 
		WHERE a.IsAndroid=0 AND IsNull(a.AgentID,0)=0
	SELECT  @TopAgentCount=COUNT(UserID) FROM QPAccountsDB.dbo.AccountsInfo(NOLOCK) a 
		WHERE a.IsAndroid=0 AND UserID IN (
			SELECT AgentID FROM QPPlatformManagerDB.dbo.Base_Users u
			INNER JOIN QPPlatformManagerDB.dbo.Base_Roles r ON u.RoleID=r.RoleID
			WHERE r.AgentLevel=1
		)
	SELECT  @SubAgentCount=COUNT(UserID) FROM QPAccountsDB.dbo.AccountsInfo(NOLOCK) a 
		WHERE a.IsAndroid=0 AND UserID IN (
			SELECT AgentID FROM QPPlatformManagerDB.dbo.Base_Users u
			INNER JOIN QPPlatformManagerDB.dbo.Base_Roles r ON u.RoleID=r.RoleID
			WHERE r.AgentLevel<>1
		)

	--��ֵ���
	SELECT @Recharge=SUM(s.PayAmount) FROM QPTreasureDB.dbo.PayOrder s	
	SELECT @AgentRecharge=SUM(s.PayAmount) FROM QPTreasureDB.dbo.PayOrder s	
		INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0 AND a.AgentID IS NOT NULL AND a.AgentID<>0 AND s.UserID=a.UserID
	SELECT @PlatformRecharge=SUM(s.PayAmount) FROM QPTreasureDB.dbo.PayOrder s	
		INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0 AND IsNULL(a.AgentID,0)=0 AND s.UserID=a.UserID

	--��ҿ��
	SELECT  @Score=SUM(IsNull(Score,0)) FROM dbo.GameScoreInfo(NOLOCK) s
		INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0 AND s.UserID=a.UserID
	SELECT  @AgentScore=SUM(IsNull(Score,0)) FROM dbo.GameScoreInfo(NOLOCK) s
		INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0 AND a.AgentID IS NOT NULL AND a.AgentID<>0 AND s.UserID=a.UserID
	SELECT  @PlatformScore=SUM(IsNull(Score,0)) FROM dbo.GameScoreInfo(NOLOCK) s
		INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0 AND IsNULL(a.AgentID,0)=0 AND s.UserID=a.UserID

	--�������
	SELECT @Waste=SUM(IsNull(s.ChangeScore,0)) FROM QPRecordDB.dbo.RecordRichChange s 
		INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0 AND s.UserID=a.UserID
		WHERE s.Reason IN (0,1)
	SELECT @AgentWaste=SUM(IsNull(s.ChangeScore,0)) FROM QPRecordDB.dbo.RecordRichChange s
		INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0 AND a.AgentID IS NOT NULL AND a.AgentID<>0 AND s.UserID=a.UserID
		WHERE s.Reason IN (0,1)
	SELECT @PlatformWaste=SUM(IsNull(s.ChangeScore,0)) FROM QPRecordDB.dbo.RecordRichChange s
		INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0 AND IsNULL(a.AgentID,0)=0 AND s.UserID=a.UserID
		WHERE s.Reason IN (0,1)

	--�ܷ���
	SELECT @SpreadSum=IsNull(SUM(CONVERT(BIGINT,SubString(AttachmentList,3,len(AttachmentList)-2))),0)
		FROM [QPTreasureDB].[dbo].[UserSystemMail] s
		WHERE Title='������ҽ���'

	--����
	SELECT  IsNull(@OnLineCount,0) AS OnLineCount,						--����������ȫ����
			IsNull(@AgentOnLineCount,0) AS AgentOnLineCount,			--��������������
			IsNull(@PlatformOnLineCount,0) AS PlatformOnLineCount,		--����������ƽ̨��
			IsNull(@Recharge,0) Recharge,								--��ֵ��ȫ����
			IsNull(@AgentRecharge,0) AgentRecharge,						--��ֵ������
			IsNull(@PlatformRecharge,0) PlatformRecharge,				--��ֵ��ƽ̨��
			IsNull(@AllCount,0) AS AllCount,							--���������ȫ����
			IsNull(@AgentCount,0) AS AgentCount,						--�������������
			IsNull(@TopAgentCount,0) AS TopAgentCount,					--����������ܴ���
			IsNull(@SubAgentCount,0) AS SubAgentCount,					--����������Ӵ���
			IsNull(@PlatformCount,0) AS PlatformCount,					--���������ƽ̨��

			ISNULL(@Score,0) AS Score,									--���������ȫ����
			ISNULL(@AgentScore,0) AS AgentScore,						--�������������
			ISNULL(@PlatformScore,0) AS PlatformScore,					--���������ƽ̨��

			ISNULL(@Waste,0) AS Waste,									--���������ȫ����
			ISNULL(@AgentWaste,0) AS AgentWaste,						--�������������
			ISNULL(@PlatformWaste,0) AS PlatformWaste,					--���������ƽ̨��
			ISNULL(@SpreadSum,0) AS SpreadSum							--����ܷ���

END


GO


---------------------------------------------------------------------
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE id=OBJECT_ID('NET_PM_GrantRcard') AND [type]='P')
	DROP PROC NET_PM_GrantRcard
GO
CREATE PROC [dbo].[NET_PM_GrantRcard]
(	
	@strUserIDList	NVARCHAR(1000),	--�û���ʶ���ַ���
	@dwAddRcard		DECIMAL(18,2),	--���ͷ���
	@strReason 		NVARCHAR(32),	--����ԭ��
	@strClientIP	VARCHAR(15),		--IP��ַ
	@dwMasterID		INT			--�����߱�ʶ
)
			
  AS

BEGIN
	-- ��������
	SET NOCOUNT ON

	DECLARE @dwCounts		INT,			-- ���Ͷ��������	
			@dwTotalRcard	DECIMAL(18,2),	-- ���͵��ܷ���
			@dtCurrentDate	DATETIME		-- ��������
	SET @dtCurrentDate =  GETDATE()
	
	
	-- ִ���߼�
	BEGIN TRY
	-- ��֤
	IF @dwAddRcard IS NULL OR @dwAddRcard = 0
		RETURN -2;		-- ���ͽ���Ϊ��
	SELECT @dwCounts=COUNT(*) FROM dbo.WF_Split(@strUserIDList,',')
	IF @dwCounts<=0 
		RETURN -3;		-- δѡ�����Ͷ���
	SET @dwTotalRcard = @dwCounts * @dwTotalRcard	
	
	BEGIN TRAN
			--�������ͽ�Ҽ�¼		
			INSERT QPRecordDB.dbo.RecordGrantRCard(MasterID,ClientIP,CollectDate,UserID,CurRCard,RCard,Reason)
				SELECT @dwMasterID,@strClientIP,@dtCurrentDate,a.rs,b.RCard,@dwAddRcard,@strReason
				FROM WF_Split(@strUserIDList,',') a LEFT JOIN GameScoreInfo b ON a.rs = b.UserID			 
			
			--����������н��
			UPDATE GameScoreInfo SET Rcard=(CASE WHEN Rcard+@dwAddRcard<0 THEN 0 WHEN Rcard+@dwAddRcard>=0 THEN Rcard+@dwAddRcard end) 
			WHERE UserID IN (SELECT rs FROM dbo.WF_Split(@strUserIDList,','))
			
			--û�н�Ҽ�¼��������н�Ҹ���
			INSERT INTO GameScoreInfo(UserID,Rcard) 
			SELECT rs,@dwAddRcard FROM dbo.WF_Split(@strUserIDList,',') WHERE rs NOT IN (SELECT UserID FROM dbo.GameScoreInfo)
			
		
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

---------------------------------------------------------------------
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE id=OBJECT_ID('NET_PM_GrantRcard_Agent') AND [type]='P')
	DROP PROC NET_PM_GrantRcard_Agent
GO
CREATE PROC [dbo].NET_PM_GrantRcard_Agent
(	
	@byUserID		INT,
	@strUserIDList	NVARCHAR(1000),	--�û���ʶ���ַ���
	@UserIDListCount INT,			--�����û�����
	@dwAddRcard		DECIMAL(18,2),	--���ͷ���
	@strReason 		NVARCHAR(32),	--����ԭ��
	@strClientIP	VARCHAR(15),		--IP��ַ
	@dwMasterID		INT			--�����߱�ʶ
)
			
  AS

BEGIN
	-- ��������
	SET NOCOUNT ON

	DECLARE @dwCounts		INT,			-- ���Ͷ��������	
			@dwTotalRcard	DECIMAL(18,2),	-- ���͵��ܷ���
			@dtCurrentDate	DATETIME		-- ��������
	SET @dtCurrentDate =  GETDATE()	
	
	-- ִ���߼�
	BEGIN TRY
	-- ��֤
	IF @dwAddRcard IS NULL OR @dwAddRcard = 0
		RETURN -2;		-- ���ͽ���Ϊ��
	SELECT @dwCounts=COUNT(*) FROM dbo.WF_Split(@strUserIDList,',')
	IF @dwCounts<=0 
		RETURN -3;		-- δѡ�����Ͷ���
	SET @dwTotalRcard = @dwCounts * @dwTotalRcard
	DECLARE @Rcard BIGINT
	SELECT @Rcard=SUM(RCard) FROM [dbo].[GameScoreInfo] WHERE UserID=@byUserID
	IF @dwAddRcard>@Rcard
	BEGIN
		RETURN -4		-- �������������̿��÷���
	END
			
	BEGIN TRAN
			--�������ͷ�����¼		
			INSERT QPRecordDB.dbo.RecordGrantRCard(MasterID,SendUserID,ClientIP,CollectDate,UserID,CurRCard,RCard,Reason)
				SELECT -1,@dwMasterID,@strClientIP,@dtCurrentDate,a.rs,b.RCard,@dwAddRcard,@strReason
				FROM WF_Split(@strUserIDList,',') a LEFT JOIN GameScoreInfo b ON a.rs = b.UserID			 
			
			--����������з���
			UPDATE GameScoreInfo SET Rcard=(CASE WHEN Rcard+@dwAddRcard<0 THEN 0 WHEN Rcard+@dwAddRcard>=0 THEN Rcard+@dwAddRcard end) 
			WHERE UserID IN (SELECT rs FROM dbo.WF_Split(@strUserIDList,','))
			
			UPDATE s SET s.Rcard=s.Rcard-@dwAddRcard*@UserIDListCount
			FROM GameScoreInfo s
			WHERE UserID=@byUserID

			--û�н�Ҽ�¼��������н�Ҹ���
			INSERT INTO GameScoreInfo(UserID,Rcard) 
			SELECT rs,@dwAddRcard FROM dbo.WF_Split(@strUserIDList,',') WHERE rs NOT IN (SELECT UserID FROM dbo.GameScoreInfo)			
		
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
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE id=OBJECT_ID('NET_PM_GrantTreasure') AND [type]='P')
	DROP PROC NET_PM_GrantTreasure
GO
Create PROC NET_PM_GrantTreasure
(	
	@strUserIDList	NVARCHAR(1000),	--�û���ʶ���ַ���
	@dwAddGold		DECIMAL(18,2),	--���ͽ��
	@dwMasterID		INT,			--�����߱�ʶ
	@strReason 		NVARCHAR(32),	--����ԭ��
	@strClientIP	VARCHAR(15)		--IP��ַ
)
			
AS

BEGIN
	-- ��������
	SET NOCOUNT ON

	DECLARE @dwCounts		INT,			-- ���Ͷ��������	
			@dwTotalGold	DECIMAL(18,2),	-- ���͵��ܽ��
			@dtCurrentDate	DATETIME		-- ��������
	SET @dtCurrentDate =  GETDATE()
	
	
	-- ִ���߼�
	BEGIN TRY
	-- ��֤
	IF @dwAddGold IS NULL OR @dwAddGold = 0
		RETURN -2;		-- ���ͽ���Ϊ��
	SELECT @dwCounts=COUNT(*) FROM dbo.WF_Split(@strUserIDList,',')
	IF @dwCounts<=0 
		RETURN -3;		-- δѡ�����Ͷ���
	SET @dwTotalGold = @dwCounts * @dwAddGold	
	
	BEGIN TRAN
			--�������ͽ�Ҽ�¼		
			INSERT QPRecordDB.dbo.RecordGrantTreasure(MasterID,ClientIP,CollectDate,UserID,CurGold,AddGold,Reason)
				SELECT @dwMasterID,@strClientIP,@dtCurrentDate,a.rs,ISNULL(b.Score,0),@dwAddGold,@strReason
				FROM WF_Split(@strUserIDList,',') a LEFT JOIN GameScoreInfo b ON a.rs = b.UserID			 
			
			--����������н��
			UPDATE GameScoreInfo SET Score=(CASE WHEN Score+@dwAddGold<0 THEN 0 WHEN Score+@dwAddGold>=0 THEN Score+@dwAddGold end) 
			WHERE UserID IN (SELECT rs FROM dbo.WF_Split(@strUserIDList,','))
			
			--û�н�Ҽ�¼��������н�Ҹ���
			INSERT INTO GameScoreInfo(UserID,Score) 
			SELECT rs,@dwAddGold FROM dbo.WF_Split(@strUserIDList,',') WHERE rs NOT IN (SELECT UserID FROM dbo.GameScoreInfo)
			
			
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
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE id=OBJECT_ID('NET_PM_GrantTreasure_Agent') AND [type]='P')
	DROP PROC NET_PM_GrantTreasure_Agent
GO

Create PROC NET_PM_GrantTreasure_Agent
(	
	@byUserID		INT,			--������UserID
	@strUserIDList	NVARCHAR(1000),	--�û���ʶ���ַ���
	@UserIDListCount INT,
	@dwAddGold		DECIMAL(18,2),	--���ͽ��
	@dwMasterID		INT,			--�����߱�ʶ
	@strReason 		NVARCHAR(32),	--����ԭ��
	@strClientIP	VARCHAR(15)		--IP��ַ
)
			
AS

BEGIN
	-- ��������
	SET NOCOUNT ON

	DECLARE @dwCounts		INT,			-- ���Ͷ��������	
			@dwTotalGold	DECIMAL(18,2),	-- ���͵��ܽ��
			@dtCurrentDate	DATETIME		-- ��������
	SET @dtCurrentDate =  GETDATE()
	
	
	-- ִ���߼�
	BEGIN TRY
	-- ��֤
	IF @dwAddGold IS NULL OR @dwAddGold = 0
		RETURN -2;		-- ���ͽ���Ϊ��
	SELECT @dwCounts=COUNT(*) FROM dbo.WF_Split(@strUserIDList,',')
	IF @dwCounts<=0 
		RETURN -3;		-- δѡ�����Ͷ���
	SET @dwTotalGold = @dwCounts * @dwAddGold	

	DECLARE @score BIGINT
	SELECT @score=SUM(Score) FROM [dbo].[GameScoreInfo] WHERE UserID=@byUserID
	IF @dwAddGold>@Score
	BEGIN
		RETURN -4		-- ��ҳ��������̿��ý��
	END
	
	BEGIN TRAN
			--�������ͽ�Ҽ�¼		
			INSERT QPRecordDB.dbo.RecordGrantTreasure(MasterID,SendUserID,ClientIP,CollectDate,UserID,CurGold,AddGold,Reason)
				SELECT -1,@dwMasterID,@strClientIP,@dtCurrentDate,a.rs,ISNULL(b.Score,0),@dwAddGold,@strReason
				FROM WF_Split(@strUserIDList,',') a LEFT JOIN GameScoreInfo b ON a.rs = b.UserID			 
			
			--����������н��
			UPDATE GameScoreInfo SET Score=(CASE WHEN Score+@dwAddGold<0 THEN 0 WHEN Score+@dwAddGold>=0 THEN Score+@dwAddGold end) 
			WHERE UserID IN (SELECT rs FROM dbo.WF_Split(@strUserIDList,','))
			
			UPDATE s SET s.Score=s.Score-@dwAddGold*@UserIDListCount
			FROM GameScoreInfo s
			WHERE UserID=@byUserID

			--û�н�Ҽ�¼��������н�Ҹ���
			INSERT INTO GameScoreInfo(UserID,Score) 
			SELECT rs,@dwAddGold FROM dbo.WF_Split(@strUserIDList,',') WHERE rs NOT IN (SELECT UserID FROM dbo.GameScoreInfo)
			
			
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


IF NOT EXISTS(SELECT 1 FROM [dbo].syscolumns WHERE object_id('UserSystemMail')=id AND name='SpreadDate')
BEGIN
	ALTER TABLE [dbo].[UserSystemMail]
	ADD SpreadDate VARCHAR(10)
END
GO




